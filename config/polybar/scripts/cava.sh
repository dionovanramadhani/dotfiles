#!/usr/bin/env bash

# Bar characters (8 levels from space to full block)
bar=" ▂▃▄▅▆▇█"
dict="s/;//g;"

# creating "dictionary" to replace char with bar
i=0
while [ $i -lt ${#bar} ]
do
    dict="${dict}s/$i/${bar:$i:1}/g;"
    i=$((i=i+1))
done

# write cava config
config_file="/tmp/polybar_cava_config"
cat <<EOF > "$config_file"
[general]
bars = 8

[input]
method = pulse
source = auto

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
EOF

# Clean up temp file on exit
trap 'rm -f "$config_file"' EXIT

# read stdout from cava
cava -p "$config_file" 2>/dev/null | while read -r line; do
    if [[ "$line" =~ [1-7] ]]; then
        echo "$line" | sed "$dict"
    else
        echo ""
    fi
done
