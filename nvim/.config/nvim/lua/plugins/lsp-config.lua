return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"folke/neodev.nvim",
		"mhartington/formatter.nvim",
		"hrsh7th/nvim-cmp",
	},
	config = function()
		-- close quickfix menu after selecting choice and center screen
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "qf" },
			command = [[nnoremap <buffer> <CR> <CR>:cclose<CR>zz]],
		})

		local on_attach = function(_, bufnr)
			local bufopts = { noremap = true, silent = true, buffer = bufnr }
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, { silent = true })
			vim.keymap.set("n", "K", vim.lsp.buf.hover, { silent = true })
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
			vim.keymap.set("n", "]d", function()
				vim.diagnostic.jump({ count = 1, float = true })
			end, bufopts)
			vim.keymap.set("n", "[d", function()
				vim.diagnostic.jump({ count = -1, float = true })
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
		capabilities.offsetEncoding = "utf-16"

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
			"jsonls",
			"cmake",
			"eslint",
		}
		for _, server in ipairs(servers) do
			vim.lsp.config(server, {
				on_attach = on_attach,
				capabilities = capabilities,
			})
            vim.lsp.enable(server)
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
		-- vim.lsp.config.sqls.setup({
		-- 	on_attach = function(_, bufnr)
		-- 		on_attach(_, bufnr)
		-- 		vim.keymap.set("n", "<space>f", ":Format<CR>", { buffer = bufnr })
		-- 		vim.keymap.set("n", "<space>F", ":FormatWrite<CR>", { buffer = bufnr })
		-- 	end,
		--           capabilities = capabilities,
		-- 	cmd = { "/home/mk/.local/share/nvim/mason/bin/sqls", "-config", vim.fs.joinpath(sqls_root, ".sqlsrc.yml") },
		-- })

		-- go setup
		vim.lsp.config("gopls", {
			on_attach = function(_, bufnr)
				on_attach(_, bufnr)
			end,
			capabilities = capabilities,
			filetypes = { "go", "gomod", "gowork", "gotmpl" },
			root_markers = { "go.work", "go.mod", ".git" },
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
        vim.lsp.enable("gopls")

		-- lua setup
		vim.lsp.config("lua_ls", {
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
        vim.lsp.enable("lua_ls")

		-- typescript/javascript setup
		-- vim.lsp.config.denols.setup({
		-- 	on_attach = on_attach,
		-- 	capabilities = capabilities,
		-- 	root_dir = vim.lsp.config.util.root_pattern("deno.json", "deno.jsonc"),
		-- })

		vim.lsp.config("ts_ls", {
			on_attach = function(_, bufnr)
				on_attach(_, bufnr)
				vim.keymap.set("n", "<space>f", ":Format<CR>", { buffer = bufnr })
				vim.keymap.set("n", "<space>F", ":FormatWrite<CR>", { buffer = bufnr })
			end,
			capabilities = capabilities,
			root_markers = { "package.json" },
		})
        vim.lsp.enable("ts_ls")

		vim.lsp.config("jsonls", {
			on_attach = function(_, bufnr)
				on_attach(_, bufnr)
				vim.keymap.set("n", "<space>f", ":Format<CR>", { buffer = bufnr })
				vim.keymap.set("n", "<space>F", ":FormatWrite<CR>", { buffer = bufnr })
			end,
			capabilities = capabilities,
		})
        vim.lsp.enable("jsonls")

		-- setup linters and formatters
		vim.lsp.config("golangci_lint_ls", {
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
        vim.lsp.enable("golangci_lint_ls")

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
