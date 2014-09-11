#!/bin/bash
# shell script to prepend i3status with more stuff

i3status | (read line && echo $line && read line && echo $line && while :
do
  read line
  startchr=`expr index "$line" C[`
  prefix=${line:0:${startchr}}
  line=${line:${startchr}:${#line}-${startchr}-1}
  top=$(top -b -n 1 | sed -n '8p');
  pct=`echo ${top} | awk '{print $9}'`
  if [[ $pct -ge 8 ]]; then  
    dat=$(top -b -n 1 | sed -n '8p' | awk '{print $9 "%","(PID:",$1",",$12 ")";}')
  else
    dat=""
  fi
  dat="{ \"name\":\"process\",\"instance\":\"top\",\"full_text\":\"${dat}\",\"color\":\"#333333\" }"
  echo "${prefix}${dat},${line}]" || exit 1
done)
