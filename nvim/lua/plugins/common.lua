local M = {
	{
		"folke/tokyonight.nvim",
	},
	{ "nvim-tree/nvim-web-devicons", lazy = true },
	{
		"chomosuke/term-edit.nvim",
		opts = { prompt_end = ">", feedkeys_delay = 20000 },
		event = "TermOpen",
	},
}

return M
