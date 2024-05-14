---@diagnostic disable: undefined-field
local wezterm = require("wezterm")
local module = {}
local sessionizer = require("sessionizer")

local pallette = require("pallette")

function module.apply_to_config(config)
	config.keys = {
		{
			key = "v",
			mods = "CTRL",
			action = wezterm.action.PasteFrom("Clipboard"),
		},
		{
			key = "n",
			mods = "ALT",
			action = wezterm.action.SpawnCommandInNewTab({}),
		},
		{
			key = "r",
			mods = "ALT",
			action = wezterm.action_callback(function(_, _)
				wezterm.GLOBAL.background_index = wezterm.GLOBAL.background_index + 1
                wezterm.reload_configuration()
			end),
		},

		{ key = "h", mods = "ALT", action = wezterm.action.ActivateTabRelative(-1) },
		{ key = "l", mods = "ALT", action = wezterm.action.ActivateTabRelative(1) },
		{
			key = "d",
			mods = "ALT",
			action = wezterm.action.CloseCurrentTab({ confirm = true }),
		},

		--Sessionizer
		{ key = "f", mods = "ALT", action = wezterm.action_callback(sessionizer.toggle) },
		{
			key = "w",
			mods = "ALT",
			action = wezterm.action.CloseCurrentPane({ confirm = true }),
		},

		{ key = "Space", mods = "CTRL", action = wezterm.action.ActivateCopyMode },

		{ key = "x", mods = "ALT", action = wezterm.action.SplitVertical({}) },

		{ key = "v", mods = "ALT", action = wezterm.action.SplitHorizontal({}) },

		{ key = "i", mods = "ALT", action = wezterm.action.SwitchToWorkspace },

		{ key = "s", mods = "ALT", action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },

		{ key = "p", mods = "ALT", action = wezterm.action.EmitEvent("save-workspaces") },

		{ key = "j", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Next") },

		{ key = "k", mods = "ALT", action = wezterm.action.ActivatePaneDirection("Prev") },
	}
end

return module
