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
        "quarto-dev/quarto-nvim",
        ft = { "quarto" },
        dev = false,
        dependencies = {
            "jmbuhr/otter.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        opts = require("configs.quarto"),
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
