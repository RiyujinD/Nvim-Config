-- Formatter
return {
    "stevearc/conform.nvim",
    event = "VeryLazy",
    opts = {
        formatters_by_ft = {
            c    = { "clang-format" },
            cpp  = { "clang-format" },
            lua  = { "stylua" },
            rust = { "rustfmt" },
            javascript        = { "prettierd", "prettier" },
            typescript        = { "prettierd", "prettier" },
            javascriptreact   = { "prettierd", "prettier" },
            typescriptreact   = { "prettierd", "prettier" },
            python = { "black" },
            sql = { "sqlfluff" },
            elixir = { "mix" },
            htmldjango = { "djlint" },
            jinja      = { "djlint" },
            html       = { "prettierd", "prettier" },
            css        = { "prettierd", "prettier" },
            json       = { "prettierd", "prettier" },
            yaml       = { "prettierd", "prettier" },
            markdown   = { "prettierd", "prettier" },
            sh         = { "shfmt" },
            dockerfile = { "prettier" },
            xml        = { "prettier" },
        },
        formatters = { ["clang-format"] = { prepend_args = { "-style=file", "-fallback-style=LLVM" } } },
    },
    keys = {
        { "<leader>f", function() require("conform").format({ bufnr = 0 }) end, desc = "Format current buffer" },
    },
}

