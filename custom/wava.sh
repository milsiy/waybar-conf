#!/bin/bash

bar="▁▂▃▄▅▆▇█"
dict="s/;//g;"

# creating "dictionary" to replace char with bar
i=0
while [ $i -lt ${#bar} ]
do
    dict="${dict}s/$i/${bar:$i:1}/g;"
    i=$((i=i+1))
done

# write cava config
config_file="/tmp/.cava.conf"
echo "
[general]
bars = 15

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
" > $config_file


# read stdout from cava
cava -p $config_file | while read -r line; do
    text=$(echo $line | sed $dict)
    alt=$text
    tooltip=$(playerctl metadata --format "{{title}}\n{{artist}}" \
        | sed "s/&/&amp;/g")
    echo "{\"text\":\"$text\",\"alt\":\"$alt\",\"tooltip\":\"$tooltip\"}" 
done
