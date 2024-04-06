#!/bin/sh 

eval `dbus export webshell_`
source /jffs/softcenter/scripts/base.sh

stop_webshell() {
if [ -n "$(pidof shellinaboxd)" ]; then
    killall -9 shellinaboxd
	sleep 1
    [ -z "$(pidof shellinaboxd)" ] && echo "【$(date +%Y年%m月%d日\ %X)】: webshell已关闭。">> /tmp/webshell.log
fi
}

start_webshell() {
if [ "$webshell_enable" != "1" ];then
    [ -L "/jffs/softcenter/init.d/S96webshell.sh" ] && rm -f /jffs/softcenter/init.d/S96webshell.sh
    exit 0
fi
/jffs/softcenter/shellinabox/shellinaboxd --css=/jffs/softcenter/shellinabox/white-on-black.css --service=/:LOGIN -b --disable-ssl
sleep 1 && [ -n "$(pidof shellinaboxd)" ] && echo "【$(date +%Y年%m月%d日\ %X)】: webshell已启动。">> /tmp/webshell.log
[ ! -L "/jffs/softcenter/init.d/S96webshell.sh" ] && ln -sf /jffs/softcenter/scripts/shellinabox_start.sh /jffs/softcenter/init.d/S96webshell.sh
}

restart_webshell() {
  stop_webshell
  start_webshell
}

case $ACTION in
*)
	restart_webshell
	;;
esac
