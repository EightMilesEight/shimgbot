#/bin/sh
#fixed amount of time between intervals in seconds.
nextLoop=3
#Random amount to wait between intervals in seconds.
randNextLoop=1
#Skip waiting altogether and run as fast as possible.
noWait=false
#Size of captured image from screen.
width=10
height=10
pos=${width}x${height}+0+0

#Copy over pixel data from picture to be created.
tuxData=$(convert tux.png sparse-color: | tr ' ' '\n')

while true; do
    echo 'doing some stuff with imagemagick'
    data="$(import -window root -crop "$pos" png:- | convert - sparse-color: | tr ' ' '\n')"

    i=0
    x=0
    y=0
    echo "$data" | while read -r line; do 
        i=$((i + 1))

        x=$(echo "$line" | cut -d',' -f1)
        y=$(echo "$line" | cut -d',' -f2)
        color=$(echo "$line" | cut -d',' -f3-)
       
        tuxLine=$(echo "$tuxData" | sed -n ${i}p)
        tuxX=$(echo "$tuxLine" | cut -d',' -f1)
        tuxY=$(echo "$tuxLine" | cut -d',' -f2)
        tuxColor=$(echo "$tuxLine" | cut -d',' -f3-)

        if test "$color" != "$tuxColor"; then
            timer=$(((RANDOM % $randNextLoop) + $nextLoop))
            echo "running in $timer sec"
            test $noWait = true || sleep $timer

            echo $color $tuxColor
            echo 'do some stuff with xdotool'
            #xdotool mousemove $x $y click 1
        fi
    done
    i=0
    x=0
    y=0
done
