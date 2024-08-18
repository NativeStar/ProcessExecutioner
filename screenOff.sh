MODDIR=${0%/*}
test -f "$MODDIR/checkScreen"
if [ "$?" != "0" ];then
	touch "$MODDIR/checkScreen"
	echo "当前:熄屏时暂停工作"
else
	rm -f "$MODDIR/checkScreen"
	echo "当前:熄屏时正常工作"
fi