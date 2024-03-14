-- Pull in the wezterm API
local wezterm = require("wezterm")
local mux = wezterm.mux

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Configure font and font size
config.font = wezterm.font("Consolas Nerd Font", { weight = "Regular", italic = false })
config.font_size = 18

-- Setting the background image and its opacity
config.background = {
	{
		source = { File = "C:/Users/Nuno Ramos/Pictures/Wallpapers/ocean.png" },
	},
	{
		source = { Color = "rgba(0,0,0,0.5)" },
		width = "100%",
		height = "100%",
	},
}

config.window_decorations = "RESIZE"
config.window_close_confirmation = 'NeverPrompt'
config.enable_tab_bar = false
config.window_padding = {
	left = 6,
	right = 2,
	top = 30,
	bottom = "4px",
}

--Remember size
wezterm.on("gui-startup", function()
	local tab, pane, window = mux.spawn_window({})
	window:gui_window():maximize()
end)

config.keys = {
	{
		key = "v",
		mods = "CTRL",
		action = wezterm.action.PasteFrom("Clipboard"),
	},
}

return config
