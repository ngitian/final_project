#!/bin/bash

while true; do
    outdoorTemp=$(curl --silent wttr.in/?format=%t | grep -o [0-9]*)
    echo "Outdoor: $outdoorTemp°F"
    mosquitto_pub -t "esp32/temperature" -h "192.168.1.229" -m $outdoorTemp
    mosquitto_sub -t "esp32/respond" -h "192.168.1.229" -C 1 | while read -r indoorTemp
    do
        echo "Indoor: $indoorTemp°F"
    done

    if [[ $outdoorTemp -lt $indoorTemp ]]; then
        echo -e "Outside is hotter\n"
    else
        echo -e "Outside is colder\n"
    fi

    sleep 5
done
