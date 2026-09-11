return {
	"saghen/blink.cmp",
	version = "v1.*",
	event = "InsertEnter",
	build = "cargo +nightly build --release",
	dependencies = {
		{
			"xzbdmw/colorful-menu.nvim",
			opts = {
				ls = {
					gopls = { align_type_to_right = false },
					clangd = { align_type_to_right = false },
					roslyn = { align_type_to_right = false },
					["rust-analyzer"] = { align_type_to_right = false },
					fallback = false,
				},
				max_width = 90,
			},
		},
	},
	opts = function()
		return {
			keymap = {
				preset = "default",
				["<CR>"] = { "accept", "fallback" },
				["<C-d>"] = { "scroll_documentation_down", "fallback" },
				["<C-u>"] = { "scroll_documentation_up", "fallback" },
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
			completion = {
				list = { selection = { preselect = false, auto_insert = true } },
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 50,
					window = { border = CUSTOM_BORDER },
				},
				menu = {
					draw = {
						components = {
							kind_icon = {
								ellipsis = false,
								text = function(ctx)
									local lspkind = require("lspkind")
									local icon = ctx.kind_icon
									if vim.tbl_contains({ "Path" }, ctx.source_name) then
										local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
										if dev_icon then
											icon = dev_icon
										end
									else
										icon = lspkind.symbolic(ctx.kind, {
											mode = "symbol",
										})
									end

									return icon .. ctx.icon_gap
								end,

								-- Optionally, use the highlight groups from nvim-web-devicons
								-- You can also add the same function for `kind.highlight` if you want to
								-- keep the highlight groups in sync with the icons.
								highlight = function(ctx)
									local hl = ctx.kind_hl
									if vim.tbl_contains({ "Path" }, ctx.source_name) then
										local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
										if dev_icon then
											hl = dev_hl
										end
									end
									return hl
								end,
							},
						},
					},
				},
			},

			cmdline = { enabled = false },
			sources = { default = { "lsp", "path", "buffer" } },
		}
	end,
}
