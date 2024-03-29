export LESSCHARSET=utf-8
export GITAWAREPROMPT=~/.bash/git-aware-prompt
source "${GITAWAREPROMPT}/main.sh"

alias rdie7="rdesktop 172.17.20.61 -g 1280x1024"
alias rdie9="rdesktop 172.17.20.62 -g 1280x1024"
alias tv="vncviewer 172.17.20.232"
alias cutycapt="ssh 172.19.22.45 -l newco"
alias bob="ssh 192.168.0.237 -l bob"
alias nrk="google-chrome --incognito --app=https://tv.nrk.no/direkte/nrk1"
alias fuck='$(thefuck $(fc -ln -1))'
alias sqlyog='wine "/home/henrik/.wine/drive_c/Program Files (x86)/SQLyog/SQLyog.exe" &'
alias www-rdesktop-lars='rdesktop -k no -u Lars -g 1920x1080 10.12.121.190'

function hl() { egrep -i --color=auto "$1|"; }

function swap()
{ # Swap 2 filenames around, if they exist (from Uzi's bashrc).
    local TMPFILE=tmp.$$

    [ $# -ne 2 ] && echo "swap: 2 arguments needed" && return 1
    [ ! -e $1 ] && echo "swap: $1 does not exist" && return 1
    [ ! -e $2 ] && echo "swap: $2 does not exist" && return 1

    mv "$1" $TMPFILE
    mv "$2" "$1"
    mv $TMPFILE "$2"
}

function pt
{
    for query in "$@"; do
        google-chrome --new-window "https://www.google.com/search?q=$query%20HIMYM";
    done
}
function pti
{
    for query in "$@"; do
        google-chrome --new-window "https://www.google.com/search?q=$query%20HIMYM&tbm=isch";
    done
}


jabberfind()
{
    grep -rin "$1" ~/.purple/logs/jabber/* | sed 's|<[^>]*>||g' | sed -e 's|^.*\.purple/logs/jabber/\(.*\?\)/\(.*\?\)/\([0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}\)\(.*\?\).html:\(.*\?\):(\(.[^)]*\?\))\(.[^:]*\?\): \(.*\?\)$|\x1b[34m\3 \6 (Line \5)\t\x1b[36m\2\t\x1b[33m\7> \x1b[0m\8 |g' | sort | column -t -s "	" | hl "$1"
}

function fmeld()
{ #feed diff into meld
	[ -e $1 ] && echo "USAGE: fmeld feed [oldserver=lsdev.betradar.com] [newserver=localhost] [client=betradar] [language=en]" && echo "EXAMPLE: fmeld config_sports/1 ls.betradar.com lsrelease.sportradar.ag fortuna sk"  && return
	FEED=$1
	[ ! -e $2 ] && OLDSERVER=$2 || OLDSERVER=lsdev.betradar.com
	[ ! -e $3 ] && SERVER=$3 || SERVER=localhost
	[ ! -e $4 ] && CLIENT=$4 || CLIENT=betradar
	[ ! -e $5 ] && LANGUAGE=$5 || LANGUAGE=en

	OLDURL=http://${OLDSERVER}/ls/feeds/?/${CLIENT}/${LANGUAGE}/gismo/${FEED}
	NEWURL=http://${SERVER}/ls/feeds/?/${CLIENT}/${LANGUAGE}/gismo/${FEED}
	fmeldurl $OLDURL $NEWURL
}

function fmeldurl()
{
	[ -e $2 ] && echo "USAGE: fmeldurl <old feed url> <new feed url>" && return
        ((echo $1 && (curl -Ls $1 | python -mjson.tool)) > /tmp/old.txt) &
        proc1=$!
        ((echo $2 && (curl -Ls $2 | python -mjson.tool)) > /tmp/new.txt) &
        proc2=$!
        wait "$proc1" "$proc2"
        meld /tmp/old.txt /tmp/new.txt
}

function fmeldrelease()
{
	FEED=$1
	[ ! -e $2 ] && LANG=$2 || LANG=en
	[ ! -e $3 ] && CLIENT=$3 || CLIENT=betradarqa
        NEWURL=http://lsrelease.sportradar.ag/ls/feeds/?/${CLIENT}/${LANG}/gismo/${FEED}
        OLDURL=http://ls.betradar.com/ls/feeds/?/${CLIENT}/${LANG}/gismo/${FEED}
        fmeldurl $OLDURL $NEWURL
}

function fmeldfeature()
{
	FEED=$1
	[ ! -e $2 ] && LANG=$2 || LANG=en
	[ ! -e $3 ] && CLIENT=$3 || CLIENT=betradarqa
        NEWURL=http://10.12.121.66/ls/feeds/?/${CLIENT}/${LANG}/gismo/${FEED}
        OLDURL=http://10.12.121.66/ls/feature/?/${CLIENT}/${LANG}/gismo/${FEED}
        fmeldurl $OLDURL $NEWURL
}

function fjq()
{
	curl $1 | jq ".doc[0].data$2"

}

function aoc()
{
    [ $# -ne 3 ] && echo "aoc <file> <day> <star>" && return 1
    cat $1 | jq ".members[] | {name:.name, time:.completion_day_level[\"$2\"][\"$3\"].get_star_ts} | .time + \" \" + .name" | cut -d '"' -f 2 | egrep '^1' | sort | awk '{printf "%d|\t|%s|\n", NR, $0}'
}

function aoc_input()
{
	DAY=$1
	curl -s 'http://adventofcode.com/2017/day/${DAY}/input' -H 'Cookie: session=53616c7465645f5facd22d8d026627818fbf2d07f770ca3dbc1c4e81ae5284a32e070b6e4f6352d72ad588ceb987402f' -o input
}
function aoc_new_day() {
	DAY=$1
	AOCDIR="/home/henrik/prog/adventofcode/2020";
	mkdir $AOCDIR/$DAY
	cp $AOCDIR/base.php $AOCDIR/$DAY/$DAY.php
	touch $AOCDIR/$DAY/input
	touch $AOCDIR/$DAY/test
}
function aoc_top()
{
	day=$1
	 curl --cookie "session=53616c7465645f5facd22d8d026627818fbf2d07f770ca3dbc1c4e81ae5284a32e070b6e4f6352d72ad588ceb987402f" https://adventofcode.com/2020/leaderboard/private/view/116603.json > /tmp/leaderboard && aoc /tmp/leaderboard $day 1 && echo "---" && aoc /tmp/leaderboard $day 2;
}

function record-audio-henrik() { # record audio (use mp3 as filename)
	OUTPUT=$(pacmd list-sinks | grep -A1 "* index" | grep -oP "<\K[^ >]+")
	echo "OUTPUT: ${OUTPUT}"
	pacat --record -d $OUTPUT.monitor | lame -r -b 192 - $1;
}

