# GuestLedeWifiScript
Script should be used after each LEDE upgrade to reinstall the proper scripts to automatically change the guest password every day along with provide a UI frontend to easily retrieve the new password.

Used on Openwrt router. 

Guest wifi needs to be configured prior to this script. Found here: https://openwrt.org/docs/guide-user/network/wifi/guestwifi/guest-wlan

Converted from: https://blog.tldnr.org/2019/11/11/Guest-Wifi/

GUEST_NAME_HERE in deploy.sh needs to be replaced with the WIFI name of the guest network.
