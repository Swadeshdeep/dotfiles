-- Hyprland Lua config converted from hyprland.conf.
-- Hyprland 0.55+ loads ~/.config/hypr/hyprland.lua before hyprland.conf.

local terminal = "ghostty"
local fileManager = "pcmanfm"
local menu = "rofi -show-icons -theme gruvbox-dark-hard -show drun"
local mainMod = "SUPER"

local function bind(keys, dispatcher, flags)
	hl.bind(keys, dispatcher, flags)
end

local function exec_bind(keys, command, flags)
	bind(keys, hl.dsp.exec_cmd(command), flags)
end

local function dispatch_bind(keys, dispatcher, params, flags)
	local command = "hyprctl dispatch " .. dispatcher
	if params ~= nil and params ~= "" then
		command = command .. " " .. params
	end
	exec_bind(keys, command, flags)
end

local function startup(command, rules)
	hl.exec_cmd(command, rules)
end

-- Monitors
hl.monitor({ output = "eDP-1", mode = "1920x1080@144", position = "auto", scale = 1, transform = 0 })
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

-- Environment
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("GDK_SCALE", "1")
hl.env("GDK_DPI_SCALE", "1.25")
hl.env("QT_SCALE_FACTOR", "1.25")
hl.env("QT_FONT_DPI", "100")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("TDESKTOP_DISABLE_GTK_INTEGRATION", "1")
hl.env("TDESKTOP_FORCE_PANEL_ICON", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("ELECTRON_ENABLE_WAYLAND", "1")
hl.env("ELECTRON_SCALE_FACTOR", "1.25")

-- Core config
hl.config({
	general = {
		gaps_in = 0,
		gaps_out = 0,
		border_size = 1,
		col = {
			active_border = "rgba(A0A0A0ff)",
			inactive_border = "rgba(595959aa)",
		},
		resize_on_border = true,
		allow_tearing = false,
		layout = "dwindle",
	},
	decoration = {
		rounding = 0,
		active_opacity = 1.0,
		inactive_opacity = 1.0,
		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = "rgba(1a1a1aee)",
		},
		blur = {
			enabled = true,
			size = 6,
			passes = 1,
			vibrancy = 0.1696,
		},
	},
	animations = {
		enabled = false,
	},
	dwindle = {
		smart_split = false,
		force_split = 2,
	},
	master = {
		new_status = "master",
	},
	misc = {
		background_color = "0x000000",
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		force_default_wallpaper = 0,
		vrr = 0,
		mouse_move_enables_dpms = true,
		key_press_enables_dpms = true,
	},
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "ctrl:nocaps",
		kb_rules = "",
		follow_mouse = 2,
		sensitivity = 0.4,
		force_no_accel = true,
		touchpad = {
			natural_scroll = true,
			tap_to_click = true,
			drag_lock = 1,
			disable_while_typing = true,
			scroll_factor = 0.4,
			tap_and_drag = true,
		},
	},
	xwayland = {
		force_zero_scaling = true,
		use_nearest_neighbor = true,
	},
})

-- Curves and animations
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1.0 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

-- Gestures
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "up", action = "fullscreen" })
hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })

-- Per-device input
hl.device({
	name = "telink-k-chimera-mouse",
	sensitivity = -0.4,
})

-- Autostart
hl.on("hyprland.start", function()
	startup("swaybg -i ~/Downloads/wp12853363-the-great-wave-4k-wallpapers.png")
	startup("swaync")
	startup("waybar")
	startup("nm-applet")
	startup("/usr/lib/polkit-kde-authentication-agent-1")
	startup("pypr")
	startup("hyprpm reload -n")
	startup("xremap --watch ~/.config/xremap/config.yml")
	startup("gammastep -P -O 3500")
	startup("vicinae server")
	startup("snappy-switcher --daemon")
	startup("wl-paste --type text --watch cliphist store")
	startup("wl-paste --type image --watch cliphist store")
	startup("ghostty", { workspace = "1 silent" })
	startup("zen-browser", { workspace = "2 silent" })
	startup("spotify", { workspace = "4 silent" })
end)

-- Basic keybinds
exec_bind(mainMod .. " + RETURN", terminal)
bind(mainMod .. " + SHIFT + C", hl.dsp.window.close({}))
bind(mainMod .. " + SHIFT + M", hl.dsp.exit())
exec_bind(mainMod .. " + E", fileManager)
bind(mainMod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))
exec_bind(mainMod .. " + SHIFT + SPACE", menu)
bind(mainMod .. " + SHIFT + P", hl.dsp.window.pseudo({ action = "toggle" }))
bind(mainMod .. " + ALT + J", hl.dsp.layout("togglesplit"))

bind(mainMod .. " + left", hl.dsp.focus({ direction = "l" }))
bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
bind(mainMod .. " + up", hl.dsp.focus({ direction = "u" }))
bind(mainMod .. " + down", hl.dsp.focus({ direction = "d" }))
bind(mainMod .. " + H", hl.dsp.focus({ direction = "l" }))
bind(mainMod .. " + L", hl.dsp.focus({ direction = "r" }))
bind(mainMod .. " + K", hl.dsp.focus({ direction = "u" }))
bind(mainMod .. " + J", hl.dsp.focus({ direction = "d" }))

bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "l" }))
bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "u" }))
bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "d" }))
bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }))
bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }))

for i = 1, 9 do
	bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
	bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end
bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))
bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Media and hardware keys
exec_bind("XF86AudioRaiseVolume", "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+", { locked = true, repeating = true })
exec_bind("XF86AudioLowerVolume", "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-", { locked = true, repeating = true })
exec_bind("XF86AudioMute", "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle", { locked = true, repeating = true })
exec_bind("XF86AudioMicMute", "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle", { locked = true, repeating = true })
exec_bind("XF86MonBrightnessUp", "brightnessctl s 10%+", { locked = true, repeating = true })
exec_bind("XF86MonBrightnessDown", "brightnessctl s 10%-", { locked = true, repeating = true })
exec_bind("XF86Launch1", "rog-control-center", { locked = true, repeating = true })
exec_bind("XF86KbdBrightnessDown", "asusctl -p", { locked = true, repeating = true })
exec_bind("XF86KbdBrightnessUp", "asusctl -n", { locked = true, repeating = true })
exec_bind("XF86AudioNext", "playerctl next", { locked = true })
exec_bind("XF86AudioPause", "playerctl play-pause", { locked = true })
exec_bind("XF86AudioPlay", "playerctl play-pause", { locked = true })
exec_bind("XF86AudioPrev", "playerctl previous", { locked = true })
exec_bind("XF86Launch4", 'bash -c "~/.config/hypr/scripts/asus_profile.sh"', { locked = true })
exec_bind("XF86Launch3", "~/.config/hypr/scripts/battery-limit.sh")
exec_bind("ALT + F11", 'bash -c "~/.config/hypr/scripts/keyboard.sh"', { locked = true })

-- Extra keybinds
exec_bind(mainMod .. " + Z", "~/.config/hypr/scripts/waybar-toggle.sh")
exec_bind(mainMod .. " + B", "~/.config/hypr/scripts/waybar-toggle.sh")
exec_bind(mainMod .. " + SHIFT + S", "~/.config/hypr/scripts/toggle_style.sh")
exec_bind(mainMod .. " + R", "rofi -theme gruvbox-dark-hard -show run")
exec_bind(mainMod .. " + W", "rofi -theme gruvbox-dark-hard -show window")
bind(mainMod .. " + T", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
bind(mainMod .. " + S", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
bind(mainMod .. " + G", hl.dsp.group.toggle({}))
dispatch_bind(mainMod .. " + SHIFT + G", "moveintogroup")
bind(mainMod .. " + CTRL + G", hl.dsp.window.move({ out_of_group = true }))
bind(mainMod .. " + Tab", function()
	local workspace = hl.get_active_special_workspace() or hl.get_active_workspace()
	if workspace and workspace.tiled_layout == "monocle" then
		hl.dispatch(hl.dsp.layout("cyclenext"))
		return
	end

	hl.dispatch(hl.dsp.window.cycle_next())
	hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top" }))
end)
exec_bind(mainMod .. " + V", "cliphist list | rofi -theme gruvbox-dark-hard -dmenu | cliphist decode | wl-copy")
exec_bind(mainMod .. " + F", "hyprctl dispatch resizeactive exact 100% 100% && hyprctl dispatch moveactive exact 0 0")
bind(mainMod .. " + P", function()
	local workspace = hl.get_active_special_workspace() or hl.get_active_workspace()
	if not workspace then
		return
	end

	local name = workspace.special and tostring(workspace.name) or tostring(workspace.id)
	local layout = workspace.tiled_layout == "monocle" and "dwindle" or "monocle"
	hl.workspace_rule({ workspace = name, layout = layout })
end)
exec_bind(mainMod .. " + F12", "hyprpicker -a -f hex")
exec_bind("Print", "~/.config/hypr/scripts/screenshot.sh full")
exec_bind(mainMod .. " + Print", "~/.config/hypr/scripts/screenshot.sh region-o")
exec_bind(mainMod .. " + SHIFT + Print", "~/.config/hypr/scripts/screenshot.sh region")
exec_bind(mainMod .. " + N", "swaync-client -t")
exec_bind(mainMod .. " + SHIFT + RETURN", "pypr toggle term")
exec_bind(mainMod .. " + Space", "vicinae toggle")

bind(mainMod .. " + CTRL + left", hl.dsp.window.resize({ x = -20, y = 0, relative = true }))
bind(mainMod .. " + CTRL + right", hl.dsp.window.resize({ x = 20, y = 0, relative = true }))
bind(mainMod .. " + CTRL + up", hl.dsp.window.resize({ x = 0, y = -20, relative = true }))
bind(mainMod .. " + CTRL + down", hl.dsp.window.resize({ x = 0, y = 20, relative = true }))
bind(mainMod .. " + CTRL + H", hl.dsp.window.resize({ x = -20, y = 0, relative = true }))
bind(mainMod .. " + CTRL + L", hl.dsp.window.resize({ x = 20, y = 0, relative = true }))
bind(mainMod .. " + CTRL + K", hl.dsp.window.resize({ x = 0, y = -20, relative = true }))
bind(mainMod .. " + CTRL + J", hl.dsp.window.resize({ x = 0, y = 20, relative = true }))

-- Window rules
hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })
hl.window_rule({
	match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
	no_focus = true,
})
hl.window_rule({ match = { class = "^(pavucontrol)$" }, float = true })
hl.window_rule({ match = { class = "^(nm-connection-editor)$" }, float = true })
hl.window_rule({ match = { class = "^(org.kde.polkit-kde-authentication-agent-1)$" }, float = true })
hl.window_rule({ match = { title = "^(Picture-in-Picture)$" }, float = true })
hl.window_rule({ match = { class = "^(firefox)$", title = "^(Picture-in-Picture)$" }, float = true })
