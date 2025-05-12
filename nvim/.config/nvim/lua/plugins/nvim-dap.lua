return {
	"rcarriga/nvim-dap-ui",
	dependencies = {
		"mfussenegger/nvim-dap",
		"nvim-neotest/nvim-nio",
		"theHamsta/nvim-dap-virtual-text",
		{
			"leoluz/nvim-dap-go",
			ft = "go",
			config = function(_, opts)
				require("dap-go").setup(opts)
			end,
		},
	},
	config = function()
		local dap, dapui = require("dap"), require("dapui")

		-- register dapui to open and close on debugging sessions
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end

		dapui.setup()

		-- debugging keymaps
		vim.keymap.set("n", "<leader>ds", ":lua require'dap'.continue()<CR>")
		vim.keymap.set("n", "<leader>dk", ":lua require'dap'.disconnect({ terminateDebuggee = true })<CR>")
		vim.keymap.set("n", "<leader>dt", ":lua require'dap'.toggle_breakpoint()<CR>")
		vim.keymap.set("n", "<leader>dT", ":lua require'dap'.clear_breakpoints()<CR>")
		vim.keymap.set("n", "<leader>dc", ":lua require'dap'.continue()<CR>")
		vim.keymap.set("n", "<leader>dh", ":lua require'dap'.step_out()<CR>")
		vim.keymap.set("n", "<leader>dl", ":lua require'dap'.step_into()<CR>")
		vim.keymap.set("n", "<leader>dj", ":lua require'dap'.step_over()<CR>")
		vim.keymap.set(
			"n",
			"<leader>db",
			":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>"
		)
		vim.keymap.set("n", "<leader>de", ":lua require'dap'.eval(nil, { enter = true })<CR>")

		-- TODO
		-- dap mappings for equivalent vimspector features
		-- nmap <leader>dw :VimspectorWatch
		-- nmap <leader>do :VimspectorShowOutput

		-- " for normal mode - the word under the cursor
		-- nmap <Leader>di <Plug>VimspectorBalloonEval
		-- " for visual mode, the visually selected text
		-- xmap <Leader>di <Plug>VimspectorBalloonEval

		-- virtual text for debugging
		require("nvim-dap-virtual-text").setup()

		-- setup adapters
		dap.adapters.node2 = {
			type = "executable",
			command = "node",
			args = { vim.fn.stdpath("data") .. "/mason/packages/node-debug2-adapter/out/src/nodeDebug.js" },
		}

		dap.adapters.chrome = {
			type = "executable",
			command = "node",
			args = { vim.fn.stdpath("data") .. "/mason/packages/chrome-debug-adapter/out/src/chromeDebug.js" },
		}

        -- TODO
        -- fix rust config
        -- (vim.fn.expand "$MASON/packages/codelldb" instead of get_install_path???)
        --
		-- local mason_registry = require("mason-registry")
		-- local codelldb = mason_registry.get_package("codelldb")
		-- local codelldb_path = codelldb:get_install_path() .. "/extension/adapter/codelldb"
		--
		-- dap.adapters.codelldb = {
		-- 	type = "server",
		-- 	port = "${port}",
		-- 	executable = {
		-- 		command = codelldb_path,
		-- 		args = { "--port", "${port}" },
		-- 	},
		-- }

		-- configurations
		dap.configurations.javascript = {
			{
				name = "Launch",
				type = "node2",
				request = "launch",
				program = "${file}",
				cwd = vim.fn.getcwd(),
				sourceMaps = true,
				protocol = "inspector",
				console = "integratedTerminal",
			},
			{
				-- For this to work you need to make sure the node process is started with the `--inspect` flag.
				name = "Attach to process",
				type = "node2",
				request = "attach",
				processId = require("dap.utils").pick_process,
			},
		}

		dap.configurations.typescript = {
			{
				name = "Launch",
				type = "node2",
				request = "launch",
				program = "${file}",
				cwd = vim.fn.getcwd(),
				sourceMaps = true,
				protocol = "inspector",
				skipFiles = { "<node_internals>/**/*.js" },
				console = "integratedTerminal",
			},
			{
				-- For this to work you need to make sure the node process is started with the `--inspect` flag.
				name = "Attach to process",
				type = "node2",
				request = "attach",
				skipFiles = { "<node_internals>/**/*.js" },
				processId = require("dap.utils").pick_process,
			},
			{
				name = "Jest all tests",
				type = "node2",
				request = "launch",
				cwd = vim.fn.getcwd(),
				runtimeArgs = {
					"--inspect-brk",
					"${workspaceFolder}/node_modules/.bin/jest",
					"--no-coverage",
				},
				disableOptimisticBPs = true,
				sourceMaps = true,
				protocol = "inspector",
				skipFiles = { "<node_internals>/**/*.js" },
				console = "integratedTerminal",
				port = 9229,
			},
			{
				name = "Jest current file",
				type = "node2",
				request = "launch",
				cwd = vim.fn.getcwd(),
				runtimeArgs = {
					"--inspect-brk",
					"${workspaceFolder}/node_modules/.bin/jest",
					"--no-coverage",
					"--runTestsByPath",
					"${relativeFile}",
					"--config",
					"jest.config.ts",
				},
				disableOptimisticBPs = true,
				sourceMaps = true,
				protocol = "inspector",
				skipFiles = { "<node_internals>/**/*.js" },
				console = "integratedTerminal",
				port = 9229,
			},
			{
				name = "Jest current file nestjs",
				type = "node2",
				request = "launch",
				cwd = vim.fn.getcwd(),
				runtimeArgs = {
					"--inspect-brk",
					"${workspaceFolder}/node_modules/.bin/jest",
					"--no-coverage",
					"--runTestsByPath",
					"${relativeFile}",
					"--config",
					"test/jest-e2e.json",
				},
				disableOptimisticBPs = true,
				protocol = "inspector",
				skipFiles = { "<node_internals>/**/*.js" },
				console = "integratedTerminal",
				port = 9229,
			},
			-- For this to work install google-chrome-stable and run it with the --remote-debugging-port=9222 flag
			{
				name = "Launch Chrome",
				type = "chrome",
				request = "attach",
				program = "${file}",
				cwd = vim.fn.getcwd(),
				sourceMaps = true,
				protocol = "inspector",
				port = 9222,
				webRoot = "${workspaceFolder}",
			},
		}

		-- c/c++/rust config
		dap.configurations.c = {
			{
				name = "Launch file",
				type = "codelldb",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
			},
		}
		dap.configurations.cpp = dap.configurations.c
		dap.configurations.rust = dap.configurations.c

		-- loads launch.json from default location (.vscode/launch.json)
		require("dap.ext.vscode").load_launchjs(nil, { node2 = { "javascript" } })
	end,
}
