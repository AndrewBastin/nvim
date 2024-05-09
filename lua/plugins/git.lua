return {
  {
    "sindrets/diffview.nvim",
    lazy = false,
    keys = {
      {
        "<leader>Gdd",
        "<cmd>DiffviewOpen<cr>",
        desc = "Open Diffview"
      },
      {
        "<leader>Gdc",
        "<cmd>DiffviewClose<cr>",
        desc = "Close Diffview"
      }
    },
    init = function ()
      require("diffview").setup()
    end
  },
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"ibhagwan/fzf-lua",
		},
		keys = {
			{
				"<leader>Gg",
				function ()
					require("neogit").open()
				end,
				desc = "Open Neogit"
			}
		},
		config = function ()
			require("neogit").setup({
        integrations = {
          telescope = false,
          diffview = false,
          fzf_lua = false,
        }
      })
		end
	},
	{
		"pwntester/octo.nvim",
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-telescope/telescope.nvim',
			'nvim-tree/nvim-web-devicons',
		},
		keys = {
			{ "<leader>Gp", "<cmd>Octo pr list<cr>", desc = "GitHub PR List" },
			{ "<leader>Gi", "<cmd>Octo issue list<cr>", desc = "GitHub Issue List" }
		},
		init = function()
			require("octo").setup()
		end
	}
}
