local M = {
	{
		"folke/tokyonight.nvim",
	},
	{ "nvim-tree/nvim-web-devicons", lazy = true },
	{
		"mason-org/mason.nvim",
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
			registries = {
				"github:mason-org/mason-registry",
				"github:Crashdummyy/mason-registry",
			},
		},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {},
		dependencies = {
			{ "mason-org/mason.nvim" },
			"neovim/nvim-lspconfig",
		},
	},

	{
		"chomosuke/term-edit.nvim",
		opts = { prompt_end = ">", feedkeys_delay = 20000 },
		event = "TermOpen",
	},
}

return M
