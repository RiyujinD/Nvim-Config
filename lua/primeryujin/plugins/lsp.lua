-- LSP + Mason + Fidget + LazyDev
local root_files = {
  ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml",
  "selene.toml", "selene.yml", ".git", "requirements.txt", "manage.py",
}

return {
  "neovim/nvim-lspconfig",
  event = "VeryLazy",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "stevearc/conform.nvim",
    "j-hui/fidget.nvim",
    {
    "folke/lazydev.nvim",
        ft = "lua", -- only load when editing Lua files
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
  },
  opts = {
    root_files = root_files,
    servers = {
      clangd = {}, pyright = {}, sqls = {}, sqlls = {}, ts_ls = {},
      html = {}, emmet_ls = {}, cssls = {}, jsonls = {},
      yamlls = {}, marksman = {}, tailwindcss = {}, eslint = {},
      bashls = {}, dockerls = {}, lemminx = {}, rust_analyzer = {},
      gopls = {}, elixirls = {},
    },
    on_attach = function(_, bufnr)
      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      end
      map("n", "gd", vim.lsp.buf.definition, "Go to definition")
      map("n", "gr", vim.lsp.buf.references, "Go to references")
      map("n", "K", vim.lsp.buf.hover, "Hover docs")
      map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
      map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
    end,
    capabilities = require("cmp_nvim_lsp").default_capabilities(
      vim.lsp.protocol.make_client_capabilities()
    ),
  },
  config = function(_, opts)
    require("fidget").setup({})
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = vim.tbl_keys(opts.servers),
    })

    local lspconfig = require("lspconfig")
    for name, cfg in pairs(opts.servers) do
      cfg = vim.tbl_extend("force", {
        capabilities = opts.capabilities,
        on_attach = opts.on_attach,
        root_dir = lspconfig.util.root_pattern(unpack(opts.root_files)),
      }, cfg)

      -- Disable LSP formatting (Conform will handle it)
      if cfg.capabilities then
        cfg.capabilities.documentFormattingProvider = false
      end

      lspconfig[name].setup(cfg)
    end

    vim.diagnostic.config({
      virtual_text = true,
      signs = true,
      underline = true,
      update_in_insert = false,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = true,
        header = "",
        prefix = "",
      },
    })
  end,
}

