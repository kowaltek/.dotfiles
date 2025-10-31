return {
	"hrsh7th/nvim-cmp",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{
			{
				"MattiasMTS/cmp-dbee",
				dependencies = {
					{
						"kndndrj/nvim-dbee",
						dependencies = {
							"MunifTanjim/nui.nvim",
						},
						build = function()
							-- Install tries to automatically detect the install method.
							-- if it fails, try calling it with one of these parameters:
							--    "curl", "wget", "bitsadmin", "go"
							require("dbee").install("wget")
						end,
						config = function()
							local dbee_root = vim.fs.root(0, ".git")
							if not dbee_root then
								dbee_root = ""
							end
							local dbee = require("dbee")
							dbee.setup({
								sources = {
									-- this requires the project to be git repository
									-- format for the file is
                                    --
									-- [
                                    --   {
									--     "id": "optional_identifier", -- only mandatory if you edit a file by hand. IT'S YOUR JOB TO KEEP THESE UNIQUE!
									--     "name": "My Database",
									--     "type": "sqlite", -- type of database driver
									--     "url": "~/path/to/mydb.db"
									--   }
                                    -- ]
									require("dbee.sources").FileSource:new(vim.fs.joinpath(dbee_root, ".dbrc.json")),
								},
							})
							vim.keymap.set("n", "<leader>DB", dbee.toggle)
						end,
					},
				},
				ft = "sql", -- optional but good to have
				opts = {}, -- needed
			},
		},
		{
			"windwp/nvim-autopairs",
			event = "InsertEnter",
			config = true,
		},
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-nvim-lsp-signature-help",
		"saadparwaiz1/cmp_luasnip",
		"hrsh7th/cmp-nvim-lua",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-cmdline",
		"numToStr/Comment.nvim",
	},
	config = function()
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")

		-- all default options are set for luasnip snippets
		local cmp = require("cmp")

		cmp.setup({
			-- snippets are required
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),
				["<CR>"] = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = false,
				}),
			}),
			-- order of the sources matters - it gives the completions ranking for priority
			-- additional fields for sources are: keyword_length, priority, max_item_count
			sources = {
				{ name = "nvim_lua", keyword_length = 2 }, -- complete neovim's Lua runtime API such vim.lsp.*
				{ name = "nvim_lsp" }, -- from language server
				{ name = "path" }, -- file paths
				{ name = "luasnip" }, -- from luasnip snippets
				{ name = "buffer", keyword_length = 4 }, -- source current buffer
				{ name = "nvim_lsp_signature_help" }, -- display function signatures with current parameter emphasized
				{ name = "cmp-dbee" },
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			formatting = {
				fields = { "menu", "abbr", "kind" },
				format = function(entry, item)
					local menu_icon = {
						nvim_lua = "[api]",
						nvim_lsp = "[lsp]",
						path = "[path]",
						luasnip = "[snip]",
						buffer = "[buf]",
					}
					item.menu = menu_icon[entry.source.name]
					return item
				end,
			},
			preselect = cmp.PreselectMode.None,
		})

		-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
		cmp.setup.cmdline({ "/", "?" }, {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = "buffer" },
			},
		})

		-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" },
			}, {
				{ name = "cmdline" },
			}),
			matching = { disallow_symbol_nonprefix_matching = false },
		})

		-- adds '(' after selecting function of method in autocompletion
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

		-- comment.nvim setup
		require("Comment").setup()
	end,
}
