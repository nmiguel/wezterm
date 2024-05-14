local M = {}

function M.solid()
	return {
		{
			source = {
				Gradient = {
					colors = {
						"#131a21",
					},
					orientation = {
						Radial = {
							cx = 1,
							cy = 0.75,
							radius = 0.5,
						},
					},
				},
			},
			width = "100%",
			height = "100%",
		},
	}
end

function M.image()
	local file_path = require("../lib/files").getRandomFileByExtension("wallpapers/", { "png", "jpg", "jpeg", "gif" })
	return {
		{
			source = {
				File = file_path,
			},
			width = "100%",
			height = "100%",
		},
		-- {
		-- 	source = {
		-- 		Gradient = {
		-- 			colors = {
		-- 				"rgba(0.5, 0.5, 0.5, 0.4)",
		-- 				"rgba(0.5, 0.5, 0.5, 0.55)",
		-- 				"rgba(0.5, 0.5, 0.5, 0.65)",
		-- 			},
		-- 			orientation = {
		-- 				Radial = {
		-- 					cx = 1,
		-- 					cy = 0.5,
		-- 					radius = 0.5,
		-- 				},
		-- 			},
		-- 		},
		-- 	},
		-- 	width = "100%",
		-- 	height = "100%",
		-- },
		{
			source = {
				Color = "#131a21",
			},
			width = "100%",
			height = "100%",
            opacity = 0.75,
		},
	}
end

return M
