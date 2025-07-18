---@diagnostic disable: undefined-field
local wezterm = require("wezterm")
local module = {}
local background = require("background")


function module.apply_to_config(config)
	config.keys = {
		-- {
		-- 	key = "v",
		-- 	mods = "CTRL",
		-- 	action = wezterm.action.PasteFrom("Clipboard"),
		-- },
		{
			key = "r",
			mods = "ALT|SHIFT",
			action = wezterm.action_callback(function(_, _)
				wezterm.GLOBAL.background_index = wezterm.GLOBAL.background_index + 1
				wezterm.GLOBAL.background_image = background.random_image()
				wezterm.reload_configuration()
			end),
		},

		{ key = "h", mods = "ALT|SHIFT", action = wezterm.action.ActivateTabRelative(-1) },
		{ key = "l", mods = "ALT|SHIFT", action = wezterm.action.ActivateTabRelative(1) },
		{
			key = "d",
			mods = "ALT|SHIFT",
			action = wezterm.action.CloseCurrentPane({ confirm = true }),
		},

		--Sessionizer
		{
			key = "t",
			mods = "ALT|SHIFT",
			action = wezterm.action_callback(function(window, pane)
				background.select(window, pane, config)
			end),
		},

	}
end

return module
