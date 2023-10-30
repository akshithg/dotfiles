#!/bin/sh

# vivid - https://github.com/sharkdp/vivid

if ! command -v vivid >/dev/null 2>&1; then
    return
fi

# check if $_THEME is set
if [ -z ${_THEME} ]; then
    return
fi

themes=${XDG_CONFIG_HOME:-$HOME/.config}/vivid/themes
dark_theme=$themes/catppuccin-mocha.yml
light_theme=$themes/catppuccin-latte.yml

if [ ${_THEME} = ${_THEME_LIGHT} ]; then
    export LS_COLORS=$(vivid generate ${light_theme})
else
    export LS_COLORS=$(vivid generate ${dark_theme})
fi
