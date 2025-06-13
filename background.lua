local M = {}
local wezterm = require("wezterm")
local act = wezterm.action

local color_prefix = "Solid Color: "

M.Colors = {
	Dark_Blue = "#131a21",
	Dark_Purple = "#111621",
}

M.random_image = function()
	return require("../lib/files").getRandomFileByExtension("wallpapers/", { "png", "jpg", "jpeg", "gif" })
end

M.solid = function(color)
	wezterm.log_info("New background color: " .. color)
	return {
		{
			source = {
				Color = color,
			},
			width = "110%",
			horizontal_offset = "-5%",
			height = "110%",
			vertical_offset = "-5%",
			opacity = 0.75,
		},
	}
end

M.image = function()
	wezterm.GLOBAL.background_image = wezterm.GLOBAL.background_image or M.random_image()
	if wezterm.GLOBAL.background_image:match("^#") then
		return M.solid(wezterm.GLOBAL.background_image)
	end

	wezterm.log_info("New background: " .. wezterm.GLOBAL.background_image)
	return {
		{
			source = {
				File = wezterm.GLOBAL.background_image,
			},
		},
		{
			source = {
				Color = "#131a21",
			},
			width = "110%",
			horizontal_offset = "-5%",
			height = "110%",
			vertical_offset = "-5%",
			opacity = 0.9,
		},
	}
end

M.select = function(window, pane, config)
	local images = {}
	wezterm.log_info("Running fd")
	local path = "/mnt/c/Users/Nuno Ramos/.config/wezterm/wallpapers"

	local success, stdout, stderr = wezterm.run_child_process({
		"wsl.exe",
		"/home/nomig/.local/bin/fd",
		"-L",
		"-HI",
		"-tf",
		".",
		"--full-path",
		"--max-depth=2",
		"--min-depth=0",
		path,
	})

	if not success then
		wezterm.log_error("Failed to run fd: " .. stderr)
		return
	end

	for line in stdout:gmatch("([^\n]*)\n?") do
		local id = line:gsub(".*/wallpapers/", "")
		local label = id:gsub("-", " "):gsub("_", " "):match("(.+)%..+$")
		id = path .. "/" .. id
		id = id:gsub("/mnt/c", "C:")
		table.insert(images, { label = tostring(label), id = tostring(id) })
	end

	-- join with solid colors, prefix them with color-
	for color, hex in pairs(M.Colors) do
		table.insert(images, { label = color_prefix .. color, id = hex })
	end

	window:perform_action(
		act.InputSelector({
			action = wezterm.action_callback(function(_, _, id, label)
				wezterm.log_info("label: " .. label)
				wezterm.log_info("id: " .. id)
				if not id and not label then
					wezterm.log_info("Cancelled")
					return
				end
				for k in pairs(config.background) do
					config.background[k] = nil
				end

				if label:match("^" .. color_prefix) then
					wezterm.log_info("Selected " .. label)
					wezterm.log_info("Using as background " .. id)
					wezterm.GLOBAL.background_image = id
				else
					wezterm.log_info("Selected " .. label)
					wezterm.log_info("Using as background " .. id)
					wezterm.GLOBAL.background_image = id
				end
				wezterm.reload_configuration()
			end),
			fuzzy = true,
			title = "Select background",
			choices = images,
		}),
		pane
	)
end

return M
