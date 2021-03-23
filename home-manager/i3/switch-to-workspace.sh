#! /usr/bin/env sh

# Mateusz Mazur 2020 
# License: MIT

# This scripts allows more intuitive workspace switching 
# for i3. It is pretty fast (~ 55ms on my Desktop) 
# so it is pretty seamless.

# Example usage in i3 config:
# bindsym $mod+1 exec --no-startup-id "~/.config/i3/switch-to-workspace.sh $ws1"

destWorkspace="\"$@\"" # Quote the name

# Creates input data and stores it in INPUT_DATA array
# [0] First element is Destination output
# [1] Current workspace that is focused rn
# [2] Second element is Current output (the one that is focused)
# [3] Thrid element is Workspace that is currently focused on 
#     output that is currently storing workspace that you want to see
IFS=$'\n' INPUT_DATA=($(i3-msg -t get_workspaces | jq "\
    (.[] | select(.name==$destWorkspace) | .output) as \$destOutput\
        |\
        (\$destOutput),\
        (.[] | select(.focused==true) | (.name, .output)),\
        (.[] | select(.output==\$destOutput and .visible==true) | (.name))"))

currentOutput=${INPUT_DATA[2]}
destOutput=${INPUT_DATA[0]}

# If destination workspace is on the same output as current workspace
# just do the switch
[ $destOutput = $currentOutput ] && \
    i3-msg workspace number $destWorkspace 1> /dev/null && \
    exit 1

# Else:
currentWorkspace=${INPUT_DATA[1]}
destCurrentWorkspace=${INPUT_DATA[3]}

# Move current workspace to output that is currently containing 
# workspace that you want to have on your output 
# i3-msg workspace number $currentWorkspace 1> /dev/null
i3-msg move workspace to output "$destOutput" 1> /dev/null

# Focus workspace that you want on you output and move it
i3-msg workspace number $destWorkspace 1> /dev/null
i3-msg move workspace to output "$currentOutput" 1> /dev/null

# Focus workspace that was focused before on the output
# that has workspace that you want on your current output
i3-msg workspace number $destCurrentWorkspace 1> /dev/null

# Focus on workspace that you wanted to be focused on
i3-msg workspace number $destWorkspace 1> /dev/null 
