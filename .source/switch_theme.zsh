# helper functions for switching between light and dark themes

switch_theme () {
    if [ -z ${MY_THEME} ]; then
        return
    fi

    if [ ! -f ${config_file} ]; then
        return
    fi

    if [ ${MY_THEME} = ${MY_THEME_LIGHT} ]; then
        sed -i '' -e "s/${dark_theme}/${light_theme}/g" ${config_file} || sed -i -e "s/${dark_theme}/${light_theme}/g" ${config_file}
    else
        sed -i '' -e "s/${light_theme}/${dark_theme}/g" ${config_file} || sed -i -e "s/${light_theme}/${dark_theme}/g" ${config_file}
    fi
}
