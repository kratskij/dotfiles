ifndef ENV
$(error ENV is not set. Use "home" or "work")
endif

all: i3

i3:
	sudo apt-get install i3 scrot imagemagick i3lock 
	rm ~/.i3/config
	ln -s `pwd`/i3wm/i3config.$(ENV) ~/.i3/config
	sudo rm /etc/i3status.conf
	sudo ln -s `pwd`/i3wm/i3status.conf.$(ENV) /etc/i3status.conf
	sudo rm -f /bin/lock
	sudo ln -s `pwd`/i3wm/lockscreen /bin/lock
	sudo rm -f /usr/local/bin/my_i3status.sh
	sudo ln -s `pwd`/i3wm/my_i3status.sh /usr/local/bin/my_i3status.sh