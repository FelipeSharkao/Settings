local active_border = "{accent}"
local inactive_border = "{bg}"

hl.config({
    general = {
        col = {
            active_border = active_border,
            inactive_border = inactive_border,
        },
    },
    group = {
        col = {
            border_active = active_border,
            border_inactive = inactive_border,
        },
    },
})
