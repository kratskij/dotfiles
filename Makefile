ifndef ENV
$(error ENV is not set. Use "home" or "work")
endif

all: i3

i3:
	rm ~/.i3/config; \
	ln -s `pwd`/i3config ~/.i3/config
	sudo rm /etc/i3status.conf; \
	sudo ln -s `pwd`/i3status.conf /etc/i3status.conf
