return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nsidorenco/neotest-vstest",
		"https://github.com/nvim-neotest/nvim-nio",
	},
	config = function()
		local neotest = require("neotest")

		vim.g.neotest_vstest = {
			solution_selector = function(solutions)
				for _, sln in ipairs(solutions) do
					if string.match(sln, "RAS.slnx") then
						return sln
					end
				end

				return solutions[1]
			end,
		}

		neotest.setup({
			adapters = {
				require("neotest-vstest")(),
			},

			icons = {
				running = "🔥", -- Change this to something larger
				passed = "✅", -- Passed test
				failed = "❌", -- Failed test
				skipped = "⚠️", -- Skipped test
				unknown = "❓", -- Unknown state
			},
		})

		local map = vim.keymap

		map.set("n", "<leader>tt", function()
			neotest.run.run()
		end, { desc = "Run nearest test" })
		map.set("n", "<leader>tf", function()
			neotest.run.run(vim.fn.expand("%"))
		end, { desc = "Run all tests in file" })
		map.set("n", "<leader>ts", function()
			neotest.run.run(vim.fn.getcwd())
		end, { desc = "Run all tests in project" })
		map.set("n", "<leader>to", function()
			neotest.output.open({ enter = true })
		end, { desc = "Open test output" })
		map.set("n", "<leader>tr", function()
			neotest.run.run_last()
		end, { desc = "Run last test" })
		map.set("n", "<leader>td", function()
			neotest.run.run({ strategy = "dap" })
		end, { desc = "Debug nearest test" })
		map.set("n", "<leader>ts", function()
			neotest.summary.toggle()
		end, { desc = "Toggle the summary pane on the side" })
	end,
}
