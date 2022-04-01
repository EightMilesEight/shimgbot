#/bin/sh
#fixed amount of time between intervals in seconds.
nextLoop=3
#Random amount to wait between intervals in seconds.
randNextLoop=1
#Skip waiting altogether and run as fast as possible.
noWait=false
#Size of captured image from screen.
pos=400x200+0+0

while true; do
    timer=$(((RANDOM % $randNextLoop) + $nextLoop))
    echo "running in $timer sec"
    test $noWait = true || sleep $timer
    echo 'do some stuff with xdotool and imagemagick'
    data="$(import -window root -crop "$pos" png:- | convert - sparse-color: | tr ' ' '\n')"
    echo "$data"
done
