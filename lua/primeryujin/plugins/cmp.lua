-- CMP + Copilot + LuaSnip
return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "github/copilot.vim",
    },
    opts = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        local function small_window()
            return cmp.config.window.bordered({ max_height = 2 })
        end

        local function large_window()
            return cmp.config.window.bordered({ max_height = 15 })
        end

        cmp.setup({
            window = {
                completion = small_window(),
                documentation = cmp.config.window.bordered(),
            },

            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },

            mapping = cmp.mapping.preset.insert({
                ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
                ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
                ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping(function()
                    cmp.complete({
                        config = {
                            window = {
                                completion = large_window(),
                            },
                        },
                    })
                end, { "i", "c" }),
                ["<leader> "] = cmp.mapping(function()
                    cmp.complete({
                        config = {
                            window = {
                                completion = large_window(),
                            },
                        },
                    })
                end, { "i", "c" }),
            }),

            sources = cmp.config.sources({
                { name = "copilot", group_index = 2 },
                { name = "nvim_lsp" },
                { name = "luasnip" },
            },
            {
                { name = "buffer" },
            }),
        })
    end,
}

