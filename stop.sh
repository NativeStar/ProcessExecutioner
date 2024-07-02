MODDIR=${0%/*}
test -f "$MODDIR/dead"
if [ "$?" != "0" ];then
	touch "$MODDIR/suicide"
fi
echo "已停止"