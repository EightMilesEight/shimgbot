#/bin/sh
#Fixed amount of time between intervals in seconds.
nextLoop=3
#Random amount to wait between intervals in seconds.
randNextLoop=1
#Skip waiting altogether and run as fast as possible.
noWait=true
#Size of captured image from screen.
width=400
height=400
pos=${width}x${height}+0+0
#The pixel scale needs to be found and aligned by hand on the canvas 
#The resize value must not result in a decimal
scale=40
resize=$((width / scale))
#offset for clicking from top left of pixel
offset=5
#Find x and y of first color by hand
colorX=845
colorY=1008
#Might need to change colorspace of tux logo to match screen
#convert tux.png -alpha deactivate tux1.png
#Create test image
#sleep 4; import -window root -crop 400x400+0+0 -resize 10 tux2.png

pickColor() {
    if test $1 -lt "8"; then  
        colorNX=$((colorX + (32 * $1)))
        colorNY=$colorY
    else
        n=$(($1 % 8))
        colorNX=$((colorX + (32 * n)))
        colorNY=$((colorY + 32))
    fi
    xdotool mousemove $colorNX $colorNY click 1
}


#Copy over pixel data from tux logo
tuxData=$(convert tux2.png sparse-color: | tr ' ' '\n')

while true; do
    echo 'doing some stuff with imagemagick'
    xdotool mousemove $((x + width + 100)) $((y + width + 100))
    data="$(import -window root -crop "$pos" -resize "$resize" png:- | convert - sparse-color: | tr ' ' '\n')"
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
            case "$tuxColor" in 
                0)
                    pickColor 0
                ;;
                1)
                    pickColor 1
                ;;
                2)
                    pickColor 2
                ;;
                "srgb(255,255,255)")
                    pickColor 3
                ;;
                4)
                    pickColor 4
                ;;
                "srgb(96.9665%,94.7555%,97.9858%)")
                    pickColor 5
                ;;
                6)
                    pickColor 6
                ;;
                7)
                    pickColor 7
                ;;
                8)
                    pickColor 8
                ;;
                9)
                    pickColor 9
                ;;
                10)
                    pickColor 10
                ;;
                0)
                    pickColor 11
                ;;
                1)
                    pickColor 12
                ;;
                2)
                    pickColor 13
                ;;
                3)
                    pickColor 14
                ;;
                4)
                    pickColor 15
                ;;
                *)
                    echo 'color not found'
                ;;
            esac
            xdotool mousemove $(((x * scale) + offset)) $(((y * scale) + offset)) click 1
        fi
    done
done
