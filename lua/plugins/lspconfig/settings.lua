---------- LANGUAGE SERVERS ----------

return {

	ts_ls = {
		filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
	},

	angularls = {},

	jsonls = {
		settings = {
			json = {
				schemas = require("schemastore").json.schemas(),
			},
		},
	},

	roslyn = {},
}
