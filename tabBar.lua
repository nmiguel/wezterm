local wezterm = require("wezterm")
local module = {}

local pallette = require("pallette")

local mysplit = function (inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                table.insert(t, str)
        end
        return t
end

function module.apply_to_config(config)
  config.window_frame = {
    font = wezterm.font("Consolas Nerd Font"),
    font_size = 14.0,
    active_titlebar_bg = pallette.orange,
    inactive_titlebar_bg = pallette.black
  }

  config.use_fancy_tab_bar = false
  config.tab_bar_at_bottom = false
  config.tab_max_width = 40


  -- The filled in variant of the < symbol
  local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider

  -- The filled in variant of the > symbol
  local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

  local get_last_folder_segment = function(cwd)
      if cwd == nil then
          return "N/A" -- or some default value you prefer
      end

      -- Strip off 'file:///' if present
      local pathStripped = string.match(cwd, "^file:///(.+)") or cwd
      -- Normalize backslashes to slashes for Windows paths
      pathStripped = string.gsub(pathStripped, "\\", "/")
      -- Split the path by '/'
      local path = {}
      for segment in string.gmatch(pathStripped, "[^/]+") do
          table.insert(path, segment)
      end
      return path[#path] -- returns the last segment
  end


  local function get_current_working_dir(tab)
      local current_dir = tab.active_pane.current_working_dir.file_path or ''
      return get_last_folder_segment(current_dir)
  end

  -- This function returns the suggested title for a tab.
  -- It prefers the title that was set via `tab:set_title()`
  -- or `wezterm cli set-tab-title`, but falls back to the
  -- title of the active pane in that tab.
  local function tab_title(tab_info)
    local title = tab_info.tab_title
    -- if the tab title is explicitly set, take that
    if title and #title > 0 then
      return title
    end
    -- Otherwise, use the title from the active pane
    -- in that tab

    local splittedTitle = mysplit(tab_info.active_pane.title, '/')
    splittedTitle = splittedTitle[#splittedTitle]
    if splittedTitle == "v" or splittedTitle == "nvim" then
        return "nvim: " .. get_current_working_dir(tab_info)
    end
    return splittedTitle

  end


  wezterm.on(
    'format-tab-title',
    function(tab, tabs, panes, config, hover, max_width)
      local background = pallette.dark_blue
      local foreground = pallette.white
      local left_edge_background = background
      local left_edge_foreground = pallette.grey
      local right_edge_background = pallette.grey
      local right_edge_foreground = background

      if tab.is_active then
        background = pallette.blue
        left_edge_foreground = pallette.grey
        left_edge_background = background
        right_edge_foreground = background
      end

      local is_first_tab = tab.tab_index == 0
      if is_first_tab then
        if tab.is_active then
          left_edge_foreground = pallette.red
        end
        left_edge_foreground = background
      end

      local is_last_tab = #tabs - 1 == tab.tab_index
      if is_last_tab then
        right_edge_background = pallette.clear
      end

      -- local process = tab.active_pane.foreground_process_name:match("([^/\\]+)$")
      -- process = string.match(process, "^(.-)%.")
      -- if process == "wslhost" then
      --     process = ""
      -- end
      -- if process ~= "" then
      --     process = process .. ": "
      -- end
      local process = ""

      local title =  process .. tab_title(tab)

      -- ensure that the titles fit in the available space,
      -- and that we have room for the edges.
      title = wezterm.truncate_right(title, max_width - 4)

      return {
        { Background = { Color = left_edge_background } },
        { Foreground = { Color = left_edge_foreground } },
        { Text = SOLID_RIGHT_ARROW },
        { Background = { Color = background } },
        { Foreground = { Color = foreground } },
        { Text = ' ' .. title  .. ' ' },
        { Background = { Color = right_edge_background } },
        { Foreground = { Color = right_edge_foreground } },
        { Text = SOLID_RIGHT_ARROW },
      }
    end
  )
end

return module
