/usr/bin/sudo pkill -F /home/pi/offpid.pid
/usr/bin/sudo pkill -F /home/pi/metarpid.pid
/usr/bin/sudo /home/pi/metarmap/bin/python3 /home/pi/metar.py & echo $! > /home/pi/metarpid.pid
