#! /usr/bin/env sh

# Mateusz Mazur 2020 
# License: MIT

# This scripts allows more intuitive workspace switching 
# for i3. It is pretty fast (~ 50ms).

destWorkspace="\"$@\"" # Quote the name
workspaceData=$(i3-msg -t get_workspaces) # Cache workspace data

# Creates input data and stores it in INPUT_DATA array
IFS=$'\n' INPUT_DATA=($(echo $workspaceData | jq "\
    (.[] | select(.name==$destWorkspace) | .output) as \$destOutput\
        | (\$destOutput),\
        (.[] | select(.focused==true) | (.name, .output)),\
        (.[] | select(.output==\$destOutput and .visible==true) | (.name))"))

echo ${INPUT_DATA[@]}

currentOutput=${INPUT_DATA[2]}
destOutput=${INPUT_DATA[0]}

# If the same output just switch
[ $destOutput = $currentOutput ] && \
    i3-msg workspace number $destWorkspace 1> /dev/null && \
    exit 1

currentWorkspace=${INPUT_DATA[1]}
destCurrentWorkspace=${INPUT_DATA[3]}

# echo "$currentWorkspace -> $destOutput"
i3-msg workspace number $currentWorkspace 1> /dev/null 
i3-msg move workspace to output "$destOutput" 1> /dev/null

# Focus workspace that was focused
i3-msg workspace number $destCurrentWorkspace 1> /dev/null

# echo "$destWorkspace -> $currentOutput"
i3-msg workspace number $destWorkspace 1> /dev/null
i3-msg move workspace to output "$currentOutput" 1> /dev/null

# Focus on dest workspace
echo $destWorkspace
# Why 3 times ?
# Because one time not always work
i3-msg workspace number $destWorkspace 1> /dev/null 
i3-msg workspace number $destWorkspace 1> /dev/null 
i3-msg workspace number $destWorkspace 1> /dev/null 
