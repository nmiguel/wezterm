-- ~.config/wezterm/sessionizer.lua

local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

local function switch_or_create_workspace(win, pane, workspace)
	local mux = wezterm.mux
	local exists = false
	for _, w in ipairs(mux.all_windows()) do
		if w:get_workspace() == workspace then
			exists = true
			break
		end
	end

	if exists then
		wezterm.log_info("Switching to existing workspace: " .. workspace)
		win:perform_action(act.SwitchToWorkspace({ name = workspace, spawn = { cwd = workspace } }), pane)
	else
		wezterm.log_info("Creating new workspace with three tabs: " .. workspace)
		local _, active_pane, new_win = mux.spawn_window({ workspace = workspace, cwd = workspace })
		-- new_win already has one tab; add two more to have three in total
		for i = 1, 2 do
			new_win:spawn_tab({cwd = workspace})
		end
		win:perform_action(act.SwitchToWorkspace({ name = workspace, spawn = { cwd = workspace } }), active_pane)
		win:perform_action(act.ActivateTab(0), active_pane)
	end
end

M.toggle = function(window, pane)
	local projects = {}
	wezterm.log_info("Running fd")

	local success, stdout, stderr = wezterm.run_child_process({
		"wsl.exe",
		"/home/nomig/.local/bin/fd",
		"-HI",
		"-td",
		"-tl",
		"-L",
		".",
		"--full-path",
		"--max-depth=2",
		"--min-depth=2",
		"/home/nomig/projects",
		-- NOTE: add more paths here, depth = 2
	})

	local success2, stdout2, stderr2 = wezterm.run_child_process({
		"wsl.exe",
		"/home/nomig/.local/bin/fd",
		"-HI",
		"-td",
		"-tl",
		"-L",
		".",
		"--full-path",
		"--max-depth=1",
		"--min-depth=1",
		"/mnt/c/Users/Nuno Ramos/.config",
		-- NOTE: add more paths here, depth = 1
	})

	success = success and success2
	stdout = stdout .. stdout2
	stderr = stderr .. stderr2

	-- NOTE: Add more paths here
	stdout = stdout .. "/home/nomig/projects/personal/.dotfiles/.config/nvim\n"

	if not success then
		wezterm.log_error("Failed to run fd: " .. stderr)
		return
	end

	for line in stdout:gmatch("([^\n]*)\n?") do
		local label = line
		local id = line:gsub("^.*/(.-/.+)$", "%1")
		table.insert(projects, { label = tostring(id), id = tostring(label) })
	end

	window:perform_action(
		act.InputSelector({
			action = wezterm.action_callback(function(win, pane, id, label)
				if not id and not label then
					wezterm.log_info("Cancelled")
				else
					wezterm.log_info("Selected " .. id)
					switch_or_create_workspace(win, pane, id)
				end
			end),
			fuzzy = true,
			title = "Select project",
			choices = projects,
		}),
		pane
	)
end

return M
