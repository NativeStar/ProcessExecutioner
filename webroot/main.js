import {exec,toast} from "./ksu.js";
let killBtn,changeStateBtn,reloadBtn;
//瞎搞的
//够用
window.addEventListener("load",async ()=>{
	changeStateBtn=document.getElementById("changeStateBtn");
	killBtn=document.getElementById("killButton");
	reloadBtn=document.getElementById("reloadButton");
	const result=await exec("test -f /data/adb/modules/ProcessExecutioner/pause");
	const hasSuicideFile=await exec("test -f /data/adb/modules/ProcessExecutioner/suicide");
	const moduleDead=await exec("test -f  /data/adb/modules/ProcessExecutioner/dead");
	const canReload=await exec("test -f  /data/adb/modules/ProcessExecutioner/reload")
	if(result.errno===0){
		//暂停
		changeStateBtn.innerText="恢复"
		document.getElementById("state").innerText="已暂停"
	}else if(result.errno===1){
		changeStateBtn.innerText="暂停"
		document.getElementById("state").innerText="运行中"
	}else{
		//异常
		alert("未知返回值:"+result.errno);
		killBtn.disabled=true;
	}
	//停止按钮是否可用
	if(hasSuicideFile.errno===0||moduleDead.errno===0){
		document.getElementById("state").innerText="已停止";
		killBtn.disabled=true;
	}
	//重载按钮可用性
	if(canReload.errno===0){
		//存在文件
		reloadBtn.disabled=true;
	}
})
window.changeState=async ()=>{
	if(changeStateBtn.innerText==="恢复"){
		//恢复运行
		await exec("rm -f /data/adb/modules/ProcessExecutioner/pause");
		document.getElementById("state").innerText="运行中";
		changeStateBtn.innerText="暂停"
	}else{
		await exec("touch /data/adb/modules/ProcessExecutioner/pause");
		document.getElementById("state").innerText="已暂停";
		changeStateBtn.innerText="恢复"
	}
	toast("已执行");
}
window.kill=async ()=>{
	killBtn.disabled=true;
	document.getElementById("stopDialog").close();
	await exec("touch /data/adb/modules/ProcessExecutioner/suicide");
	toast("已执行");
	document.getElementById("state").innerText="等待停止...请以模块页面显示为准";
	setTimeout(()=>{
		document.getElementById("state").innerText="已停止";
	},12000)
}
window.reload=async ()=>{
	reloadBtn.disabled=true;
	await exec("touch  /data/adb/modules/ProcessExecutioner/reload");
	toast("已执行")
}