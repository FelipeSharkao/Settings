local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.keys = {
    {
        key = "Enter",
        mods = "CTRL|SHIFT",
        action = wezterm.action_callback(function(_, pane)
            local dimentions = pane:get_dimensions()

            local width = dimentions.cols / 2.5
            local height = dimentions.viewport_rows

            if width > height then
                pane:split({ direction = "Right" })
            else
                pane:split({ direction = "Bottom" })
            end
        end),
    },
    {
        key = "w",
        mods = "CTRL|SHIFT",
        action = wezterm.action.CloseCurrentPane({ confirm = true }),
    },
    { key = "q", mods = "CTRL|SHIFT", action = wezterm.action.CloseCurrentTab({ confirm = true }) },
    {
        key = "k",
        mods = "CTRL|SHIFT",
        action = wezterm.action.ClearScrollback("ScrollbackAndViewport"),
    },
}

config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}

config.color_scheme = "Catppuccin Mocha"
config.window_background_opacity = 0.9

config.font = wezterm.font("JetBrains Mono")
config.font_size = 11

return config
