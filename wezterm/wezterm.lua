local wezterm=require("wezterm")

local config=wezterm.config_builder()
config.font=wezterm.font("MesloLGSDZ Nerd Font Propo")
config.font_size=19

config.enable_tab_bar=false
config.window_decorations="RESIZE"

-- Use HOME environment variable for cross-machine compatibility
local home = os.getenv("HOME")
config.window_background_image = home .. '/backgrounds/4k_luffy.jpg'
config.window_background_image_hsb={
        brightness=.15,
        hue=1.0,
        saturation=1.0,

}
config.keys = {
    -- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
    {key="LeftArrow", mods="OPT", action=wezterm.action{SendString="\x1bb"}},
    -- Make Option-Right equivalent to Alt-f; forward-word
    {key="RightArrow", mods="OPT", action=wezterm.action{SendString="\x1bf"}},
  }
config.window_background_opacity=1.0
config.text_background_opacity=.75

return config
