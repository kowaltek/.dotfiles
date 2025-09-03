return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"folke/neodev.nvim",
		"simrat39/rust-tools.nvim",
		"mhartington/formatter.nvim",
		"hrsh7th/nvim-cmp",
	},
	config = function()
		-- close quickfix menu after selecting choice and center screen
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "qf" },
			command = [[nnoremap <buffer> <CR> <CR>:cclose<CR>zz]],
		})

		local lsp_config = require("lspconfig")
		local util = require("lspconfig/util")

		local on_attach = function(_, bufnr)
			local bufopts = { noremap = true, silent = true, buffer = bufnr }
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, { silent = true })
			vim.keymap.set("n", "K", vim.lsp.buf.hover, { silent = true })
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
			vim.keymap.set("n", "]d", function()
              vim.diagnostic.jump({count = 1, float = true})
            end, bufopts)
			vim.keymap.set("n", "[d", function()
              vim.diagnostic.jump({count = -1, float = true})
            end, bufopts)
			vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
			vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
			vim.keymap.set("n", "<space>wl", function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, bufopts)
			vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { silent = true })
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { silent = true })
			vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, bufopts)
			vim.keymap.set("n", "<space>f", function()
				vim.lsp.buf.format({ async = true })
			end, bufopts)
		end

		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		-- TODO
		-- remove after figuring out what breaks if this isn't set
		-- setting this brakes rust-analyzer when running rust-tools
		-- capabilities.offsetEncoding = "utf-16"

		-- setup for languages using default configuration
		local servers = {
			"clangd",
			"docker_compose_language_service",
			"html",
			"cssls",
			"ruff",
			"pyright",
			"asm_lsp",
			"yamlls",
			"buf_ls",
			"graphql",
			"templ",
			"prismals",
			"bashls",
			"emmet_language_server",
            "jsonls"
		}
		for _, server in ipairs(servers) do
			lsp_config[server].setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})
		end

		-- TODO
		--
		-- create something by myself
		-- this crashes neovim if db connection isn't set up properly
		--
		-- -- sqls setup
		-- local sqls_root = vim.fs.root(0, ".git")
		-- if sqls_root == nil then
		-- 	sqls_root = ""
		-- end
		--       -- dunno if the below line is correct
		-- -- sqls_root = vim.fs.joinpath(vim.api.nvim_command_output("pwd"), sqls_root)
		-- -- TODO
		-- -- change to mason root
		-- lsp_config.sqls.setup({
		-- 	on_attach = function(_, bufnr)
		-- 		on_attach(_, bufnr)
		-- 		vim.keymap.set("n", "<space>f", ":Format<CR>", { buffer = bufnr })
		-- 		vim.keymap.set("n", "<space>F", ":FormatWrite<CR>", { buffer = bufnr })
		-- 	end,
		--           capabilities = capabilities,
		-- 	cmd = { "/home/mk/.local/share/nvim/mason/bin/sqls", "-config", vim.fs.joinpath(sqls_root, ".sqlsrc.yml") },
		-- })

		-- go setup
		lsp_config.gopls.setup({
			on_attach = function(_, bufnr)
				on_attach(_, bufnr)
			end,
			capabilities = capabilities,
			filetypes = { "go", "gomod", "gowork", "gotmpl" },
			root_dir = util.root_pattern("go.work", "go.mod", ".git"),
			settings = {
				gopls = {
					completeUnimported = true,
					usePlaceholders = true,
					analyses = {
						unusedparams = true,
					},
					gofumpt = true,
				},
			},
		})

		-- lua setup
		lsp_config.lua_ls.setup({
			on_attach = function(_, bufnr)
				on_attach(_, bufnr)
				vim.keymap.set("n", "<space>f", ":Format<CR>", { buffer = bufnr })
				vim.keymap.set("n", "<space>F", ":FormatWrite<CR>", { buffer = bufnr })
			end,
			capabilities = capabilities,
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						library = {
							vim.env.VIMRUNTIME,
						},
						checkThirdParty = false,
					},
					telemetry = {
						enable = false,
					},
				},
			},
		})

		-- TODO
		-- fix rust setup
		--
		-- rust setup
		-- local rt = require("rust-tools")
		-- local mason_registry = require("mason-registry")
		-- local codelldb = mason_registry.get_package("codelldb")
		-- local extension_path = codelldb:get_install_path() .. "/extension/"
		-- local codelldb_path = extension_path .. "adapter/codelldb"
		-- local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"
		--
		-- rt.setup({
		-- 	dap = {
		-- 		adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
		-- 	},
		-- 	server = {
		-- 		on_attach = function(_, bufnr)
		-- 			on_attach(_, bufnr)
		-- 			-- Hover actions
		-- 			vim.keymap.set("n", "K", rt.hover_actions.hover_actions, { buffer = bufnr })
		-- 			-- Code action groups
		-- 			vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
		-- 		end,
		-- 		capabilities = capabilities,
		-- 	},
		-- })

		-- typescript/javascript setup
		-- lsp_config.denols.setup({
		-- 	on_attach = on_attach,
		-- 	capabilities = capabilities,
		-- 	root_dir = lsp_config.util.root_pattern("deno.json", "deno.jsonc"),
		-- })

		lsp_config.ts_ls.setup({
			on_attach = function(_, bufnr)
				on_attach(_, bufnr)
				vim.keymap.set("n", "<space>f", ":Format<CR>", { buffer = bufnr })
				vim.keymap.set("n", "<space>F", ":FormatWrite<CR>", { buffer = bufnr })
			end,
			capabilities = capabilities,
			root_dir = lsp_config.util.root_pattern("package.json"),
		})

		lsp_config.jsonls.setup({
			on_attach = function(_, bufnr)
				on_attach(_, bufnr)
				vim.keymap.set("n", "<space>f", ":Format<CR>", { buffer = bufnr })
				vim.keymap.set("n", "<space>F", ":FormatWrite<CR>", { buffer = bufnr })
			end,
			capabilities = capabilities,
		})

		-- setup linters and formatters
		lsp_config["golangci_lint_ls"].setup({
			init_options = {
				command = {
					"golangci-lint",
					"run",
					"--output.json.path",
					"stdout",
					"--show-stats=false",
					"--issues-exit-code=1",
				},
			},
		})

		lsp_config["eslint"].setup({})

		local sql_formatter_config = require("formatter.filetypes.sql").sql_formatter()
		sql_formatter_config.args = {
			"--config",
			'{\\"keywordCase\\":\\"upper\\"}',
		}
		require("formatter").setup({
			logging = true,
			filetype = {
				typescriptreact = {
					require("formatter.filetypes.typescriptreact").prettier,
				},
				typescript = {
					require("formatter.filetypes.typescript").prettier,
				},
				javascriptreact = {
					require("formatter.filetypes.javascriptreact").prettier,
				},
				javascript = {
					require("formatter.filetypes.javascript").prettier,
				},
				json = {
					require("formatter.filetypes.json").prettier,
				},
				graphql = {
					require("formatter.filetypes.graphql").prettier,
				},
				lua = {
					require("formatter.filetypes.lua").stylua,
				},
				sql = {
					sql_formatter_config,
				},
			},
		})

		-- borders for floating windows
		-- TODO refactor to separate file?
		vim.cmd([[autocmd! ColorScheme * highlight NormalFloat guibg=#1f2335]])
		vim.cmd([[autocmd! ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335]])

		local border = {
			{ "🭽", "FloatBorder" },
			{ "▔", "FloatBorder" },
			{ "🭾", "FloatBorder" },
			{ "▕", "FloatBorder" },
			{ "🭿", "FloatBorder" },
			{ "▁", "FloatBorder" },
			{ "🭼", "FloatBorder" },
			{ "▏", "FloatBorder" },
		}

		local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
		function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
			opts = opts or {}
			opts.border = opts.border or border
			return orig_util_open_floating_preview(contents, syntax, opts, ...)
		end

		-- config for showing diagnostics
		vim.diagnostic.config({
			virtual_text = true,
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = false,
		})

		-- diagnostic symbols
		local signs = { Error = "", Warn = "", Hint = "󰌶", Info = "" }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
		end
	end,
}
