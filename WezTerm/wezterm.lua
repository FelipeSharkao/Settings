local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.keys = {
	{ key = "Enter", mods = "CTRL|SHIFT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "Enter", mods = "CTRL|ALT|SHIFT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "w", mods = "CTRL|SHIFT", action = wezterm.action.CloseCurrentPane({ confirm = true }) },
	{ key = "q", mods = "CTRL|SHIFT", action = wezterm.action.CloseCurrentTab({ confirm = true }) },
	{ key = "k", mods = "CTRL|SHIFT", action = wezterm.action.ClearScrollback("ScrollbackAndViewport") },
}

config.color_scheme = "Catppuccin Mocha"
config.window_background_opacity = 0.8

config.font = wezterm.font("JetBrains Mono")
config.font_size = 11

return config
