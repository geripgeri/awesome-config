--[[

     Powerarrow Darker Awesome WM config 2.0
     github.com/copycat-killer

--]]

theme = {}

theme.font = "Terminus 9"
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

local function get_icon(dir_name, file_name)
   return themes_dir .. "/icons/" .. dir_name .. "/1x_web/ic_" .. file_name .. "_white_36dp" .. png
end

theme.wallpaper_l = themes_dir .. "/wall_l" .. png
theme.wallpaper_c = themes_dir .. "/wall_c" .. png
theme.wallpaper_r = themes_dir .. "/wall_r" .. png

theme.widget_ac = get_icon("device", "battery_charging_full")
theme.widget_battery = get_icon("device", "battery_full")
theme.widget_battery_low = get_icon("device", "battery_20")
theme.widget_battery_empty = get_icon("device", "battery_alert")
theme.widget_mem = get_icon("hardware", "memory")
theme.widget_cpu = get_icon("device", "data_usage")
theme.widget_temp = get_icon("hardware", "toys")
theme.widget_music = get_icon("image", "music_note")
theme.widget_music_on = theme.widget_music
theme.widget_vol = get_icon("av", "volume_up")
theme.widget_vol_low = get_icon("av", "volume_down")
theme.widget_vol_no = get_icon("av", "volume_mute")
theme.widget_vol_mute = get_icon("av", "volume_off")
theme.widget_rs_on = get_icon("action", "visibility")
theme.widget_rs_off = get_icon("action", "visibility_off")
theme.widget_vpn_on = get_icon("action", "lock")
theme.widget_vpn_off = get_icon("action", "lock_open")

theme.tag_icon_browser = get_icon("social", "public")
theme.tag_icon_ide = get_icon("action", "code")
theme.tag_icon_editor = get_icon("action", "build")
theme.tag_icon_im = get_icon("action", "question_answer")
theme.tag_icon_file_manager = get_icon("file", "folder")
theme.tag_icon_mail = get_icon("communication", "mail_outline")

return theme
