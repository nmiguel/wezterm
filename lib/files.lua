local wezterm = require("wezterm")

local M = {}
-- Function to get a random file by extension
function M.getRandomFileByExtension(path, extensions)
	-- Combine the directory path with the extensions to create glob patterns
	local patterns = {}
	for _, ext in ipairs(extensions) do
		if not ext:match("^%.") then
			ext = "." .. ext
		end
		table.insert(patterns, path .. "/*" .. ext)
	end

	-- Use glob to find matching files for all patterns
	local directoryPath = wezterm.config_file:match("(.*[\\/])")
	local matchingFiles = {}
	for _, pattern in ipairs(patterns) do
		local files = wezterm.glob(pattern, directoryPath)
		for _, file in ipairs(files) do
			table.insert(matchingFiles, file)
		end
	end

	-- Select a random file from the list of matching files
	if #matchingFiles > 0 then
		math.randomseed(os.time()) -- Seed the random number generator
		wezterm.GLOBAL.background_index = (wezterm.GLOBAL.background_index or math.random(#matchingFiles))
        if wezterm.GLOBAL.background_index > #matchingFiles then
            wezterm.GLOBAL.background_index = math.fmod(wezterm.GLOBAL.background_index , #matchingFiles)
        end
		local matchingFile = (directoryPath .. matchingFiles[wezterm.GLOBAL.background_index]):gsub("\\", "/")
		wezterm.log_info("Random file selected: " .. matchingFile)
		return matchingFile
	else
		print("No files found with the specified extensions.")
		return nil, "No files found with the specified extensions."
	end
end

return M
