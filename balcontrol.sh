#!/bin/sh
#PLEASE DEFINE SIM_ID, TRUNK_ID AND MIN_OFF IN GATEWAY
SIM_ID=1
TRUNK_ID=40
MIN_OFF=15
card_bal_full=$(asterisk -rx 'gsm send ussd '$SIM_ID' *112*1#')
card_status=`echo $card_bal_full | head -c 1`
card_bal_min=`echo $card_bal_full | cut -d' ' -f7 | awk -F ':' '{print $1}'`
echo $card_bal_full

if [ "$card_status" == "0" ]; then
        echo "Ошибка отправки USSD запроса на карте SIM:$SIM_ID , отключим на всякий случай транк #:$TRUNK_ID до следующей удачной проверки баланса... $(date) <br>" >> /tmp/web/www/balcontrol.html
        echo "<font color=blue>Ответ FreePBX:</font> `ssh -y 192.168.240.47 -p2244 -i /etc/cfg/yaroslav_cfg/dropbear_rsa "fwconsole trunks --disable '$TRUNK_ID'"` $(date) <br>" >> /tmp/web/www/balcontrol.html
        else
        if [ "$card_bal_min" -lt "$MIN_OFF" ]; then
        echo "Баланс SIM-карты #:$SIM_ID меньше $MIN_OFF минут, <font color=red><b>отключаем</b></font> ТРАНК #:$TRUNK_ID $(date) <br>" >> /tmp/web/www/balcontrol.html
        echo "<font color=blue>Ответ FreePBX:</font> `ssh -y 192.168.240.47 -p2244 -i /etc/cfg/yaroslav_cfg/dropbear_rsa "fwconsole trunks --disable '$TRUNK_ID'"` $(date) <br>" >> /tmp/web/www/balcontrol.html
        else
        if [ "$card_bal_min" -gt "$MIN_OFF" ]; then
        echo "Баланс SIM-карты #:$SIM_ID больше $MIN_OFF минут, <font color=green><b>включаем</b></font> ТРАНК #:$TRUNK_ID $(date) <br>" >> /tmp/web/www/balcontrol.html
        echo "<font color=blue>Ответ FreePBX:</font> `ssh -y 192.168.240.47 -p2244 -i /etc/cfg/yaroslav_cfg/dropbear_rsa "fwconsole trunks --enable '$TRUNK_ID'"` $(date) <br>" >> /tmp/web/www/balcontrol.html
    fi
  fi
fi
