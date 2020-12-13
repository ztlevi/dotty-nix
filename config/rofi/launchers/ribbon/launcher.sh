#!/usr/bin/env bash
# Available Styles
# >> Created and tested on : rofi 1.6.0-1
#
# ribbon_top        ribbon_top_round        ribbon_bottom       ribbon_bottom_round
# ribbon_left       ribbon_left_round       ribbon_right        ribbon_right_round
# full_bottom       full_top                full_left           full_right

theme="ribbon_top_round"

dir="$HOME/.config/rofi/launchers/ribbon"
styles=($(ls -p --hide="colors.rasi" $dir/styles))
color="${styles[$(($RANDOM % 8))]}"

cat >$dir/styles/colors.rasi <<-EOF
@import "$color"
EOF

# comment these lines to disable random style
themes=($(ls -p --hide="launcher.sh" --hide="styles" $dir))
theme="${themes[$(($RANDOM % 12))]}"

rofi -no-lazy-grab -show drun -modi drun -theme $dir/"$theme"
rm -f $dir/styles/colors.rasi
