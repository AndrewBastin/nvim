return {
	-- Color Scheme
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		init = function()
			vim.cmd([[colorscheme catppuccin-mocha]])
		end
	},

	{
		"everblush/everblush.nvim",
		lazy = false,
	},

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
		config = function(_, opts)
			vim.o.timeout = true
			vim.o.timeoutlen = 300

			require("which-key").setup(opts)
		end
	},

	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = function()
			return require("config.plugins.lualine")
		end,
		setup = function(_, opts)
			require("lualine").setup(opts)
		end
	},
	{
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
		keys = {
			{ "<leader>e", "<cmd>Neotree filesystem toggle<cr>", desc = "Toggle File Tree" }
		},
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    }
	},
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = { "FzfLua" },
		keys = {
			{ "<leader><leader>", "<cmd>FzfLua git_files<cr>", desc = "Fuzzy Find (Git Files)" },
			{ "<leader>f", "<cmd>FzfLua files<cr>", desc = "Fuzzy Find (All Files)" },
			{ "<leader>d", "<cmd>FzfLua diagnostics_document<cr>", desc = "Fuzzy Find (Document Diagnostics)" },
			{ "<leader>s", "<cmd>FzfLua lsp_document_symbols<cr>", desc = "Fuzzy Find (Document Symbols)" },
			{ "<leader>S", "<cmd>FzfLua lsp_workspace_symbols<cr>", desc = "Fuzzy Find (Workspace Symbols)" },
			{ "<leader>bb", "<cmd>FzfLua buffers<cr>", desc = "Fuzzy Find (Buffers)" },
			{ "<leader>ca", "<cmd>FzfLua lsp_code_actions<cr>", desc = "Fuzzy Find (Code Actions)" },
			{ "<leader>cf", "<cmd>FzfLua filetypes<cr>", desc = "Change filetype" },
			{ "<leader>gl", "<cmd>FzfLua lines<cr>", desc = "Fuzzy Find (Lines)" },
			{ "<leader>gr", "<cmd>FzfLua lsp_references<cr>", desc = "Fuzzy Find (References)" },
			{ "<leader>gd", "<cmd>FzfLua lsp_definitions<cr>", desc = "Fuzzy Find (Definitions)" },
      { "<leader>gp", "<cmd>FzfLua live_grep<cr>", desc = "Fuzzy Find (Live Project Grep)" },
			{ "<leader>Gb", "<cmd>FzfLua git_branches<cr>", desc = "Fuzzy Find (Git Branches)" },
			{ "<leader>Gc", "<cmd>FzfLua git_commits<cr>", desc = "Fuzzy Find (Git Commits)" },
      { "<leader>Gg", "<cmd>FzfLua git_status<cr>", desc = "Git Status" },
		},
		opts = {},
		config = function(_, opts)
			require("fzf-lua").setup(opts)
		end
	},
	{
		"nvimdev/dashboard-nvim",
		event = "VimEnter",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("dashboard").setup({
				theme = "hyper",
				config = {
					header = {
						[[  /$$$$$$                  /$$                                           /$$    /$$ /$$              ]],
						[[ /$$__  $$                | $$                                          | $$   | $$|__/              ]],
						[[| $$  \ $$ /$$$$$$$   /$$$$$$$  /$$$$$$   /$$$$$$  /$$  /$$  /$$        | $$   | $$ /$$ /$$$$$$/$$$$ ]],
						[[| $$$$$$$$| $$__  $$ /$$__  $$ /$$__  $$ /$$__  $$| $$ | $$ | $$ /$$$$$$|  $$ / $$/| $$| $$_  $$_  $$]],
						[[| $$__  $$| $$  \ $$| $$  | $$| $$  \__/| $$$$$$$$| $$ | $$ | $$|______/ \  $$ $$/ | $$| $$ \ $$ \ $$]],
						[[| $$  | $$| $$  | $$| $$  | $$| $$      | $$_____/| $$ | $$ | $$          \  $$$/  | $$| $$ | $$ | $$]],
						[[| $$  | $$| $$  | $$|  $$$$$$$| $$      |  $$$$$$$|  $$$$$/$$$$/           \  $/   | $$| $$ | $$ | $$]],
						[[|__/  |__/|__/  |__/ \_______/|__/       \_______/ \_____/\___/             \_/    |__/|__/ |__/ |__/]]
					},
					shortcut = {
						{ desc = "_" }
					},
					footer = {},
					project = {
						action = function (path)
							vim.cmd("cd " .. path)
							vim.cmd([[FzfLua files]])
						end
					}
				}
			})
		end
	},
	{
		"numToStr/FTerm.nvim",
		keys = {
			{ "<leader>tt", "<cmd>lua require('FTerm').toggle()<cr>", desc = "Toggle Floating Terminal" }
		}
	},
	{
		"echasnovski/mini.nvim",
		event = "VeryLazy",
		config = function()
			require("mini.hipatterns").setup({
        highlighters = {
          -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
          fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
          hack  = { pattern = '%f[%w]()HACK()%f[%W]',  group = 'MiniHipatternsHack'  },
          todo  = { pattern = '%f[%w]()TODO()%f[%W]',  group = 'MiniHipatternsTodo'  },
          note  = { pattern = '%f[%w]()NOTE()%f[%W]',  group = 'MiniHipatternsNote'  },

          -- Highlight hex color strings (`#rrggbb`) using that color
          hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
        },
      })
			require("mini.indentscope").setup()
			require("mini.cursorword").setup()
			require("mini.animate").setup({
					cursor = {
						enable = false
					}
			})
			require("mini.comment").setup({
				mappings = {
					comment = "<leader>c",
					comment_line = "<leader>cc",
					comment_visual = "<leader>c",
					textobject = "<leader>c"
				}
			})
		end
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
		config = function()
			require("gitsigns").setup()
		end
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = function()
			require("nvim-treesitter.install").update({ with_sync = true })()
		end,
		config = function ()
			require("nvim-treesitter.configs").setup({
				auto_install = true,

				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},

				indent = {
					enable = true,
				},

				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "gnn",
						node_incremental = "grn",
						scope_incremental = "grc",
						node_decremental = "grm",
					},
				},
			})
		end
	},
  {
    dir = "~/.config/nvim/lua/custom_plugins/proj",
    name = "proj",
    dev = true,
    lazy = false,
		dependencies = { "ibhagwan/fzf-lua" },
		keys = {
			{
        "<leader>pp",
        function ()
          require("custom_plugins.proj.plugin.proj").prompt_open()
        end,
        desc = "Fuzzy Find (Projects)"
      },
			{
        "<leader>pa",
        function ()
          require("custom_plugins.proj.plugin.proj").prompt_add()
        end,
        desc = "Add Current Folder as Project"
      }
		},
    config = function ()
      require("custom_plugins.proj.plugin.proj").setup()
    end
  },
  {
    "yorickpeterse/nvim-pqf",
    lazy = false,
    config = function ()
      require("pqf").setup({
        signs = {
          error = "E",
          warning = "W",
          info = "I",
          hint = "H"
        },
        show_multiple_lines = false,
        max_filename_length = 0
      })
    end
  }
}
