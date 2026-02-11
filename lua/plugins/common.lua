local M = {
    {
        "folke/tokyonight.nvim",
    },
    { "nvim-tree/nvim-web-devicons", lazy = true },
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({
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
            })
        end,
    },

    {
        "chomosuke/term-edit.nvim",
        opts = { prompt_end = '>', feedkeys_delay = 20000 },
        event = "TermOpen"
    },
}

return M
