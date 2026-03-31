local function keymap(mode, l, r, opts)
	opts = opts or {}
	opts.buffer = true
	opts.desc = string.format("Lsp: %s", opts.desc)
	vim.keymap.set(mode, l, r, opts)
end
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("DefaultLspAttach", { clear = true }),

	callback = function()
		keymap("i", "<C-s>", function()
			vim.lsp.buf.signature_help({ border = CUSTOM_BORDER })
		end, { desc = "Hover" })

		keymap("n", "gh", function()
			vim.lsp.buf.hover({ border = CUSTOM_BORDER })
		end, { desc = "Hover" })

		keymap("n", "<leader>th", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
		end, { desc = "Toggle inlay hints" })

		keymap("n", "<leader>ca", function()
			vim.lsp.buf.code_action()
		end, { desc = "Code action" })

		keymap("v", "<leader>ca", function()
			vim.lsp.buf.code_action()
		end, { desc = "Code action" })

		keymap("n", "<leader>r", function()
			vim.lsp.buf.rename()
		end, { desc = "Rename" })
	end,
})
vim.diagnostic.config({
	virtual_text = { spacing = 4, prefix = "●" },
	---@diagnostic disable-next-line: assign-type-mismatch
	float = { border = CUSTOM_BORDER, source = "if_many" },
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "✘",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.HINT] = " ",
		},
		numhl = {
			[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
			[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
			[vim.diagnostic.severity.INFO] = "DiagnosticSignHint",
		},
	},
})

return {
	"neovim/nvim-lspconfig",
	config = function()
		local blink_ok, blink_cmp = pcall(require, "blink.cmp")
		local capabilities = vim.tbl_deep_extend(
			"force",
			vim.lsp.protocol.make_client_capabilities(),
			blink_ok and blink_cmp.get_lsp_capabilities() or {}
		)

		require("mason").setup()

		local installed_servers = require("mason-lspconfig").get_installed_servers()

		for _, server in ipairs(installed_servers) do
			if server ~= "roslyn" then
				local server_config = vim.tbl_deep_extend("force", {
					capabilities = capabilities,
				}, require("plugins.lspconfig.settings")[server] or {})

				vim.lsp.config(server, server_config)
				vim.lsp.enable(server)
			end
		end

		require("roslyn").setup({
			capabilities = capabilities,
			choose_target = function(target)
				return vim.iter(target):find(function(item)
					if string.match(item, "RAS.slnx") then
						return item
					end
				end)
			end,
			lock_target = true,
			on_attach = function(client, bufnr)
				-- Force workspace initialization so you don't need to press "gh"
				vim.defer_fn(function()
					if client.initialized then
						vim.lsp.buf.document_symbol()
					end
				end, 200)
			end,
		})
	end,
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {

		{
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {
				library = {
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },

					{ path = "${3rd}/busted/library" },
					{ path = "${3rd}/luassert/library" },
					{ path = "snacks.nvim", words = { "Snacks" } },
					{ path = "nvim-test" },
				},
			},
		},
		{ "saghen/blink.cmp" },
		{ "b0o/schemastore.nvim" },
		{
			"mason-org/mason.nvim",
			dependencies = {
				"seblyng/roslyn.nvim",
				"mason-org/mason-lspconfig.nvim",
			},
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
		{ "onsails/lspkind.nvim" },
	},
}
