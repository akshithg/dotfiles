# helper functions for switching between light and dark themes

switch_theme() {
    local cfg="$1" dark="$2" light="$3"

    if [ -z "${MY_THEME}" ]; then
        return 1
    fi

    if [ ! -f "${cfg}" ]; then
        return 1
    fi

    if [ "${MY_THEME}" = "${MY_THEME_LIGHT}" ]; then
        sed -i '' -e "s/${dark}/${light}/g" "${cfg}" 2>/dev/null || sed -i -e "s/${dark}/${light}/g" "${cfg}"
    else
        sed -i '' -e "s/${light}/${dark}/g" "${cfg}" 2>/dev/null || sed -i -e "s/${light}/${dark}/g" "${cfg}"
    fi
}

_set_dark_theme() {
    export MY_THEME="${MY_THEME_DARK}"
}

_set_light_theme() {
    export MY_THEME="${MY_THEME_LIGHT}"
}
