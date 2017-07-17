--[[

     Powerarrow Darker Awesome WM config 2.0
     github.com/copycat-killer

--]]

theme = {}

themes_dir = os.getenv("HOME") .. "/.config/awesome/theme"
icons_dir = themes_dir .. "/icons/"

theme.wallpaper_l = themes_dir .. "/wall_l.png"
theme.wallpaper_c = themes_dir .. "/wall_c.png"
theme.wallpaper_r = themes_dir .. "/wall_r.png"
theme.font = "Terminus 9"
theme.fg_normal = "#DDDDFF"
theme.fg_focus = "#F0DFAF"
theme.bg_normal = "#000000"
theme.bg_focus = "#484848"
theme.border_width = "1"
theme.border_normal = theme.bg_normal
theme.border_focus = "#7F7F7F"
theme.border_marked = "#CC9393"
theme.titlebar_bg_focus = "#FFFFFF"
theme.titlebar_bg_normal = theme.titlebar_bg_focus
theme.taglist_fg_focus = "#55FF00"
theme.tasklist_fg_focus = theme.taglist_fg_focus
theme.tasklist_bg_focus = "#1A1A1A"
theme.waring = "#FF0000"
theme.textbox_widget_margin_top = 1
theme.notify_fg = theme.fg_normal
theme.notify_bg = theme.bg_normal
theme.notify_border = theme.border_focus
theme.awful_widget_height = 14
theme.awful_widget_margin_top = 2
theme.menu_height = "16"
theme.menu_width = "140"

theme.submenu_icon = icons_dir .. "submenu.png"
theme.taglist_squares_sel = icons_dir .. "square_sel.png"
theme.taglist_squares_unsel = icons_dir .. "square_unsel.png"

theme.layout_tile = icons_dir .. "tile.png"
theme.layout_tilegaps = icons_dir .. "tilegaps.png"
theme.layout_tileleft = icons_dir .. "tileleft.png"
theme.layout_tilebottom = icons_dir .. "tilebottom.png"
theme.layout_tiletop = icons_dir .. "tiletop.png"
theme.layout_fairv = icons_dir .. "fairv.png"
theme.layout_fairh = icons_dir .. "fairh.png"
theme.layout_spiral = icons_dir .. "spiral.png"
theme.layout_dwindle = icons_dir .. "dwindle.png"
theme.layout_max = icons_dir .. "max.png"
theme.layout_fullscreen = icons_dir .. "fullscreen.png"
theme.layout_magnifier = icons_dir .. "magnifier.png"
theme.layout_floating = icons_dir .. "floating.png"

theme.arrl = icons_dir .. "arrl.png"
theme.arrl_dl = icons_dir .. "arrl_dl.png"
theme.arrl_ld = icons_dir .. "arrl_ld.png"

theme.widget_ac = icons_dir .. "ac.png"
theme.widget_battery = icons_dir .. "battery.png"
theme.widget_battery_low = icons_dir .. "battery_low.png"
theme.widget_battery_empty = icons_dir .. "battery_empty.png"
theme.widget_mem = icons_dir .. "mem.png"
theme.widget_cpu = icons_dir .. "cpu.png"
theme.widget_temp = icons_dir .. "temp.png"
theme.widget_net = icons_dir .. "net.png"
theme.widget_hdd = icons_dir .. "hdd.png"
theme.widget_music = icons_dir .. "note.png"
theme.widget_music_on = icons_dir .. "note_on.png"
theme.widget_vol = icons_dir .. "vol.png"
theme.widget_vol_low = icons_dir .. "vol_low.png"
theme.widget_vol_no = icons_dir .. "vol_no.png"
theme.widget_vol_mute = icons_dir .. "vol_mute.png"
theme.widget_mail = icons_dir .. "mail.png"
theme.widget_mail_on = icons_dir .. "mail_on.png"
theme.widget_task = icons_dir .. "task.png"
theme.widget_rs_on = icons_dir .. "redshift_on.png"
theme.widget_rs_off = icons_dir .. "redshift_off.png"

theme.tasklist_disable_icon = true
theme.tasklist_floating = ""
theme.tasklist_maximized_horizontal = ""
theme.tasklist_maximized_vertical = ""

return theme
