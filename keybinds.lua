local wezterm = require("wezterm")
local module = {}
local sessionizer = require("sessionizer")

local pallette = require("pallette")

function module.apply_to_config(config)
	config.keys = {
		-- Mine
		{
			key = "v",
			mods = "CTRL",
			action = wezterm.action.PasteFrom("Clipboard"),
		},
		{
			key = "n",
			mods = "SHIFT|ALT",
			action = wezterm.action.SpawnCommandInNewTab( { cwd = "/mnt/c" }),
		},
		{ key = "h", mods = "SHIFT|ALT", action = wezterm.action.ActivateTabRelative(-1) },
		{ key = "l", mods = "SHIFT|ALT", action = wezterm.action.ActivateTabRelative(1) },
		{
			key = "D",
			mods = "SHIFT|ALT",
			action = wezterm.action.CloseCurrentTab({ confirm = true }),
		},
		--
		--Sessionizer
		{ key = "f", mods = "SHIFT|ALT", action = wezterm.action_callback(sessionizer.toggle) },
		-- Show launcher for workspaces
		{
			key = "d",
			mods = "ALT",
			action = wezterm.action.CloseCurrentPane({ confirm = true }),
		},

		-- From dotfiles
		{ key = "Space", mods = "CTRL", action = wezterm.action.ActivateCopyMode },
		-- { key = "n", mods = "ALT", action = wezterm.action.SpawnTab("DefaultDomain") },
		-- { key = "d", mods = "ALT", action = wezterm.action.CloseCurrentTab({ confirm = true }) },
		{ key = "x", mods = "SHIFT|ALT", action = wezterm.action.SplitVertical({}) },
		{ key = "v", mods = "SHIFT|ALT", action = wezterm.action.SplitHorizontal({}) },
		{ key = "i", mods = "SHIFT|ALT", action = wezterm.action.SwitchToWorkspace },
		{ key = "s", mods = "SHIFT|ALT", action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
		{ key = "p", mods = "SHIFT|ALT", action = wezterm.action.EmitEvent("save-workspaces") },

		{ key = "j", mods = "SHIFT|ALT", action = wezterm.action.ActivatePaneDirection("Next") },
		{ key = "k", mods = "SHIFT|ALT", action = wezterm.action.ActivatePaneDirection("Prev") },

		--New workspace
		-- {
		-- 	key = "w",
		-- 	mods = "SHIFT|ALT",
		-- 	action = wezterm.action.PromptInputLine({
		-- 		description = wezterm.format({
		-- 			{ Attribute = { Intensity = "Bold" } },
		-- 			{ Foreground = { Color = pallette.white } },
		-- 			{ Text = "Enter name for new workspace" },
		-- 		}),
		-- 		action = wezterm.action_callback(function(window, pane, line)
		-- 			if line then
		-- 				window:perform_action(
		-- 					wezterm.action.SwitchToWorkspace({
		-- 						name = line,
		-- 					}),
		-- 					pane
		-- 				)
		-- 			end
		-- 		end),
		-- 	}),
		-- },

		-- Rename tab
		{
			key = "t",
			mods = "SHIFT|ALT",
			action = wezterm.action.PromptInputLine({
				description = wezterm.format({
					{ Attribute = { Intensity = "Bold" } },
					{ Foreground = { Color = pallette.white } },
					{ Text = "Rename current tab" },
				}),
				action = wezterm.action_callback(function(_, pane, line)
					if line then
						pane:tab():set_title(line)
					end
				end),
			}),
		},
	}

	-- tab navigation
	-- for i = 1, 9 do
	-- 	table.insert(config.keys, {
	-- 		key = tostring(i),
	-- 		mods = "ALT",
	-- 		action = wezterm.action.ActivateTab(i - 1),
	-- 	})
	-- end

	-- pane navigation
	-- local navigation_keybinds = require("navigation")
	--
	-- for _, keybind in pairs(navigation_keybinds) do
	-- 	table.insert(config.keys, keybind)
	-- end
end

return module
