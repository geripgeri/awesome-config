--[[

     Awesome Configuration
     http://github.com/geripgeri/awesome-config

--]]

-- {{{ Required libraries
local awesome, client, screen, tag = awesome, client, screen, tag
local ipairs, string, os, table, tostring, tonumber, type = ipairs, string, os, table, tostring, tonumber, type

local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local lain = require("lain")
local menubar = require("menubar")
-- }}}

-- {{{ Error handling
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        if in_error then return end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err),
            icon = theme.error_icon
        })
        in_error = false
    end)
end
-- }}}

-- {{{ Autostart windowless processes
local function run_once(cmd)
    local findme = cmd
    local firstspace = cmd:find(" ")
    if firstspace then
        findme = cmd:sub(0, firstspace - 1)
    end
    awful.spawn.with_shell(string.format("pgrep -u $USER -x %s > /dev/null || (%s)", findme, cmd))
end

run_once("urxvtd")
run_once("unclutter -root")
--- run_once("xcompmgr -c")
-- }}}

-- {{{ Variable definitions

-- beautiful init
beautiful.init(os.getenv("HOME") .. "/.config/awesome/theme/theme.lua")

-- common
modkey = "Mod4"
altkey = "Mod1"
terminal = "urxvtc" or "xterm"
shell = "zsh" or "bash"
toggle_master_command = "amixer -D pulse set Master 1+ toggle"
toggle_mpd_command = "mpc toggle || ncmpc toggle || pms toggle"
get_current_vpn_connection_name = shell .. " -c \"nmcli -g NAME,TYPE,STATE connection | awk -F: '\\$2 ~ /vpn/ && \\$3 ~ /activated/ {print \\$1}'\""

-- user defined
browser = "firefox"
browser_work = "firefox-aurora"
browser_incognito = "firefox --private-window"
browser2 = "chromium"
browser2_incognito = "chromium --incognito"
file_namager = "nautilus"
gui_editor = "emacsclient -nc"
graphics = "gimp"
musicplr = terminal .. " -e ncmpcpp"
top = terminal .. " -e top"
xmodmap = "xmodmap ~/.Xmodmap"
calculator = "gnome-calculator"
screenshot = "spectacle -g"

-- }}}

-- {{{ Tags
layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.right,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal
}
awful.layout.layouts = layouts

tag_web = "🌐"
tag_editor = "🔧"
tag_mail =  "📩"
tag_im =  "💬"

local tags = {
    {
        names = { tag_web, tag_editor, tag_mail, tag_im },
        layouts = { layouts[2], layouts[2], layouts[2], layouts[2] }
    },
    {
        names = { tag_im, tag_editor },
        layouts = { layouts[2], layouts[2] }
    },
    {
        names = { tag_web, tag_editor, tag_mail },
        layouts = { layouts[3], layouts[3], layouts[3] }
    }
}

awful.util.taglist_buttons = awful.util.table.join(awful.button({}, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end))

awful.util.tasklist_buttons = awful.util.table.join(awful.button({}, 1, function(c)
    if c == client.focus then
        c.minimized = true
    else
        -- Without this, the following
        -- :isvisible() makes no sense
        c.minimized = false
        if not c:isvisible() and c.first_tag then
            c.first_tag:view_only()
        end
        -- This will also un-minimize
        -- the client, if needed
        client.focus = c
        c:raise()
    end
end),

    awful.button({}, 3, function()
        local instance

        return function()
            if instance and instance.wibox.visible then
                instance:hide()
                instance = nil
            else
                instance = awful.menu.clients({ theme = { width = 250 } })
            end
        end
    end),
    awful.button({}, 4, function()
        awful.client.focus.byidx(1)
    end),
    awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end))
lain.layout.termfair.nmaster = 3
lain.layout.termfair.ncol = 1
lain.layout.termfair.center.nmaster = 3
lain.layout.termfair.center.ncol = 1
lain.layout.cascade.tile.offset_x = 2
lain.layout.cascade.tile.offset_y = 32
lain.layout.cascade.tile.extra_padding = 5
lain.layout.cascade.tile.nmaster = 5
lain.layout.cascade.tile.ncol = 2

-- }}}

-- {{{ Screen


local function set_wallpaper(screen)
    gears.wallpaper.maximized(theme.wallpapers[screen], screen, true)
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", function(s)
    -- Wallpaper
    set_wallpaper(s.index)
end)

-- }}}


-- {{{ Fuction for open terminal and stay opens after command returns
function open_terminal_and_hold(cmd)
    awful.util.spawn(terminal .. " -e " .. shell .. " -c \"" .. cmd .. " && " .. shell .. "\"")
end

-- }}}

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
local markup = lain.util.markup
local separators = lain.util.separators

-- Textclock
local date = awful.widget.watch("date +'%m.%d (%a)'", 60,
    function(widget, output)
        widget:set_markup(" " .. markup(theme.taglist_fg_focus, output))
    end)

local clock = awful.widget.watch("date +'%R '", 5,
    function(widget, output)
        widget:set_markup(" " .. markup(theme.taglist_fg_focus, output))
    end)


-- Redshift widget
local rs_on = theme.widget_rs_on
local rs_off = theme.widget_rs_off

local myredshift = wibox.widget.imagebox()
lain.widget.contrib.redshift:attach(myredshift,
    function(active)
        if active then
            myredshift:set_image(rs_on)
        else
            myredshift:set_image(rs_off)
        end
    end)

local empytwidget =awful.widget.watch("", 60,
    function(widget, output)
        widget:set_markup(" ")
    end)

-- MPD
local mpdicon = wibox.widget.imagebox(theme.widget_music)
mpdicon:buttons(awful.util.table.join(awful.button({}, 1, function() awful.util.spawn_with_shell(musicplr) end)))
theme.mpd = lain.widget.mpd({
    settings = function()
        if mpd_now.state == "play" then
            artist = " playing "
            title =  ""
            mpdicon:set_image(theme.widget_music_on)
        elseif mpd_now.state == "pause" then
            artist = " paused "
            title = ""
        else
            artist = ""
            title = ""
            mpdicon:set_image(theme.widget_music)
        end

        widget:set_markup(markup(theme.waring, artist) .. title)
    end
})

-- MEM
local memicon = wibox.widget.imagebox(theme.widget_mem)
local mem = lain.widget.mem({
    settings = function()
        if mem_now.free >= 0.3 then
            widget:set_text(" " .. string.format("%.2f", mem_now.free / 1000) .. " GB ")
        else
            widget:set_markup(markup(theme.waring, string.format("%.2f", mem_now.free / 1000) .. " GB "))
        end
    end
})

-- CPU
local cpuicon = wibox.widget.imagebox(theme.widget_cpu)
local cpu = lain.widget.cpu({
    settings = function()
        if cpu_now.usage <= 80 then
            widget:set_text(" " .. cpu_now.usage .. "% ")
        else
            widget:set_markup(markup(theme.waring, " " .. cpu_now.usage .. "% "))
        end
    end
})

cpuicon:buttons(awful.util.table.join(awful.button({}, 1, function() awful.util.spawn_with_shell(top) end)))
--cpu:buttons(awful.util.table.join(awful.button({}, 1, function() awful.util.spawn_with_shell(top) end)))


-- Coretemp
local tempicon = wibox.widget.imagebox(theme.widget_temp)
local temp = lain.widget.temp({
    tempfile = "/sys/class/thermal/thermal_zone1/temp",
    timeout = 10,
    settings = function()
        if coretemp_now <= 80 then
            widget:set_text(" " .. coretemp_now .. " °C ")
        else
            widget:set_markup(markup(theme.waring, " " .. coretemp_now .. " °C "))
        end
    end
})

-- Battery
local baticon = wibox.widget.imagebox(theme.widget_battery)
local bat = lain.widget.bat({
    settings = function()
        if tonumber(bat_now.perc) >= 15 then
            widget:set_markup(bat_now.perc .. "% / " .. bat_now.time)
        else
            widget:set_markup(markup(theme.waring, bat_now.perc .. "% / " .. bat_now.time))
        end

        if bat_now.perc == "N/A" or bat_now.status == "Full" or bat_now.status == "Charging" then
            widget:set_markup("")
            baticon:set_image(theme.widget_ac)
            return
        elseif tonumber(bat_now.perc) <= 5 then
            baticon:set_image(theme.widget_battery_empty)
        elseif tonumber(bat_now.perc) <= 15 then
            baticon:set_image(theme.widget_battery_low)
        else
            baticon:set_image(theme.widget_battery)
        end
    end
})

-- Current VPN Name
local vpnicon = wibox.widget.imagebox(theme.widget_vpn_off)
local vpn = awful.widget.watch(get_current_vpn_connection_name, 10,
    function(widget, output)
	if output == "" then
	   vpnicon:set_image(theme.widget_vpn_off)
  	   widget:set_text("")
	else
	   vpnicon:set_image(theme.widget_vpn_on)
	   widget:set_text(" " .. string.gsub(output, '\n$', ' '))
	end
    end)



-- ALSA volume
local volicon = wibox.widget.imagebox(theme.widget_vol)
local volume = lain.widget.alsa({
      settings = function()
	 if volume_now.status == "off" then
	    widget:set_markup(markup(theme.waring, " " .. volume_now.level .. "%"))
	    volicon:set_image(theme.widget_vol_mute)
	 else
	    widget:set_text(" " .. volume_now.level .. "% ")
	    if tonumber(volume_now.level) <= 20 then
	       volicon:set_image(theme.widget_vol_no)
	    elseif tonumber(volume_now.level) <= 50 then
	       volicon:set_image(theme.widget_vol_low)
	    else
	       volicon:set_image(theme.widget_vol)
	    end
	 end
      end
})

awful.util.taglist_buttons = awful.util.table.join(awful.button({}, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end))

awful.util.tasklist_buttons = awful.util.table.join(awful.button({}, 1, function(c)
    if c == client.focus then
        c.minimized = true
    else
        -- Without this, the following
        -- :isvisible() makes no sense
        c.minimized = false
        if not c:isvisible() and c.first_tag then
            c.first_tag:view_only()
        end
        -- This will also un-minimize
        -- the client, if needed
        client.focus = c
        c:raise()
    end
end),
    awful.button({}, 3, function()
        local instance

        return function()
            if instance and instance.wibox.visible then
                instance:hide()
                instance = nil
            else
                instance = awful.menu.clients({ theme = { width = 250 } })
            end
        end
    end),
    awful.button({}, 4, function()
        awful.client.focus.byidx(1)
    end),
    awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end))

lain.layout.termfair.nmaster = 3
lain.layout.termfair.ncol = 1
lain.layout.termfair.center.nmaster = 3
lain.layout.termfair.center.ncol = 1
lain.layout.cascade.tile.offset_x = 2
lain.layout.cascade.tile.offset_y = 32
lain.layout.cascade.tile.extra_padding = 5
lain.layout.cascade.tile.nmaster = 5
lain.layout.cascade.tile.ncol = 2

-- Separators
local arrl_dl = separators.arrow_left(theme.bg_focus, "alpha")
local arrl_ld = separators.arrow_left("alpha", theme.bg_focus)

function generate_right_section(widgets)
   local ret = { layout = wibox.layout.fixed.horizontal }

   table.insert(ret, wibox.widget.systray())
   table.insert(ret, arrl_ld)
   
   for i,v in ipairs(widgets) do
      if i % 4 == 1 or i % 4 == 2 then
	 table.insert(ret, wibox.container.background(v, theme.bg_focus))
	 if i % 4  == 2 then
	    table.insert(ret, arrl_dl)
	 end
      else
	 table.insert(ret, v)
	 if i % 4 == 0 then
	    table.insert(ret, arrl_ld)
	 end
      end
   end

   table.remove(ret,table.getn(ret))
   return ret
end
						   
awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(s.index)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Tags
    current_tags = awful.tag(tags[s.index].names, s, tags[s.index].layouts[s.index])

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
       screen  = s,
       filter  = awful.widget.taglist.filter.all,
       style   = {
	  shape = function(cr, width, height)
	     gears.shape.powerline (cr, width, height, -10)
	  end
       },
       layout   = {
	  spacing_widget = {
	     shape = function(cr, width, height)
		gears.shape.powerline (cr, width, height, -10)
	     end,
	  },
	  layout  = wibox.layout.fixed.horizontal
       },
       widget_template = {
	  {
	     {
                {
		   {
		      id     = 'icon_role',
		      widget = wibox.widget.imagebox,
		   },
		   widget  = wibox.container.margin,
                },
		{
		   id     = 'text_role',
		   widget = wibox.widget.textbox,
		},
                layout = wibox.layout.fixed.horizontal,
	     },
	     left  = 12,
	     right = 12,
	     widget = wibox.container.margin
	  },
	  id     = 'background_role',
	  widget = wibox.container.background,
       },
       buttons = awful.util.taglist_buttons
    }
    
    s.mytasklist = awful.widget.tasklist {
       screen   = s,
       filter   = awful.widget.tasklist.filter.currenttags,
       buttons  = awful.util.tasklist_buttons,
       style    = {
	  spacing = -10,
	  shape = function(cr, width, height)
	     gears.shape.powerline (cr, width, height, -10)
	  end,
       },
       -- Notice that there is *NO* wibox.wibox prefix, it is a template,
       -- not a widget instance.
       widget_template = {
	  {
	     {
		{
		   {
		      id     = 'text_role',
		      widget = wibox.widget.textbox,
		   },
		   layout = wibox.layout.fixed.horizontal,
		},
		left  = 15,
		right = 0,
		widget = wibox.container.margin
	     },
	     id     = 'background_role',
	     widget = wibox.container.background,
	  },
	  left  = -10,
	  right = 0,
	  widget = wibox.container.margin
       },
    }
    
    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = 18, bg = theme.bg_normal, fg = theme.fg_normal })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        {
            -- Left widgets
            layout = wibox.layout.fixed.horizontal,
	    s.mypromptbox,
	    s.mytaglist,
        },
        s.mytasklist, -- Middle widget
	-- Right widgets
	
	generate_right_section({ vpnicon, vpn, myredshift, empytwidget, mpdicon, theme.mpd.widget, volicon, volume.widget, memicon, mem.widget, cpuicon, cpu.widget, tempicon, temp.widget, baticon, bat.widget, date, clock }),
    }

    -- Quake application
    s.quake = lain.util.quake({ app = terminal })
end)

function toggle_wibox()
 for s in screen do
    s.mywibox.visible = not s.mywibox.visible
 end
end


-- }}}

-- {{{ Mouse Bindings
root.buttons(awful.util.table.join(awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(-- Controling Awesome
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift" }, "q", awesome.quit),

    -- Tag browsing
    awful.key({ modkey }, "Left", awful.tag.viewprev),
    awful.key({ modkey }, "Right", awful.tag.viewnext),
    awful.key({ modkey }, "Escape", awful.tag.history.restore),

    -- Non-empty tag browsing
    awful.key({ altkey }, "Left", function() lain.util.tag_view_nonempty(-1) end),
    awful.key({ altkey }, "Right", function() lain.util.tag_view_nonempty(1) end),

    -- Dynamic tagging
    awful.key({ modkey, "Shift" }, "n", function() lain.util.add_tag(layouts[2]) end), -- add new tag
    awful.key({ modkey, "Shift" }, "r", function() lain.util.rename_tag() end), -- rename tag
    awful.key({ modkey, "Shift" }, "Right", function() lain.util.move_tag(1) end), -- move to next tag
    awful.key({ modkey, "Shift" }, "Left", function() lain.util.move_tag(-1) end), -- move to previous tag
    awful.key({ modkey, "Shift" }, "d", function() lain.util.delete_tag() end), -- delete tag

    -- Default client focus
    awful.key({ altkey }, "k",
       function()
	    awful.client.focus.byidx(1)
	    if client.focus then client.focus:raise() end
        end),
    awful.key({ altkey }, "j",
        function()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),

    -- By direction client focus
    awful.key({ modkey }, "j",
        function()
            awful.client.focus.bydirection("down")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey }, "k",
        function()
            awful.client.focus.bydirection("up")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey }, "h",
        function()
            awful.client.focus.bydirection("left")
            if client.focus then client.focus:raise() end
        end),
    --    awful.key({ modkey }, "l",
    --        function()
    --            awful.client.focus.bydirection("right")
    --            if client.focus then client.focus:raise() end
    --        end),

    -- Panic mode, allways switch to screen 1, tag 2 named 'IDE' ;)
    awful.key({ altkey }, "a",
        function()
	   awful.tag.viewonly(awful.tag.gettags(1)[2])
	   if screen.count() > 1 then
	      awful.tag.viewonly(awful.tag.gettags(2)[2])
	   end
        end),

    -- Show/Hide Wibox
    awful.key({ modkey }, "b", function ()
	  toggle_wibox()
    end),

    -- Layout manipulation
    awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.byidx(1) end),
    awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.byidx(-1) end),
    awful.key({ modkey, "Control" }, "j", function() awful.screen.focus_relative(1) end),
    awful.key({ modkey, "Control" }, "k", function() awful.screen.focus_relative(-1) end),
    awful.key({ modkey, }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey, }, "Tab",
       function ()
	  awful.client.focus.byidx(-1)
	  if client.focus then
	     client.focus:raise()
	  end
    end),

    awful.key({ modkey, "Shift" }, "Tab",
       function ()
	  awful.client.focus.byidx(1)
	  if client.focus then
	     client.focus:raise()
	  end
    end),   
    awful.key({ altkey, "Shift" }, "l", function() awful.tag.incmwfact(0.05) end),
    awful.key({ altkey, "Shift" }, "h", function() awful.tag.incmwfact(-0.05) end),
    awful.key({ modkey, "Shift" }, "l", function() awful.tag.incnmaster(-1) end),
    awful.key({ modkey, "Shift" }, "h", function() awful.tag.incnmaster(1) end),
    awful.key({ modkey, "Control" }, "l", function() awful.tag.incncol(-1) end),
    awful.key({ modkey, "Control" }, "h", function() awful.tag.incncol(1) end),
    awful.key({ modkey, }, "space", function() awful.layout.inc(layouts, 1) end),
    awful.key({ modkey, "Shift" }, "space", function() awful.layout.inc(layouts, -1) end),
    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Standard program
    awful.key({ modkey, }, "Return", function() awful.util.spawn(terminal) end),

    -- Drop down terminal
    awful.key({ modkey, }, "z", function() awful.screen.focused().quake:toggle() end),

    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end),

    -- ALSA volume control
    awful.key({ modkey }, "Up",
        function()
            os.execute(string.format("%s set %s 1%%+", volume.cmd, volume.channel))
            volume.update()
        end),
    awful.key({}, "XF86AudioRaiseVolume",
        function()
            os.execute(string.format("%s set %s 1%%+", volume.cmd, volume.channel))
            volume.update()
        end),
    awful.key({ modkey }, "Down",
        function()
            os.execute(string.format("%s set %s 1%%-", volume.cmd, volume.channel))
            volume.update()
        end),
    awful.key({}, "XF86AudioLowerVolume",
        function()
            os.execute(string.format("%s set %s 1%%-", volume.cmd, volume.channel))
            volume.update()
        end),
    awful.key({ modkey }, "m",
        function()
            os.execute(string.format("%s set %s 1+ toggle", volume.cmd, volume.channel))
            volume.update()
        end),
    awful.key({}, "XF86AudioMute",
        function()
            os.execute(string.format("%s set %s 1+ toggle", volume.cmd, volume.channel))
            volume.update()
        end),
    awful.key({ modkey }, "XF86AudioRaiseVolume",
        function()
            os.execute(string.format("%s set %s 100%%", volume.cmd, volume.channel))
            volume.update()
        end),

    -- MPD control
    awful.key({ altkey, "Control" }, "Up",
        function()
            awful.util.spawn_with_shell("mpc toggle || ncmpc toggle || pms toggle")
            theme.mpd.update()
        end),
    awful.key({}, "XF86AudioPlay",
        function()
            awful.util.spawn_with_shell("mpc toggle || ncmpc toggle || pms toggle")
            theme.mpd.update()
        end),
    awful.key({ altkey, "Control" }, "Down",
        function()
            awful.util.spawn_with_shell("mpc stop || ncmpc stop || pms stop")
            theme.mpd.update()
        end),
    awful.key({ altkey, "Control" }, "Left",
        function()
            awful.util.spawn_with_shell("mpc prev || ncmpc prev || pms prev")
            theme.mpd.update()
        end),
    awful.key({}, "XF86AudioPrev",
        function()
            awful.util.spawn_with_shell("mpc prev || ncmpc prev || pms prev")
            theme.mpd.update()
        end),
    awful.key({ altkey, "Control" }, "Right",
        function()
            awful.util.spawn_with_shell("mpc next || ncmpc next || pms next")
            theme.mpd.update()
        end),
    awful.key({}, "XF86AudioNext",
        function()
            awful.util.spawn_with_shell("mpc next || ncmpc next || pms next")
            theme.mpd.update()
        end),

    -- Brightness
    awful.key({}, "XF86MonBrightnessUp", function() awful.util.spawn("light -A 10") end),
    awful.key({}, "XF86MonBrightnessDown", function() awful.util.spawn("light -U 10") end),

    awful.key({ modkey, altkey }, "Up", function() awful.util.spawn("light -A 10") end),
    awful.key({ modkey, altkey }, "Down", function() awful.util.spawn("light -U 10") end),

    -- Copy to clipboard
    awful.key({ modkey }, "c", function() os.execute("xsel -p -o | xsel -i -b") end),

    -- User programs
    awful.key({ modkey }, "l",
       function()
	  local semicolon = ";"
	  local lock_command = "i3lock -e -f -n -c " .. string.sub(theme.bg_normal, 2) .. semicolon .. toggle_master_command .. semicolon

	  if mpd_now.state == "play" then
	     awful.util.spawn_with_shell(toggle_mpd_command)
	     theme.mpd.update()
	     lock_command = lock_command .. toggle_mpd_command .. semicolon
	  end
	  
	  if volume_now.status ~= "off" then
	     os.execute(toggle_master_command)
	  end
	  os.execute(lock_command)
    end),
    awful.key({ modkey }, "w", function() awful.util.spawn(browser) end),
    awful.key({ modkey, "Shift" }, "w", function() awful.util.spawn(browser_work) end),
    awful.key({ modkey, "Control" }, "w", function() awful.util.spawn(browser_incognito) end),
    awful.key({ modkey }, "i", function() awful.util.spawn(browser2) end),
    awful.key({ modkey, "Control" }, "i", function() awful.util.spawn(browser2_incognito) end),
    awful.key({ modkey }, "s", function() awful.util.spawn(gui_editor) end),
    awful.key({ modkey }, "g", function() awful.util.spawn(graphics) end),
    awful.key({ modkey }, "e", function() awful.util.spawn(file_namager) end),
    awful.key({ altkey }, "p", function() awful.util.spawn(screenshot) end),
    awful.key({ modkey, "Shift" }, "t", function() lain.widget.contrib.redshift:toggle() end),
    awful.key({}, "XF86Calculator", function() awful.util.spawn(calculator) end),
    awful.key({modkey}, "XF86AudioPlay", function() awful.util.spawn(musicplr) end),    

    -- Prompt
    awful.key({ modkey }, "r", function() awful.screen.focused().mypromptbox:run() end),
    awful.key({ modkey }, "x",
        function()
            awful.prompt.run {
                prompt = "Run Lua code: ",
                textbox = awful.screen.focused().mypromptbox.widget,
                exe_callback = awful.util.eval,
                history_path = awful.util.get_cache_dir() .. "/history_eval"
            }
        end,
        { description = "lua execute prompt", group = "awesome" }))

clientkeys = awful.util.table.join(awful.key({ modkey, }, "f", function(c) c.fullscreen = not c.fullscreen end),
    awful.key({ modkey, }, "q", function(c) c:kill() end),
    awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle),
    awful.key({ modkey, "Control" }, "Return", function(c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey, }, "o", function(c) c:move_to_screen() end),
    awful.key({ modkey, }, "t", function(c) c.ontop = not c.ontop end),
    awful.key({ modkey, }, "n",
        function(c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end))

-- Bind all key numbers to tags.
-- be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
            function()
                local screen = mouse.screen
                local tag = awful.tag.gettags(screen)[i]
                if tag then
                    awful.tag.viewonly(tag)
                end
            end),
        -- Toggle tag.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
            function()
                local screen = mouse.screen
                local tag = awful.tag.gettags(screen)[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = awful.tag.gettags(client.focus.screen)[i]
                    if tag then
                        awful.client.movetotag(tag)
                    end
                end
            end),
        -- Toggle tag.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = awful.tag.gettags(client.focus.screen)[i]
                    if tag then
                        awful.client.toggletag(tag)
                    end
                end
            end))
end

clientbuttons = awful.util.table.join(awful.button({}, 1, function(c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Use xprop | grep WM_CLASS to find the class name.
if screen.count() == 3 then
    awful.rules.rules = {
        {
            rule = {},
            properties = {
                border_width = beautiful.border_width,
                border_color = beautiful.border_normal,
                focus = awful.client.focus.filter,
                keys = clientkeys,
                buttons = clientbuttons,
                size_hints_honor = false,
                buttons = clientbuttons,
                screen = awful.screen.preferred,
                placement = awful.placement.no_overlap + awful.placement.no_offscreen
            }
        },
        {
            rule = { class = "Thunderbird" },
            properties = { tag = screen[3].tags[3], switchtotag = true }
        },
        {
            rule = { class = "Skype" },
            properties = { tag = screen[2].tags[1] }
        },
        {
            rule = { class = "Telegram" },
            properties = { tag = screen[2].tags[1] }
        },
        {
            rule = { class = "Slack" },
            properties = { tag = screen[2].tags[1] }
        },
        {
            rule = { class = "Emacs" },
            properties = { tag = screen[3].tags[2], switchtotag = true }
        },
        {
            rule = { class = "Firefox" },
            properties = { tag = screen[1].tags[1], switchtotag = true }
        }  

    }
elseif screen.count() == 2 then
    awful.rules.rules = {
        {
            rule = {},
            properties = {
                border_width = beautiful.border_width,
                border_color = beautiful.border_normal,
                focus = awful.client.focus.filter,
                keys = clientkeys,
                buttons = clientbuttons,
                size_hints_honor = false,
		screen = awful.screen.preferred,
                placement = awful.placement.no_overlap + awful.placement.no_offscreen
            }
        },
	{
            rule = { class = "Thunderbird" },
            properties = { tag = screen[1].tags[3], switchtotag = true }
        },
        {
            rule = { class = "Skype" },
            properties = { tag = screen[2].tags[1],
			   placement = awful.placement.top_right,
			   honor_workarea = true }
        },
        {
            rule = { class = "Telegram" },
            properties = { tag = screen[2].tags[1],
			   placement = awful.placement.bottom_right,
			   honor_workarea = true }
        },
        {
            rule = { class = "Slack" },
            properties = { tag = screen[2].tags[1],
			   placement = awful.placement.top_left,
			   honor_workarea = true }
        },
        {
            rule = { class = "Emacs" },
            properties = { tag = screen[1].tags[2], switchtotag = true }
        },
        {
            rule = { class = "Firefox" },
            properties = { tag = screen[1].tags[1], switchtotag = true }
        }
    }
else
    awful.rules.rules = {
        {
            rule = {},
            properties = {
                border_width = beautiful.border_width,
                border_color = beautiful.border_normal,
                focus = awful.client.focus.filter,
                keys = clientkeys,
                buttons = clientbuttons,
                size_hints_honor = false
            }
        },
        {
            rule = { class = "Skype" },
            properties = { tag = screen[1].tags[4] }
        },
        {
            rule = { class = "Telegram" },
            properties = { tag = screen[1].tags[4] }
        },
        {
            rule = { class = "Slack" },
            properties = { tag = screen[1].tags[4], switchtotag = true }
        },
        {
            rule = { class = "Emacs" },
            properties = { tag = screen[1].tags[2], switchtotag = true }
        },
	{
            rule = { class = "Thunderbird" },
            properties = { tag = screen[1].tags[3], switchtotag = true }
        },
        {
            rule = { class = "Firefox" },
            properties = { tag = screen[1].tags[1], switchtotag = true }
        },
	{
            rule = { class = "Gimp", role = "gimp-image-window-1" },
	    callback = function(c)
	       lain.widget.contrib.redshift:toggle()
	end },    

	{
            rule = { class = "Kodi" },
	    callback = function(c)
	       toggle_wibox()
	end }    

    }
end
-- }}}

-- {{{ Signals
-- signal function to execute when a new client appears.
local sloppyfocus_last = { c = nil }
client.connect_signal("manage", function(c, startup)
    -- Enable sloppy focus
    client.connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
                and awful.client.focus.filter(c) then
            -- Skip focusing the client if the mouse wasn't moved.
            if c ~= sloppyfocus_last.c then
                client.focus = c
                sloppyfocus_last.c = c
            end
        end
    end)

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(awful.button({}, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
            awful.button({}, 3, function()
                client.focus = c
                c:raise()
                awful.mouse.client.resize(c)
            end))

        -- widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- the title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c, { size = 16 }):set_widget(layout)
    end
end)

client.connect_signal("unmanage", function(c)
			 if c.name == "Kodi" then
			    toggle_wibox()
			 elseif c.role == "gimp-image-window-1" then
			    lain.widget.contrib.redshift:toggle()
			 end
end)

-- No border for maximized clients
client.connect_signal("focus",
    function(c)
        if c.maximized_horizontal == true and c.maximized_vertical == true then
            c.border_color = beautiful.border_normal
        else
            c.border_color = beautiful.border_focus
        end
    end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ Arrange signal handler
for s = 1, screen.count() do screen[s]:connect_signal("arrange", function()
    local clients = awful.client.visible(s)
    local layout = awful.layout.getname(awful.layout.get(s))

    if #clients > 0 then -- Fine grained borders and floaters control
        for _, c in pairs(clients) do -- Floaters always have borders
            if awful.client.floating.get(c) or layout == "floating" then
                c.border_width = beautiful.border_width

                -- No borders with only one visible client
            elseif #clients == 1 or layout == "max" then
                c.border_width = 0
            else
                c.border_width = beautiful.border_width
            end
        end
    end
end)
end
-- }}}
