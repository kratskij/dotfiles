ifndef ENV
$(error ENV is not set. Use "home" or "work")
endif

all: install-i3 install-git install-bash install-icdiff

install-i3:
	sudo apt-get install i3 scrot imagemagick i3lock curl acpi sysstat lm-sensors nmcli

	-git clone git://github.com/vivien/i3blocks
	-git clone git://github.com/vivien/i3blocks-contrib
	cd i3blocks && make clean
	cd i3blocks && sudo make install

	if [ -a `pwd`/i3wm/i3blocks.conf.$(ENV).bottomleft ] ; then \
		-rm ~/.i3blocks.conf.bottomleft ; \
		ln -s `pwd`/i3wm/i3blocks.conf.$(ENV).bottomleft ~/.i3blocks.conf.bottomleft ; \
	fi;
	if [ -a `pwd`/i3wm/i3blocks.conf.$(ENV).bottomright ] ; then \
		-rm ~/.i3blocks.conf.bottomright ; \
		ln -s `pwd`/i3wm/i3blocks.conf.$(ENV).bottomright ~/.i3blocks.conf.bottomright ; \
	fi;
	if [ -a `pwd`/i3wm/i3blocks.conf.$(ENV).topleft ] ; then \
		-rm ~/.i3blocks.conf.topleft ; \
		ln -s `pwd`/i3wm/i3blocks.conf.$(ENV).topleft ~/.i3blocks.conf.topleft ; \
	fi;
	if [ -a `pwd`/i3wm/i3blocks.conf.$(ENV).topright ] ; then \
		-rm ~/.i3blocks.conf.topright ; \
		ln -s `pwd`/i3wm/i3blocks.conf.$(ENV).topright ~/.i3blocks.conf.topright ; \
	fi;


	-sudo rm /usr/local/libexec/i3blocks/volume
	sudo ln -s `pwd`/i3wm/i3blocks_volume /usr/local/libexec/i3blocks/volume
	-sudo rm /usr/local/libexec/i3blocks/rss
	sudo ln -s `pwd`/i3wm/i3blocks_rss /usr/local/libexec/i3blocks/rss
	-sudo rm /usr/local/libexec/i3blocks/lmt
	sudo ln -s `pwd`/i3wm/i3blocks_lmt /usr/local/libexec/i3blocks/lmt
	-sudo rm /usr/local/libexec/i3blocks/capitals
	sudo ln -s `pwd`/i3wm/i3blocks_capitals /usr/local/libexec/i3blocks/capitals
	-sudo rm /usr/local/libexec/i3blocks/tv
	sudo ln -s `pwd`/i3wm/i3blocks_tv /usr/local/libexec/i3blocks/tv
	-sudo rm /usr/local/libexec/i3blocks/chess
	sudo ln -s `pwd`/i3wm/i3blocks_chess /usr/local/libexec/i3blocks/chess
	-sudo rm /usr/local/libexec/i3blocks/vpn
	sudo ln -s `pwd`/i3wm/i3blocks_vpn /usr/local/libexec/i3blocks/vpn
	-sudo rm /usr/local/libexec/i3blocks/weather
	sudo ln -s `pwd`/i3wm/i3blocks_weather /usr/local/libexec/i3blocks/weather
	
	-sudo rm /usr/local/libexec/i3blocks/graph
	sudo ln -s `pwd`/i3wm/i3blocks_graph /usr/local/libexec/i3blocks/graph
	-sudo rm /usr/local/libexec/i3blocks/color
	sudo ln -s `pwd`/i3wm/i3blocks_color /usr/local/libexec/i3blocks/color
	
	-sudo rm /usr/local/libexec/i3blocks/cpu_usage
	sudo ln -s `pwd`/i3blocks/scripts/cpu_usage /usr/local/libexec/i3blocks/cpu_usage
	-sudo rm /usr/local/libexec/i3blocks/load_average
	sudo ln -s `pwd`/i3blocks/scripts/load_average /usr/local/libexec/i3blocks/load_average
	-sudo rm /usr/local/libexec/i3blocks/memory
	sudo ln -s `pwd`/i3blocks/scripts/memory /usr/local/libexec/i3blocks/memory

	-sudo rm /usr/local/libexec/i3blocks/temperature
	sudo ln -s `pwd`/i3blocks-contrib/temperature/temperature /usr/local/libexec/i3blocks/temperature
	

	rm ~/.i3/config
	ln -s `pwd`/i3wm/i3config.$(ENV) ~/.i3/config

	-rm -f /bin/lock
	ln -s `pwd`/i3wm/lockscreen /bin/lock

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
	echo "source ̃/.bash_aliases <- DO IT!"
