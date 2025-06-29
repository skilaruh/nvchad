local options = {
    formatters_by_ft = {
        c = { "clang-format" },
        cpp = { "clang-format" },
        cuda = { "clang-format" },
        go = { "gofumpt", "goimports-reviser", "golines" },
        lua = { "stylua" },
        python = { "ruff_format" },
        -- css = { "prettier" },
        -- html = { "prettier" },
    },

    formatters = {
        -- C & C++
        ["clang-format"] = {
            prepend_args = {
                "-style={"
                    .. "BasedOnStyle: LLVM, "
                    .. "IndentWidth: 4, "
                    .. "TabWidth: 4, "
                    .. "UseTab: Never, "
                    .. "InsertNewlineAtEOF: true, "
                    .. "AllowShortFunctionsOnASingleLine: false, "
                    .. "KeepEmptyLines: {"
                    .. "AtEndOfFile: true, "
                    .. "AtStartOfBlock: false, "
                    .. "AtStartOfFile: false"
                    .. "}"
                    .. "}",
            },
        },
        -- Go
        ["golines"] = {
            prepend_args = { "--max-len=80" },
        },
    },

    format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_fallback = true,
    },
}

return options
