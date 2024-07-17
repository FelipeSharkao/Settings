local keymap = vim.keymap.set

if vim.fn.has("gui_running") == 1 then
    vim.opt.guifont = "FiraCode Nerd Font Mono:h10.5"

    -- Paste
    keymap({ "i", "c" }, "<C-S-V>", "<C-R><C-O>+", { noremap = true })
    keymap("t", "<C-S-V>", '<C-\\><C-O>"+gp', { noremap = true })
end

if vim.g.neovide then
    vim.g.neovide_scale_factor = 1.0
    vim.g.neovide_transparency = 0.9
    vim.g.neovide_scroll_animation_length = 0.2
    vim.g.neovide_input_use_logo = false
    vim.g.neovide_input_macos_alt_is_meta = true

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
end
