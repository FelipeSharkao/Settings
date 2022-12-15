require("presence"):setup({
  auto_update        = true,
  neovim_image_text  = "Neovim",
  main_image         = "file",
  debounce_timeout   = 10,
  enable_line_number = false,
  -- A list of strings or Lua patterns that disable Rich Presence if the current file name, path, or workspace matches
  blacklist          = {},
  buttons            = true,
  show_time          = true,
})
