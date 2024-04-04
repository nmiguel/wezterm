-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux

-- This table will hold the configuration.
local config = wezterm.config_builder()

config.wsl_domains = {
    {
        name = "WSL:Ubuntu-22.04",
        distribution = "Ubuntu-22.04",
        default_prog = { "tmux" },
    }
}
config.default_domain = 'WSL:Ubuntu-22.04'
-- This will hold the configuration.

-- Configure font and font size
config.font = wezterm.font_with_fallback({ "Consolas Nerd Font", "Symbols Nerd Font Mono", "Noto Color Emoji"})
config.font_size = 17

-- Setting the background image and its opacity
config.background = {
    {
        source = { File = "C:/Users/Nuno Ramos/Pictures/Wallpapers/ocean.png" },
    },
    {
        source = { Color = "rgba(0,0,0,0.5)" },
        width = "100%",
        height = "100%",
    },
}

-- config.color_scheme = 'AdventureTime'
config.window_decorations = "RESIZE"
config.window_close_confirmation = "NeverPrompt"
config.hide_mouse_cursor_when_typing = false
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.window_padding = {
    left = 20,
    right = 20,
    top = 35,
    bottom = 15,
}

local launch_menu = {}
table.insert(launch_menu, {
    label = "Pwsh",
    args = { "-NoLogo" },
})

config.launch_menu = launch_menu

--Remember size
wezterm.on("gui-startup", function(cmd)
    local tab, pane, window = mux.spawn_window(cmd or {})
    window:gui_window():maximize()
end)


config.keys = {
    {
        key = "v",
        mods = "CTRL",
        action = wezterm.action.PasteFrom("Clipboard"),
    },
    {
        key = "t",
        mods = "SHIFT|ALT",
        action = act.SpawnTab("CurrentPaneDomain"),
    },
    { key = "h", mods = "SHIFT|ALT", action = act.ActivateTabRelative(-1) },
    { key = "l", mods = "SHIFT|ALT", action = act.ActivateTabRelative(1) },
    {
        key = "d",
        mods = "SHIFT|ALT",
        action = wezterm.action.CloseCurrentTab({ confirm = true }),
    },
    -- Show launcher for workspaces
    { key = 'o', mods = 'SHIFT|ALT', action = wezterm.action.ShowLauncherArgs {
        flags = "FUZZY|WORKSPACES",
    }},
}

return config
