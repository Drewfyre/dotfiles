vim.api.nvim_create_autocmd("InsertLeave", {
	callback = function(args)
		local bufnr = args.buf

		-- Only run for buffers that have an LSP client attached
		local clients = vim.lsp.get_clients({
			bufnr = bufnr,
			name = "roslyn",
		})

		if #clients == 0 then
			return
		end

		for _, client in ipairs(clients) do
			client:request("textDocument/diagnostic", {
				textDocument = vim.lsp.util.make_text_document_params(bufnr),
			}, function(err, result)
				if err then
					vim.notify("Roslyn diagnostic refresh failed: " .. err.message, vim.log.levels.WARN)
				end
			end, bufnr)
		end
	end,
})
