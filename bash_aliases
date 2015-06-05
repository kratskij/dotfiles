alias rdie7="rdesktop 172.17.20.61 -g 1280x1024"
alias rdie9="rdesktop 172.17.20.62 -g 1280x1024"
alias tv="vncviewer 172.17.20.232"
alias cutycapt="ssh 172.19.22.45 -l newco"
alias bob="ssh 192.168.0.237 -l bob"
alias nrk="chromium-browser --app=http://tv.nrk.no/direkte/nrk1"
alias fuck='$(thefuck $(fc -ln -1))'

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

jabberfind()
{
    grep -rin "$1" ~/.purple/logs/jabber/* | sed 's|<[^>]*>||g' | sed -e 's|^.*\.purple/logs/jabber/\(.*\?\)/\(.*\?\)/\([0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}\)\(.*\?\).html:\(.*\?\):(\(.[^)]*\?\))\(.[^:]*\?\): \(.*\?\)$|\x1b[34m\3 \6 (Line \5)\t\x1b[36m\2\t\x1b[33m\7> \x1b[0m\8 |g' | sort | column -t -s "	" | hl "$1"
}

function fmeld()
{ #feed diff into meld
	[ -e $1 ] && echo "USAGE: fmeld feed [client, default is betradar]" && echo "EXAMPLE: fmeld config_sports/1 aftonbladet" && return
	[ ! -e $2 ] && CLIENT=$2 || CLIENT=aftonbladet
	
	curl http://ls.betradar.com/ls/feeds/?/${CLIENT}/en/gismo/$1 | python -mjson.tool > /tmp/live.txt
	curl http://localhost/ls/feeds/?/${CLIENT}/en/gismo/$1 | python -mjson.tool > /tmp/local.txt
	meld /tmp/live.txt /tmp/local.txt
}
