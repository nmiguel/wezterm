-- Pull in the wezterm API
local wezterm = require("wezterm")
local mux = wezterm.mux

-- This table will hold the configuration.
local config = wezterm.config_builder()

-- config.enable_wayland = false

-- config.wsl_domains = {
-- 	{
-- 		name = "WSL:Ubuntu-24.04",
-- 		distribution = "Ubuntu-24.04",
-- 		default_cwd = "~",
-- 		default_prog = { "tmux" },
-- 	},
-- 	{
-- 		name = "WSL:Ubuntu-22.04",
-- 		distribution = "Ubuntu-22.04",
-- 		default_cwd = "~",
-- 		default_prog = { "tmux" },
-- 	},
-- }

config.default_prog = { "tmux" }
-- config.default_domain = "WSL:Ubuntu-22.04"
config.launch_menu = {
	{
		label = "Windows Terminal",
		args = { "wt.exe" },
	},
}
config.debug_key_events = true
config.warn_about_missing_glyphs = false
-- This will hold the configuration.

-- Configure font and font size
config.font = wezterm.font_with_fallback({
	{ family = "CommitMono" },
	{ family = "Symbols Nerd Font Mono" },
	{ family = "Noto Color Emoji" },
	{ family = "CaskaydiaMono Nerd Font" },
	-- { family = "Cascadia Mono" },
	-- { family = "Hack Nerd Font Mono" },
	-- { family = "Monaspace Neon" },
	-- { family = "JetBrains Mono" },
	-- { family = "Monaspace Argon" },
	-- { family = "Consolas Nerd Font" },
})
config.font_size = 16
config.underline_thickness = 4

local background = require("background")
config.background = background.solid(background.Colors.Dark_Blue)

config.colors = require("./theme")

local tabbar = require("tabBar")
tabbar.apply_to_config(config)
config.show_new_tab_button_in_tab_bar = false
local keys = require("keybinds")
keys.apply_to_config(config)

config.max_fps = 165
-- config.front_end = "WebGpu"

config.cursor_thickness = 2

config.color_scheme = "BlueDolphin"
config.window_decorations = "NONE"
config.window_close_confirmation = "NeverPrompt"
config.hide_mouse_cursor_when_typing = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.window_padding = {
	left = 10,
	right = 10,
	top = 5,
	bottom = 0,
}

local launch_menu = {}
table.insert(launch_menu, {
	label = "Pwsh",
	args = { "-NoLogo" },
})

config.launch_menu = launch_menu

--Remember size
-- wezterm.on("gui-startup", function(cmd)
-- 	local _, _, window = mux.spawn_window(cmd or {})
-- 	window:gui_window():maximize()
-- end)

return config
