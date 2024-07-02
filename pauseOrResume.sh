MODDIR=${0%/*}
test -f "$MODDIR/pause"
if [ "$?" == "0" ];then
	#恢复
	rm -f "$MODDIR/pause"
	echo "已恢复"
else
	touch "$MODDIR/pause"
	echo "已暂停"
fi