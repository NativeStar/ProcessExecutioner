MODDIR=${0%/*}
function onUsingKSU(){
	ui_print "_________________________________________"
	ui_print "Welcome to KernelSU!";
	ui_print "可借助WebUI方便地控制模块"
	ui_print "详情请在WebUI内查看🌸"
	#不准跳过人生 虽然没什么可说的(
	sleep 2s
}
ui_print "清洗那些累赘进程 还我内存!"
ui_print "(仅在KernelSU下进行测试)"
ui_print "Github:https://github.com/NativeStar/ProcessExecutioner"
ui_print "规则位于'/data/adb/processexecutioner.config'文件中"
ui_print "内容即要杀的进程名 每行一个 可执行热重载"
ui_print "可通过'Scene'等应用查看进程"
ui_print "内置几条作者自用规则作为参考 应该不会有副作用"
ui_print "规则尽量不要添加系统进程 没人知道会发生什么🐱"
ui_print "_________________________________________"
ui_print "既然它们自己不体面 只能帮它们体面了"
ui_print "可是这真的能改变什么吗"
ui_print "唉"
test -f "/data/adb/processexecutioner.config"
#没有规则
if [ "$?" == "1" ];then
	ui_print "正在释放默认规则文件..."
	unzip -n "$ZIPFILE" -d "$TMPDIR" >/dev/null
	cp "$TMPDIR/defaultRules" "/data/adb/processexecutioner.config"
else
	ui_print "已有规则文件 跳过释放!"
fi
#ksu
if [ "$KSU" ]; then
	onUsingKSU
else
	#不支持webui 把信息全打出来
	ui_print "_________________________________________"
	ui_print "Welcome to Magisk!";
	ui_print "********操作********"
	ui_print "可通过执行模块目录下'pauseOrResume.sh' 'reload.sh' 'stop.sh'操控"
	ui_print "pauseOrResume.sh:暂停或恢复模块运行"
	ui_print "reload.sh:一段时间后重载规则"
	ui_print "stop.sh:停止运行"
	ui_print "执行停止运行后将在下一轮检测中自动停止 这需要几秒时间"
	ui_print "且之后只能通过重启设备恢复运行🌷"
	#不准跳过人生(
	sleep 3s
fi
ui_print "安装完成 感谢使用"
ui_print "重启设备后生效"