hl.bind("ALT + F4", hl.dsp.window.close())
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + F11", hl.dsp.window.fullscreen())
hl.bind("SUPER + F", hl.dsp.window.float({ action = "toggle" }))

local cmd_cliphist = "vicinae deeplink vicinae://launch/clipboard/history"
local cmd_satty =
    'grim - | satty --filename - --output-filename "$HOME/Pictures/screenshot-$(date -Iseconds).png" --copy-command wl-copy --early-exit --fullscreen'
local cmd_grimblast =
    'grimblast --notify copysave screen "$HOME/Pictures/screenshot-$(date -Iseconds).png"'

hl.bind("SUPER + SUPER_L", hl.dsp.exec_cmd("vicinae toggle"), { release = true })
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("vicinae toggle"))
hl.bind("SUPER + L", hl.dsp.exec_cmd("wlogout -p layer-shell"))
hl.bind("SUPER + T", hl.dsp.exec_cmd("kitty"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("nemo"))
hl.bind("SUPER + B", hl.dsp.exec_cmd("zen-browser"))
hl.bind("SUPER + P", hl.dsp.exec_cmd("nwg-displays"))
hl.bind("SUPER + V", hl.dsp.exec_cmd(cmd_cliphist))
hl.bind("code:107", hl.dsp.exec_cmd(cmd_satty))
hl.bind("CTRL + code:107", hl.dsp.exec_cmd(cmd_grimblast))
hl.bind("code:232", hl.dsp.exec_cmd("brightnessctl -c backlight -n1000 set 10%-"))
hl.bind("code:233", hl.dsp.exec_cmd("brightnessctl -c backlight set 10%+"))

for _, dir in ipairs({ "left", "right", "up", "down" }) do
    hl.bind("SUPER + " .. dir, hl.dsp.focus({ direction = dir }))
    hl.bind("SUPER + SHIFT + " .. dir, hl.dsp.window.swap({ direction = dir }))
end

for i = 1, 10 do
    local key = i % 10
    hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
    hl.bind("SUPER + CTRL + " .. key, function()
        local monitor = hl.get_active_monitor()
        hl.dispatch(hl.dsp.workspace.move({ workspace = i, monitor = monitor }))
        hl.dispatch(hl.dsp.focus({ workspace = i }))
    end)
end

hl.bind("SUPER + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind("SUPER + SHIFT + S", function()
    if hl.get_active_window().workspace.special then
        hl.dispatch(hl.dsp.window.move({ workspace = "e+0" }))
    else
        hl.dispatch(hl.dsp.window.move({ workspace = "special:magic" }))
    end
end)

hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + CTRL + mouse:272", hl.dsp.window.resize(), { mouse = true })
