return {
	"RostislavArts/naysayer.nvim",
	priority = 1000,
	lazy = false,
	config = function()
		-- load the colorscheme here
		vim.cmd([[colorscheme naysayer]])
		vim.cmd("highlight Normal guibg=NONE ctermbg=NONE")
		vim.cmd("highlight NormalNC guibg=NONE ctermbg=NONE")
	end,
}
