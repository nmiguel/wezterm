-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux

-- This table will hold the configuration.
local config = wezterm.config_builder()

config.wsl_domains = {
	{
		name = "WSL:Ubuntu-22.04",
		distribution = "Ubuntu-22.04",
		default_cwd = "~",
		-- default_prog = { "tmux" },
	},
}
config.default_domain = "WSL:Ubuntu-22.04"
config.debug_key_events = true
-- This will hold the configuration.

-- Configure font and font size
config.font = wezterm.font_with_fallback({
	{ family = "Consolas Nerd Font" },
	{ family = "Symbols Nerd Font Mono" },
	{ family = "Noto Color Emoji" },
})
config.font_size = 15
config.underline_position = "-3px"
config.underline_thickness = 3

local background = require("background")
config.background = background.image()

config.colors = require("./theme")

local tabbar = require("tabBar")
tabbar.apply_to_config(config)
config.show_new_tab_button_in_tab_bar = false
local keys = require("keybinds")
keys.apply_to_config(config)

config.max_fps = 165
-- config.front_end = "WebGpu"

config.color_scheme = "BlueDolphin"
config.window_decorations = "RESIZE"
config.window_close_confirmation = "NeverPrompt"
config.hide_mouse_cursor_when_typing = true
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.window_padding = {
	left = 20,
	right = 20,
	top = 35,
	bottom = 15,
}

local launch_menu = {}
table.insert(launch_menu, {
	label = "Pwsh",
	args = { "-NoLogo" },
})

config.launch_menu = launch_menu

--Remember size
wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

return config
