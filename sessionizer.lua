-- ~.config/wezterm/sessionizer.lua

local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

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
		local project = line:gsub("/.git/$", "")
		local label = project
		local id = project:gsub(".*/", "")
		table.insert(projects, { label = tostring(label), id = tostring(id) })
	end

	window:perform_action(
		act.InputSelector({
			action = wezterm.action_callback(function(win, _, id, label)
				if not id and not label then
					wezterm.log_info("Cancelled")
				else
					wezterm.log_info("Selected " .. label)
					win:perform_action(act.SwitchToWorkspace({ name = id, spawn = { cwd = label } }), pane)
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
