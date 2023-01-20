local leap = require("leap")
local flit = require("flit")

leap.add_default_mappings()
leap.opts.safe_labels = {}

vim.api.nvim_set_hl(0, "LeapHighlightChar1", { fg = "green", underline = true })

flit.setup({ multiline = false })
