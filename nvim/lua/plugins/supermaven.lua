---@type LazySpec[]
return {
    {
        "supermaven-inc/supermaven-nvim",
        event = "InsertEnter",
        opts = {
            keymaps = {
                accept_suggestion = "<C-i>",
                clear_suggestion = "<C-]>",
                accept_word = "<Nop>",
            },
        },
        cmd = {
            "SupermavenStart",
            "SupermavenStop",
            "SupermavenRestart",
            "SupermavenToggle",
            "SupermavenStatus",
            "SupermavenUseFree",
            "SupermavenUsePro",
            "SupermavenLogout",
            "SupermavenShowLog",
            "SupermavenClearLog",
        },
    },
}
