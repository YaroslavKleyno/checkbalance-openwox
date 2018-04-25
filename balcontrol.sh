#!/bin/sh
#PLEASE DEFINE SIM_ID AND TRUNK_ID IN GATEWAY
SIM_ID=1
TRUNK_ID=54

card_bal_full=$(asterisk -rx 'gsm send ussd '$SIM_ID' *112*1#')
card_status=`echo $card_bal_full | head -c 1`
card_bal_min=`echo $card_bal_full | cut -d';' -f4 | awk -F ':' '{print $1}'`

if [ "$card_status" == "0" ]; then
	echo "Ошибка USSD, SIM:$SIM_ID $(date)" >> /tmp/balcontrol.log
	else
	if [ "$card_bal_min" -lt 5 ]; then
	echo "Баланс SIM-карты #:$SIM_ID меньше 5 минут, отключаем ТРАНК #:$TRUNK_ID $(date)" >> /tmp/web/www/balcontrol.html
	ssh -y 192.168.240.47 -p2244 -i /etc/cfg/yaroslav_cfg/dropbear_rsa "fwconsole trunks --disable $TRUNK_ID"
	else
	if [ "$card_bal_min" -gt 5 ]; then
	echo "Баланс SIM-карты #:$SIM_ID больше 5 минут, включаем ТРАНК #:$TRUNK_ID $(date)" >> /tmp/web/www/balcontrol.html
	ssh -y 192.168.240.47 -p2244 -i /etc/cfg/yaroslav_cfg/dropbear_rsa "fwconsole trunks --enable $TRUNK_ID"
    fi
  fi
fi