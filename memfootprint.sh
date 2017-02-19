#!/bin/bash
time=0
while true ; do
  echo "TIME ${time}"
  (sleep 0.02) & echo "-"
  thepid=""
  for pname in clang cc1plus ; do 
    thepid=`pgrep "$pname"`
    for i in $thepid ; do
      echo "${pname} PID $i"
      ps -o rss,vsz,pid,command $i
    done
  done

  time=$((time + 1))
  wait
done
