local keymap = vim.keymap.set

if vim.g.neovide then
    vim.opt.guifont = "FiraCode Nerd Font Mono:h10.5"

    vim.g.neovide_scroll_animation_length = 0.2
    vim.g.neovide_input_use_logo = false
    vim.g.neovide_input_macos_alt_is_meta = true

    vim.api.nvim_create_autocmd("BufEnter", {
        callback = function()
            -- Paste
            keymap("i", "<C-V>", "<Esc>gpi", { noremap = true })
            keymap("i", "<C-S-V>", '<Esc>"+gpi', { noremap = true })

            keymap("t", "<C-V>", "<C-\\><C-N>gpi", { noremap = true })
            keymap("t", "<C-S-V>", '<C-\\><C-N>"+gpi', { noremap = true })

            keymap("c", "<C-V>", '<C-R>"', { noremap = true })
            keymap("c", "<C-S-V>", "<C-R>+", { noremap = true })
        end,
    })
end
