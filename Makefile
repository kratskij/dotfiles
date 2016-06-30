ifndef ENV
$(error ENV is not set. Use "home" or "work")
endif

all: install-basics install-python-packages install-i3 install-git install-bash install-icdiff

install-python-packages:
	sudo easy_install pip
	sudo pip install python-dateutil
	sudo apt-get install python-libxml2
install-basics:
	sudo apt-get install vim tree python-bs4 gawk

install-i3:
	sudo apt-get install i3 i3blocks scrot imagemagick i3lock curl acpi sysstat lm-sensors ruby-ronn xautolock

	-git clone git://github.com/vivien/i3blocks-contrib

	if [ -e `pwd`/i3wm/i3blocks.conf.$(ENV).bottomleft ] ; then \
		rm ~/.config/i3/i3blocks.conf.bottomleft ; \
		ln -s `pwd`/i3wm/i3blocks.conf.$(ENV).bottomleft ~/.config/i3/i3blocks.conf.bottomleft ; \
	fi;
	if [ -e `pwd`/i3wm/i3blocks.conf.$(ENV).bottomright ] ; then \
		rm ~/.config/i3/i3blocks.conf.bottomright ; \
		ln -s `pwd`/i3wm/i3blocks.conf.$(ENV).bottomright ~/.config/i3/i3blocks.conf.bottomright ; \
	fi;
	if [ -e `pwd`/i3wm/i3blocks.conf.$(ENV).topleft ] ; then \
		rm ~/.config/i3/i3blocks.conf.topleft ; \
		ln -s `pwd`/i3wm/i3blocks.conf.$(ENV).topleft ~/.config/i3/i3blocks.conf.topleft ; \
	fi;
	if [ -e `pwd`/i3wm/i3blocks.conf.$(ENV).topright ] ; then \
		rm ~/.config/i3/i3blocks.conf.topright ; \
		ln -s `pwd`/i3wm/i3blocks.conf.$(ENV).topright ~/.config/i3/i3blocks.conf.topright ; \
	fi;


	-sudo mkdir /usr/local/lib/i3blocks
	-sudo rm /usr/local/lib/i3blocks/volume
	sudo ln -s `pwd`/i3wm/i3blocks_volume /usr/local/lib/i3blocks/volume
	-sudo rm /usr/local/lib/i3blocks/rss
	sudo ln -s `pwd`/i3wm/i3blocks_rss /usr/local/lib/i3blocks/rss
	-sudo rm /usr/local/lib/i3blocks/lmt
	sudo ln -s `pwd`/i3wm/i3blocks_lmt /usr/local/lib/i3blocks/lmt
	-sudo rm /usr/local/lib/i3blocks/capitals
	sudo ln -s `pwd`/i3wm/i3blocks_capitals /usr/local/lib/i3blocks/capitals
	-sudo rm /usr/local/lib/i3blocks/tv
	sudo ln -s `pwd`/i3wm/i3blocks_tv /usr/local/lib/i3blocks/tv
	-sudo rm /usr/local/lib/i3blocks/chess
	sudo ln -s `pwd`/i3wm/i3blocks_chess /usr/local/lib/i3blocks/chess
	-sudo rm /usr/local/lib/i3blocks/vpn
	sudo ln -s `pwd`/i3wm/i3blocks_vpn /usr/local/lib/i3blocks/vpn
	-sudo rm /usr/local/lib/i3blocks/weather
	sudo ln -s `pwd`/i3wm/i3blocks_weather /usr/local/lib/i3blocks/weather
	-sudo rm /usr/local/lib/i3blocks/precipitation
	sudo ln -s `pwd`/i3wm/i3blocks_precipitation /usr/local/lib/i3blocks/precipitation

	-sudo rm /usr/local/lib/i3blocks/graph
	sudo ln -s `pwd`/i3wm/i3blocks_graph /usr/local/lib/i3blocks/graph
	-sudo rm /usr/local/lib/i3blocks/color
	sudo ln -s `pwd`/i3wm/i3blocks_color /usr/local/lib/i3blocks/color

	-sudo rm /usr/local/lib/i3blocks/battery
	sudo ln -s /usr/share/i3blocks/battery /usr/local/lib/i3blocks/battery
	-sudo rm /usr/local/lib/i3blocks/cpu_usage
	sudo ln -s /usr/share/i3blocks/cpu_usage /usr/local/lib/i3blocks/cpu_usage
	-sudo rm /usr/local/lib/i3blocks/load_average
	sudo ln -s /usr/share/i3blocks/load_average /usr/local/lib/i3blocks/load_average
	-sudo rm /usr/local/lib/i3blocks/memory
	sudo ln -s /usr/share/i3blocks/memory /usr/local/lib/i3blocks/memory

	-sudo rm /usr/local/lib/i3blocks/temperature
	sudo ln -s `pwd`/i3blocks-contrib/temperature/temperature /usr/local/lib/i3blocks/temperature


	rm ~/.config/i3/config
	sudo ln -s `pwd`/i3wm/i3config.$(ENV) ~/.config/i3/config

	rm -f /bin/lock
	sudo ln -s `pwd`/i3wm/lockscreen /bin/lock

	i3-msg restart
install-git:
	sudo apt-get install git

	git config --global include.path `pwd`/gitconfig

install-icdiff:
	-git clone https://github.com/jeffkaufman/icdiff.git
	-sudo rm /usr/local/bin/icdiff
	sudo ln -s `pwd`/icdiff/icdiff /usr/local/bin/icdiff
	-sudo rm /usr/local/bin/git-icdiff
	sudo ln -s `pwd`/icdiff/git-icdiff /usr/local/bin/git-icdiff

install-bash:
	-rm ~/.bash_aliases
	ln -s `pwd`/bash_aliases ~/.bash_aliases
	echo "source ~/.bash_aliases <- DO IT!"
