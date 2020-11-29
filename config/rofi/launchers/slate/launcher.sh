#!/usr/bin/env bash
# Available Styles
# >> Created and tested on : rofi 1.6.0-1
#
# slate_full     slate_center     slate_left
# slate_right    slate_top        slate_bottom

theme="slate_full"

dir="$HOME/.config/rofi/launchers/slate"
styles=($(ls -p --hide="colors.rasi" $dir/styles))
color="${styles[$(($RANDOM % 20))]}"

cat >$dir/styles/colors.rasi <<-EOF
@import "$color"
EOF

# comment these lines to disable random style
themes=($(ls -p --hide="launcher.sh" --hide="styles" $dir))
theme="${themes[$(($RANDOM % 5))]}"

rofi -no-lazy-grab -show drun -modi drun -theme $dir/"$theme"
rm -f $dir/styles/colors.rasi
