#!/bin/bash
spin() {
    local spinners=("points" "line" "minidot" "jump" "pulse" "globe" "moon" "monkey" "meter" "hamburger")
    for s in "${spinners[@]}"; do
        echo "Testing $s"
        gum spin --spinner "$s" --title "test" -- sleep 1
    done
}
spin
