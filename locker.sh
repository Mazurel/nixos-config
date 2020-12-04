# !/bin/bash

yad --center --width 200 --height 100 --fixed \
    --button=OK \
    --text "Screen is about to be locked\nPress OK to abort lock"\
    2> /dev/null 3> /dev/null &

PID=$!
sleep 10s
kill -0 $! 2> /dev/null && kill $! && i3lock

