hl.env("WLR_DRM_NO_ATOMIC", "1")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_QPA_PLATFORMTHEME", "gtk2")
hl.env("XCURSOR_SIZE", "18")

hl.exec_cmd("hyprctl setcursor Qogir 18")

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 1,
        col = {
            active_border = {
                colors = { "rgba(33ccffee)", "rgba(00ff99ee)" },
                angle = 45,
            },
            inactive_border = "rgba(595959aa)",
        },
        layout = "dwindle",
        allow_tearing = true,
    },
    decoration = {
        rounding = 6,
        blur = {
            enabled = false,
        },
        dim_inactive = true,
        dim_strength = 0.3,
    },
    animations = {
        enabled = true,
    },
    input = {
        kb_layout = "br",
        kb_variant = "abnt2",
        kb_options = "caps:swapescape",
        follow_mouse = 1,
        touchpad = {
            natural_scroll = true,
            scroll_factor = 0.5,
            clickfinger_behavior = true,
            drag_lock = true,
        },
        sensitivity = 0,
    },
    misc = {
        disable_hyprland_logo = true,
    },
    dwindle = {
        preserve_split = true,
    },
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

hl.window_rule({
    name = "popup",
    match = { tag = "popup" },
    float = true,
    dim_around = true,
    stay_focused = true,
})

hl.window_rule({
    name = "overlay",
    match = { tag = "overlay" },
    float = true,
    pin = true,
    size = "monitor_w monitor_h",
    move = "0 0",
})

hl.window_rule({
    name = "xwaylandvideobridge",
    match = { class = "xwaylandvideobridge" },
    opacity = "0.0 override 0.0 override",
    no_anim = true,
    no_initial_focus = true,
    max_size = "1 1",
    no_blur = true,
})

hl.window_rule({
    name = "satty",
    match = { class = "com\\.gabm\\.satty" },
    tag = "+overlay",
})

hl.window_rule({
    name = "kdeconnect",
    match = { class = "org\\.kde\\.kdeconnect\\.daemon" },
    tag = "+overlay",
    no_initial_focus = true,
    no_focus = true,
})

hl.window_rule({
    name = "no_border_on_floating",
    match = { float = true },
    border_size = 0,
})

hl.window_rule({
    name = "nwg-displays-float",
    match = { class = "nwg-displays" },
    float = true,
})

hl.window_rule({
    name = "nwg-panel-config-float",
    match = { class = "nwg-panel-config" },
    float = true,
})

hl.window_rule({
    name = "nwg-panel-config-float",
    match = { class = "nwg-panel-config" },
    float = true,
})

hl.window_rule({
    name = "microsip-float",
    match = { class = "microsip.exe" },
    float = true,
})

require("startup")
require("monitors")
require("workspaces")
require("keymaps")
