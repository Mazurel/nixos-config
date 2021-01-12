#! /usr/bin/env sh

# Mateusz Mazur 2020 
# License: MIT

# This scripts allows more intuitive workspace switching 
# for i3. It is not the fastest one, but fast enough

destWorkspace="\"$@\"" # Quote the name
destOutput=$(i3-msg -t get_workspaces | jq ".[] | select(.name==$destWorkspace).output")
destCurrentWorkspace=$(i3-msg -t get_workspaces | jq ".[] | select(.output==$destOutput and .visible==true).name")
currentWorkspace=$(i3-msg -t get_workspaces | jq '.[] | select(.focused==true).name')
currentOutput=$(i3-msg -t get_workspaces | jq '.[] | select(.focused==true).output')

echo "$currentWorkspace -> $destOutput"
i3-msg workspace number $currentWorkspace 1> /dev/null 
i3-msg move workspace to output "$destOutput" 1> /dev/null
i3-msg workspace number $destCurrentWorkspace 1> /dev/null

echo "$destWorkspace -> $currentOutput"
i3-msg workspace number $destWorkspace 1> /dev/null
i3-msg move workspace to output "$currentOutput" 1> /dev/null

# Focus on dest workspace
i3-msg workspace number $destWorkspace 1> /dev/null 
