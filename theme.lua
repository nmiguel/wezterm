local colors = {}
local pallette = require("pallette")

-- colors.background = pallette.black
colors.foreground = pallette.white
colors.cursor_bg = pallette.white
colors.cursor_fg = pallette.yellow
colors.split = pallette.white
colors.copy_mode_active_highlight_bg = { Color = pallette.orange}

-- tab bar
colors.tab_bar = {
  background = 'none',
  active_tab  = {
    bg_color = pallette.blue,
    fg_color = pallette.white
  },
  inactive_tab = {
    bg_color = pallette.black,
    fg_color = pallette.white
  },
  new_tab = {
    bg_color = pallette.black,
    fg_color = pallette.white
  }
}

return colors
