CUSTOM_BORDER = vim.env.TERM == "xterm-ghostty" and { " ", "▄", " ", "▌", " ", "▀", " ", "▐" }
	or { " ", " ", " ", " ", " ", " ", " ", " " }

local pmenu_hl = vim.api.nvim_get_hl(0, { name = "Pmenu" }).bg
vim.api.nvim_set_hl(0, "StatusLine", { bg = pmenu_hl })

local windows = vim.uv.os_uname().sysname == "Windows_NT" and vim.env.TERM ~= "xterm-kitty"
if windows then
	CUSTOM_BORDER = "rounded"
	local hl = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
	vim.api.nvim_set_hl(0, "FloatBorder", { bg = hl })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = hl })
else
	vim.api.nvim_set_hl(0, "FloatBorder", { fg = pmenu_hl })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = pmenu_hl })
end
