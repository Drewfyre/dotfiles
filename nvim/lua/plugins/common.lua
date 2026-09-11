local M = {
	{ "nvim-tree/nvim-web-devicons", lazy = true },
	{
		"chomosuke/term-edit.nvim",
		opts = { prompt_end = ">", feedkeys_delay = 20000 },
		event = "TermOpen",
	},
	{ "rachartier/tiny-inline-diagnostic.nvim" },
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
	},
}

return M
