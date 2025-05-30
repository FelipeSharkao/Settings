local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- > looks like hyprland updated their wlroots protocol and broke the compatibility with
-- > wezterm. Disabling wayland makes it use xwaland and not wlroots, so it works. How
-- > nice is rolling releases?
-- > https://github.com/wez/wezterm/issues/5067
-- This should be fixed, but now it hangs, no error. Another bug?
-- https://github.com/wez/wezterm/issues/5197
config.enable_wayland = false

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
    {
        key = "q",
        mods = "CTRL|SHIFT",
        action = wezterm.action.CloseCurrentTab({ confirm = true }),
    },
    {
        key = "k",
        mods = "CTRL|SHIFT",
        action = wezterm.action.ClearScrollback("ScrollbackAndViewport"),
    },
    {
        key = "PageUp",
        mods = "SHIFT",
        action = wezterm.action.ScrollByPage(-0.5),
    },
    {
        key = "PageDown",
        mods = "SHIFT",
        action = wezterm.action.ScrollByPage(0.5),
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

config.initial_cols = 160
config.initial_rows = 48

return config
