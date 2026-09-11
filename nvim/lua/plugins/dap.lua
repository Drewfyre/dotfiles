return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
		},
		event = "VeryLazy",
		config = function()
			local dap = require("dap")
			local mason_path = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/netcoredbg"
			local netcoredbg_adapter = {
				type = "executable",
				command = mason_path,
				args = { "--interpreter=vscode" },
			}

			dap.adapters.netcoredbg = netcoredbg_adapter
			dap.adapters.coreclr = netcoredbg_adapter

			-- Cache the DLL path so build_dll_path() (which may show a picker) is only called once per session.
			local _dll_path_cache = nil
			local function get_dll_path()
				if not _dll_path_cache then
					_dll_path_cache = require("dap-dll-autopicker").build_dll_path()
				end
				return _dll_path_cache
			end

			-- Clear cache before each new launch so a fresh pick is made next time.
			dap.listeners.before.event_initialized["clear_dll_cache"] = function()
				_dll_path_cache = nil
			end

			-- Reads applicationUrl from the project's launchSettings.json so Kestrel
			-- binds to the correct ports when launched via DAP (netcoredbg does not
			-- read launchSettings.json the way `dotnet run` does).
			local function get_aspnetcore_urls(dll_path)
				-- dll_path: .../bin/Debug/net*/Project.dll  →  project root is 4 levels up
				local project_dir = vim.fn.fnamemodify(dll_path, ":h:h:h:h")
				local launch_settings_path = project_dir .. "/Properties/launchSettings.json"

				local f = io.open(launch_settings_path, "r")
				if not f then
					return nil
				end

				local content = f:read("*all")
				f:close()

				local ok, parsed = pcall(vim.fn.json_decode, content)
				if not ok or not parsed.profiles then
					return nil
				end

				for _, profile in pairs(parsed.profiles) do
					if profile.applicationUrl then
						return profile.applicationUrl
					end
				end

				return nil
			end

			dap.configurations.cs = {
				{
					type = "coreclr",
					name = "Launch directly from nvim",
					request = "launch",
					program = function()
						return get_dll_path()
					end,
					cwd = function()
						return vim.fn.fnamemodify(get_dll_path(), ":h")
					end,
					env = function()
						local urls = get_aspnetcore_urls(get_dll_path())
						local env = { ASPNETCORE_ENVIRONMENT = "Development" }
						if urls then
							env.ASPNETCORE_URLS = urls
						end
						return env
					end,
				},
			}

			vim.keymap.set("n", "<F5>", dap.continue, { desc = "DAP: Continue/Start debugging" })
			vim.keymap.set("n", "<F9>", dap.toggle_breakpoint, { desc = "DAP: Toggle breakpoint" })
			vim.keymap.set("n", "<F10>", dap.step_over, { desc = "DAP: Step over" })
			vim.keymap.set("n", "<F11>", dap.step_into, { desc = "DAP: Step into" })
			vim.keymap.set("n", "<F8>", dap.step_out, { desc = "DAP: Step out" })
			vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "DAP: REPL open" })
			vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "DAP: Run last" })
		end,
	},
	{
		"ramboe/ramboe-dotnet-utils",
		dependencies = { "mfussenegger/nvim-dap" },
	},
	{ "nvim-neotest/nvim-nio" },
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
		},
		config = function()
			local dapui = require("dapui")
			local dap = require("dap")

			-- open the ui as soon as we are debugging
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- https://emojipedia.org/en/stickers/search?q=circle
			vim.fn.sign_define("DapBreakpoint", {
				text = "⚪",
				texthl = "DapBreakpointSymbol",
				linehl = "DapBreakpoint",
				numhl = "DapBreakpoint",
			})

			vim.fn.sign_define("DapStopped", {
				text = "🔴",
				texthl = "yellow",

				linehl = "DapBreakpoint",
				numhl = "DapBreakpoint",
			})
			vim.fn.sign_define("DapBreakpointRejected", {
				text = "⭕",
				texthl = "DapStoppedSymbol",
				linehl = "DapBreakpoint",
				numhl = "DapBreakpoint",
			})

			-- more minimal ui

			dapui.setup({
				expand_lines = true,
				controls = { enabled = false }, -- no extra play/step buttons

				floating = { border = "rounded" },

				-- Set dapui window
				render = {
					max_type_length = 60,
					max_value_lines = 200,
				},

				layouts = {
					{
						elements = {
							{ id = "scopes", size = 0.5 },
							{ id = "stacks", size = 0.5 },
						},
						size = 15,
						position = "bottom",
					},
					{
						elements = {
							{ id = "repl", size = 1.0 },
						},
						size = 120, -- width in columns
						position = "right",
					},
				},
			})

			local map = function(mode, l, r, d)
				vim.keymap.set(mode, l, r, { desc = d })
			end

			map("n", "<leader>du", dapui.toggle, "DAP UI toggle")

			map({ "n", "v" }, "<leader>dw", function()
				dapui.eval(nil, { enter = true })
			end, "DAP Add word under cursor to Watches")
			map({ "n", "v" }, "Q", function()
				dapui.eval()
			end, "DAP Peek")

			local neotest = require("neotest")

			map("n", "<leader>dt", function()
				neotest.run.run({ suite = false, strategy = "dap" })
			end, "Debug nearest test")
			map("n", "<F6>", function()
				neotest.run.run({ suite = false, strategy = "dap" })
			end, "Debug nearest test")
		end,
	},
}
