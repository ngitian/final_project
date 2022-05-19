#!/bin/bash

while true; do
    outdoorTemp=$(curl --silent wttr.in/?format=%t | grep -o [0-9]*)
    indoorTemp=boop
    echo "Outdoor: $outdoorTemp°F"
    mosquitto_pub -t "esp32/temperature" -h "192.168.1.229" -m $outdoorTemp
    mosquitto_sub -t "esp32/respond" -h "192.168.1.229" -C 1 | while read -r indoorTemp
    do
        echo "Indoor: $indoorTemp°F"

        result=$(awk -vx=$outdoorTemp -vy=$indoorTemp 'BEGIN{print (x>=y)?1:0}')
        if [[ $result -eq 1 ]]; then
            echo -e "Outside is hotter\n"
        else
            echo -e "Outside is colder\n"
        fi
    done

    sleep 5
done
