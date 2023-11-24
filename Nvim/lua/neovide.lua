local keymap = vim.keymap.set

if vim.g.neovide then
    vim.opt.guifont = "FiraCode Nerd Font Mono:h10.5"

    vim.g.neovide_scale_factor = 1.0
    vim.g.neovide_transparency = 0.9
    vim.g.neovide_scroll_animation_length = 0.2
    vim.g.neovide_input_use_logo = false
    vim.g.neovide_input_macos_alt_is_meta = true

    vim.api.nvim_create_autocmd("BufEnter", {
        callback = function()
            -- Copy
            keymap("v", "<C-C>", "y", { noremap = true })
            keymap("v", "<C-S-C>", '"+y', { noremap = true })

            -- Paste
            keymap("i", "<C-V>", "<C-O>gP", { noremap = true })
            keymap("i", "<C-S-V>", '<C-O>"+gP', { noremap = true })

            keymap("t", "<C-V>", "<C-\\><C-O>gP", { noremap = true })
            keymap("t", "<C-S-V>", '<C-\\><C-O>"+gP', { noremap = true })

            keymap("c", "<C-V>", '<C-R>"', { noremap = true })
            keymap("c", "<C-S-V>", "<C-R>+", { noremap = true })

            -- Change font scale
            local change_scale_factor = function(scale)
                local new_scale_factor = vim.g.neovide_scale_factor * scale

                if new_scale_factor < 0.4 then
                    return
                end

                vim.g.neovide_scale_factor = new_scale_factor
            end

            vim.keymap.set("n", "<C-=>", function()
                change_scale_factor(1.25)
            end)

            vim.keymap.set("n", "<C-->", function()
                change_scale_factor(0.8)
            end)
        end,
    })
end
