--[[

     Powerarrow Darker Awesome WM config 2.0
     github.com/copycat-killer

--]]

theme = {}

theme.font = "Noto 9"
theme.taglist_font = "Noto Emoji 11"
theme.fg_normal = "#CCD0C4"
theme.fg_focus = "#55FF00"
theme.bg_normal = "#002B36"
theme.bg_focus = "#405D27"
theme.border_focus = "#7F7F7F"
theme.border_marked = "#CC9393"
theme.titlebar_bg_focus = "#FDF6E3"
theme.waring = "#FF0000"
theme.border_width = "1"
theme.border_normal = theme.bg_normal
theme.titlebar_bg_normal = theme.titlebar_bg_focus
theme.taglist_fg_focus = theme.fg_focus
theme.tasklist_fg_focus = theme.fg_focus
theme.tasklist_bg_focus = theme.bg_focus
theme.textbox_widget_margin_top = 1
theme.notify_fg = theme.fg_normal
theme.notify_bg = theme.bg_normal
theme.notify_border = theme.border_focus
theme.awful_widget_height = 14
theme.awful_widget_margin_top = 2
theme.menu_height = "16"
theme.menu_width = "140"
theme.tasklist_disable_icon = true
theme.tasklist_floating = ""
theme.tasklist_maximized_horizontal = ""
theme.tasklist_maximized_vertical = ""

themes_dir = os.getenv("HOME") .. "/.config/awesome/theme"
png = ".png"

theme.wallpapers = { themes_dir .. "/wall_l" .. png, themes_dir .. "/wall_c" .. png, themes_dir .. "/wall_r" .. png}

return theme
