return {
	{
		"folke/neoconf.nvim",
		lazy = false,
	},
	{
		"folke/neodev.nvim",
		lazy = false,
		opts = {},
		init = function(_, opts)
			require("neodev").setup(opts)
		end
	},
	{
		"neovim/nvim-lspconfig",
		depedencies = { "folke/neodev.nvim", "folke/neoconf.nvim" },
		keys = {
			{ "K", vim.lsp.buf.hover, desc = "Hover" },
			{ "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help" },
			{ "<leader>gD", vim.lsp.buf.declaration, desc = "Go to Declaration" }
		},
		config = function ()
			require("neoconf").setup()
		end
	},
	{
		"williamboman/mason.nvim",
		lazy = false,
		keys = {
			{ "<leader>M", "<cmd>Mason<cr>", desc = "Open LSP Manager (Mason)" }
		},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		event = "VeryLazy",
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig"
		},
		opts = {
			automatic_installation = true,
		},
		init = function(_, opts)
			require("mason").setup()
			require("mason-lspconfig").setup(opts)
      require("mason-lspconfig").setup_handlers {
        function (server_name)
            require("lspconfig")[server_name].setup {}
        end,
        ["volar"] = function()
          require("lspconfig").volar.setup({
            filetypes = { "vue", "javascript", "typescript", "javascriptreact", "typescriptreact" },
            init_options = {
              vue = {
                hybridMode = false,
              },
              typescript = {
                tsdk = vim.fn.getcwd() .. "/node_modules/typescript/lib",
              },
            },
          })
        end
      }
		end
	},
	{
		"hrsh7th/nvim-cmp",
		lazy = false,
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-path",
			{
					"zbirenbaum/copilot-cmp",
					dependencies = "copilot.lua",
					opts = {},
					config = function(_, opts)
							local copilot_cmp = require("copilot_cmp")
							copilot_cmp.setup(opts)
					end,
			},
		},
		opts = function()
        local cmp = require("cmp")
        local lsp_kinds = {
					Text = " ",
					Method = " ",
					Function = " ",
					Constructor = " ",
					Field = " ",
					Variable = " ",
					Class = " ",
					Interface = " ",
					Module = " ",
					Property = " ",
					Unit = " ",
					Value = " ",
					Enum = " ",
					Keyword = " ",
					Snippet = " ",
					Color = " ",
					File = " ",
					Reference = " ",
					Folder = " ",
					EnumMember = " ",
					Constant = " ",
					Struct = " ",
					Event = " ",
					Operator = " ",
					TypeParameter = " ",
					Copilot = " ",
					Namespace = " ",
					Package = " ",
					String = " ",
					Number = " ",
					Boolean = " ",
					Array = " ",
					Object = " ",
					Key = " ",
					Null = " ",
				}

        local has_words_before = function()
            if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
                return false
            end
            local line, col = vim.F.unpack_len(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end

        local luasnip = require("luasnip")

        return {
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            formatting = {
                format = function(entry, vim_item)
                    if vim.tbl_contains({ "path" }, entry.source.name) then
                        local icon, hl_group = require("nvim-web-devicons").get_icon(entry:get_completion_item().label)
                        if icon then
                            vim_item.kind = icon
                            vim_item.kind_hl_group = hl_group
                            return vim_item
                        end
                    end
                    vim_item.kind = (lsp_kinds[vim_item.kind] or "") .. " " .. vim_item.kind

                    return vim_item
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-p>"] = cmp.mapping.select_prev_item(),
                ["<C-n>"] = cmp.mapping.select_next_item(),
                ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.close(),
                ["<CR>"] = cmp.mapping.confirm({
                    select = false,
                }),
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_locally_jumpable() then
                        luasnip.expand_or_jump()
                    elseif has_words_before() then
                        cmp.complete()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),
            sources = {
                { name = "nvim_lsp" },
                { name = "copilot" },
                { name = "path" },
                { name = "buffer" },
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            experimental = {
                ghost_text = {
                    hl_group = "LspCodeLens",
                },
            },
        }
    end,
    config = function(_, opts)
        local cmp = require("cmp")
        cmp.setup(opts)
        cmp.setup.cmdline({ "/", "?" }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = "buffer" },
            },
        })
        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = "path" },
            }, {
                { name = "cmdline" },
            }),
        })
    end,
	},
  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    opts = {
      toggle_key = "<C-k>",
      hint_enable = false
    },
    config = function(_, opts)
      require("lsp_signature").setup(opts)
    end
  }
}
