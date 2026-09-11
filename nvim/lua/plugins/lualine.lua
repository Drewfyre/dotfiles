return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local lualine = require("lualine")
		lualine.setup({
			options = {
				component_separators = "",
				theme = "gruvbox_dark",
			},
			sections = {
				lualine_a = { "mode" },
				lualine_c = { { "filename", path = 4 } },
				lualine_b = { "branch", "diff" },
				lualine_x = {
					{
						"filetype",
						cond = function()
							return vim.fn.reg_recording() == ""
						end,
					},
					{
						function()
							return "Recording @" .. vim.fn.reg_recording()
						end,
						cond = function()
							return vim.fn.reg_recording() ~= ""
						end,
						padding = 1,
					},
				},
				lualine_y = {
					{
						"diagnostics",
						sources = { "nvim_workspace_diagnostic" },
					},
				},
				lualine_z = {},
			},
			extensions = { "quickfix", "oil" },
		})
	end,
}
