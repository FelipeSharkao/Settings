local function get_config_file(fnames)
	local closet_file = nil

	for _, fname in ipairs(fnames) do
		local path = vim.fn.findfile(fname, ".;")
		if #path > 0 then
			path = vim.fn.fnamemodify(path, ":p")
			if closet_file == nil or #path < #closet_file then
				closet_file = path
			end
		end
	end

	return closet_file
end

local function create_buffer_config(args)
	vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
		callback = function()
			local config_file = get_config_file(args.config_files or {})
			vim.b["neoformat_" .. args.lang .. "_" .. args.name] = (
				config_file and args.callback(vim.fn.fnameescape(config_file)) or args.callback(nil)
			)
		end,
	})
end

create_buffer_config({
	lang = "rust",
	name = "rustfmt",
	config_files = { ".rustfmt.toml", "rustfmt.toml" },
	callback = function(cfg)
		local args = (cfg and { "+nightly", "--config-path " .. cfg } or { "+nightly" })
		return {
			exe = "rustfmt",
			args = args,
			replace = true,
		}
	end,
})

create_buffer_config({
	lang = "toml",
	name = "prettier",
	config_files = { ".prettierrc" },
	callback = function(cfg)
		local args = (cfg and { "--config " .. cfg })
		return {
			exe = "prettier",
			args = args,
			replace = true,
		}
	end,
})

vim.g.neoformat_toml_prettier = {
	exe = "prettier",
}

vim.g.neoformat_try_node_exe = true
vim.g.neoformat_enabled_javascript = { "prettier" }
vim.g.neoformat_enabled_typescript = { "prettier" }
vim.g.neoformat_enabled_graphql = { "prettier" }
vim.g.neoformat_enabled_prisma = { "prettier" }
vim.g.neoformat_enabled_toml = { "prettier" }
vim.g.neoformat_enabled_lua = { "stylua" }
vim.g.neoformat_enabled_rust = { "rustfmt" }

vim.api.nvim_command([[autocmd BufWritePre * silent Neoformat]])
