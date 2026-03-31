return {}
--[[
local M = {
	"seblyng/nvim-formatter",
	init = function()
		vim.opt.formatexpr = "v:lua.require('formatter').formatexpr()"
	end,
	opts = {
		format_on_save = function()
			return not vim.b.disable_formatting
		end,
		treesitter = {
			auto_indent = {
				graphql = function()
					return vim.bo.ft ~= "markdown"
				end,
			},
			disable_injected = {
				rust = { "json" },
				yaml = { "sh", "zsh" },
				dockerfile = { "sh", "zsh" },
			},
		},
		filetype = {
			lua = "stylua --search-parent-directories -",
			sql = "sql-formatter -l mssqlserver",
			json = "jq",
			cs = "dotnet-csharpier",
			javascript = "prettierd .js",
			typescript = "prettierd .ts",
			css = "prettierd .css",
			scss = "prettierd .scss",
			html = "prettierd .html",
			yaml = "prettierd .yaml",
			markdown = "prettierd .md",
		},
	},
}

return M
--]]
