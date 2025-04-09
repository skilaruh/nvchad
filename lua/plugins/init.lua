return {
    {
        "stevearc/conform.nvim",
        event = "BufWritePre", -- uncomment for format on save
        opts = require("configs.conform"),
    },

    {
        "neovim/nvim-lspconfig",
        config = function()
            require("configs.lspconfig")
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        opts = require("configs.treesitter"),
    },

    {
        "folke/which-key.nvim",
        lazy = false,
    },

    {
        "CRAG666/code_runner.nvim",
        opts = require("configs.code-runner"),
        lazy = false,
    },
}
