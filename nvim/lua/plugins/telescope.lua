-- plugins/telescope.lua:
return {
	"nvim-telescope/telescope.nvim",
	--tag = "0.1.8",
	config = function()
		require("telescope").setup({
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown({}),
				},
			},
		})

		require("telescope").load_extension("ui-select")
	end,
	dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-ui-select.nvim" },
	keys = {
		{ "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "Grep (Root Dir)" },
		{ "<leader><space>", "<cmd>Telescope find_files<cr>", desc = "Find Files (Root Dir)" },
		{
			"<leader>fb",

			"<cmd>Telescope buffers sort_mru=true sort_lastused=true ignore_current_buffer=true<cr>",
			desc = "Buffers",
		},
		{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files (Root Dir)" },
		{
			"<leader>fF",
			"<cmd>Telescope find_files<cr>",
			{ root = false },
			desc = "Find Files (cwd)",
		},
		{ "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Lsp document symbols" },
		{ "gr", "<cmd>Telescope lsp_references<cr>", desc = "Lsp references" },
		{ "gd", "<cmd>Telescope lsp_definitions<cr>", desc = "Lsp definitions" },
		{ "gi", "<cmd>Telescope lsp_implementations<cr>", desc = "Lsp implementations" },
		{ "gt", "<cmd>Telescope lsp_type_definitions<cr>", desc = "Lsp type definitions" },
		{
			"gt",
			"<cmd>Telescope diagnostics<cr>",
			{ bufnr = 0 },
			desc = "Lsp diagnostics",
		},
	},
}
