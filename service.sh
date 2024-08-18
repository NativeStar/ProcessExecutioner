#!/system/bin/sh
MODDIR=${0%/*};
#上次杀死
lastKilledCount=0;
#总击杀
killedCount=0;
#规则数量
rulesCount=0;
#暂停状态 写文件判断用
paused=0;
#规则
#检查
test -f "/data/adb/processexecutioner.config";
#获取数量
if [ "$?" == "1" ];then
	#复制默认模板
	cp "$MODDIR/defaultRules" "/data/adb/processexecutioner.config"
fi
rules=$(cat /data/adb/processexecutioner.config);
#初始显示规则数量
for line in $rules; do
	if [ line == "" ];then
		continue
	fi
	rulesCount=$(expr $rulesCount + 1);
done
# 删除标记
rm -f "$MODDIR/waitingReboot"
rm -f "$MODDIR/pause"
rm -f "$MODDIR/dead"
rm -f "$MODDIR/suicide"
rm -f "$MODDIR/suicide_update"
desc="(它们活着的意义是什么🤔) 已加载$rulesCount条规则 本次启动共处决0个进程 (反正不止去码头整点薯条😋)";
sed -i "s/description=.*/description=$desc/" $MODDIR/module.prop
#检测到文件即退出
checkExitFile(){
	test -f "$MODDIR/suicide"
	if [ "$?" == "0" ];then
		desc="[Stop Working](它们活着的意义是什么🤔) 已加载***条规则 本次启动共处决***个进程 (反正不止去码头整点薯条😋)";
    	sed -i "s/description=.*/description=$desc/" "$MODDIR/module.prop"
		#标记
    	rm -f "$MODDIR/suicide"
		touch "$MODDIR/dead"
    	sleep 2s
    	exit
    fi
    #更新 不动文件
    test -f "$MODDIR/suicide_update"
    if [ "$?" == "0" ];then
		#标记
    	rm -f "$MODDIR/suicide_update"
		touch "$MODDIR/dead"
    	sleep 2s
    	exit
    fi
}
onPause(){
	if [ "$paused" == "0" ];then
		desc="[Paused](它们活着的意义是什么🤔) 已加载$rulesCount条规则 本次启动共处决$killedCount个进程 (反正不止去码头整点薯条😋)";
    	sed -i "s/description=.*/description=$desc/" $MODDIR/module.prop
    	paused=1
	fi
}
checkReload(){
	test -f "$MODDIR/reload"
	if [ "$?" == "0" ];then
		rm -f "$MODDIR/reload"
		test -f "/data/adb/processexecutioner.config";
		# 规则给删了 玩毛啊
		if [ "$?" == "1" ];then
			desc="❌[ERROR]Missing config file";
			sed -i "s/description=.*/description=$desc/" $MODDIR/module.prop
			return 11
		fi
		#覆盖
		rules=$(cat /data/adb/processexecutioner.config);
		rulesCount=0;
		for line in $rules; do
			if [ line == "" ];then
				continue
			fi
			rulesCount=$(expr $rulesCount + 1);
		done
		desc="(它们活着的意义是什么🤔) 已加载$rulesCount条规则 本次启动共处决$killedCount个进程 (反正不止去码头整点薯条😋)";
		sed -i "s/description=.*/description=$desc/" $MODDIR/module.prop
    fi
}
#熄屏检测
skinOnScreenOff(){
	local isScreenOff=dumpsys deviceidle | grep mScreenOn
	if [ "$isScreenOff" != "mScreenOn=true" ];then
		return 1
	fi
	return 0
}
while true; do
	sleep 10s
	checkExitFile
	# 检查暂停标识
	test -f "$MODDIR/pause";
	if [ "$?" == "0" ];then
		onPause
		continue
	fi
	# 熄屏功能文件
	test -f "$MODDIR/checkScreen"
	if [ "$?" == "0" ];then
		skinOnScreenOff
		if [ "$?" == "1" ];then
			continue
		fi
	fi
	if [ "$paused" == "1" ];then
		#刚恢复运行 移除暂停提醒
		desc="(它们活着的意义是什么🤔) 已加载$rulesCount条规则 本次启动共处决$killedCount个进程 (反正不止去码头整点薯条😋)";
		sed -i "s/description=.*/description=$desc/" $MODDIR/module.prop
		paused=0;
	fi
	checkReload
	for processName in $rules;do
		pkill $processName
		if [ "$?" == "0" ];then
			killedCount=$(expr $killedCount + 1)
		fi
	done
	# 这算优化吗...
	#如果一轮下来没杀到进程并且规则无数量改变 不操作文件
	if [ $lastKilledCount != $killedCount ];then
    	desc="(它们活着的意义是什么🤔) 已加载$rulesCount条规则 本次启动共处决$killedCount个进程 (反正不止去码头整点薯条😋)";
    	sed -i "s/description=.*/description=$desc/" $MODDIR/module.prop
    	lastKilledCount=$(expr $killedCount + 0);
    fi
done