ifndef ENV
$(error ENV is not set. Use "home" or "work")
endif

all: i3 git bash

i3:
	sudo apt-get install i3 scrot imagemagick i3lock curl acpi sysstat

	-git clone git://github.com/vivien/i3blocks
	cd i3blocks && make clean
	cd i3blocks && sudo make install

	-rm ~/.i3blocks.conf
	ln -s `pwd`/i3wm/i3blocks.conf.$(ENV) ~/.i3blocks.conf
	if [ -a `pwd`/i3wm/i3blocks.conf.$(ENV).2 ] ; then \
		-rm ~/.i3blocks.conf.2 ; \
		ln -s `pwd`/i3wm/i3blocks.conf.$(ENV).2 ~/.i3blocks.conf.2 ; \
	fi;

	-sudo rm /usr/local/libexec/i3blocks/volume
	sudo ln -s `pwd`/i3wm/i3blocks_volume /usr/local/libexec/i3blocks/volume
	-sudo rm /usr/local/libexec/i3blocks/rss
	sudo ln -s `pwd`/i3wm/i3blocks_rss /usr/local/libexec/i3blocks/rss
	-sudo rm /usr/local/libexec/i3blocks/lmt
	sudo ln -s `pwd`/i3wm/i3blocks_lmt /usr/local/libexec/i3blocks/lmt
	-sudo rm /usr/local/libexec/i3blocks/capitals
	sudo ln -s `pwd`/i3wm/i3blocks_capitals /usr/local/libexec/i3blocks/capitals

	rm ~/.i3/config
	ln -s `pwd`/i3wm/i3config.$(ENV) ~/.i3/config

	-rm -f /bin/lock
	ln -s `pwd`/i3wm/lockscreen /bin/lock

	i3-msg restart
git:
	sudo apt-get install git

	git config --global include.path `pwd`/gitconfig

bash:
	-rm ~/.bash_aliases
	ln -s `pwd`/bash_aliases ~/.bash_aliases
	echo "source ̃/.bash_aliases <- DO IT!"