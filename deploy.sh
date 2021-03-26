#!/bin/sh

#GUEST_NAME_HERE in deploy.sh needs to be replaced with the WIFI name of the guest network.
#Assumption is that you only have 3 or less network interfaces. While loop in rotate_guest_wifi_password needs to be increased otherwise

rm rotate_guest_wifi_password.sh

echo $'#!/bin/sh

password=`cat /dev/urandom | env LC_CTYPE=C tr -dc _ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjklmnpqrstuvwxyz23456789- | head -c 12; echo;`

echo $password > /root/.guest_password.txt

ssid=WIFI_NAME_HERE
security=WPA
i=0; 
while [ $i -le 2 ]; 
    do if [ `uci get wireless.@wifi-iface[$i].network` == \'guest\' ]; then
        uci set wireless.@wifi-iface[$i].key=$password
        uci commit wireless
        wifi
    fi
    i=$((i+1)); 
done;
' >> rotate_guest_wifi_password.sh

chmod +x rotate_guest_wifi_password.sh


rm guest
echo $'#!/bin/sh

password=$(cat /root/.guest_password.txt)

echo "Content-Type: text/html"
echo ""
echo "<!DOCTYPE html>"
echo \'<html lang="en-US">\'
echo "<head>"
echo "<title>Guest Password</title>"
echo \'<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1.0, minimum-scale=1.0">\'
echo \'<meta http-equiv="refresh" content="360" />\'
echo "</head>"
echo \'<body bgcolor="#000">\'
echo "<div style=\'text-align:center;color:#fff;font-family:UnitRoundedOT,Helvetica Neue,Helvetica,Arial,sans-serif;font-size:28px;font-weight:500;\'>"
echo "<h1>Guest WIFI</h1>"
echo "<p>SSID: <b>WIFI_NAME_HERE</b></p>"
echo "<p>PASSWORD: <b>$password</b></p>"
echo "</div>"
echo "</body>"
echo "</html>"' >> guest

chmod +x guest


if grep -Fxq "rotate_guest_wifi_password.sh" /etc/crontabs/root
then
    echo "Item already in Crontab"
else
    echo "1 0 * * 1 /sbin/rotate_guest_wifi_password.sh" >> /etc/crontabs/root
fi

cp rotate_guest_wifi_password.sh /sbin/
cp guest /www/cgi-bin/
