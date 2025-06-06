return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		strategies = {
			chat = { adapter = "ollama" },
		},
		adapters = {
			ollama = function()
				return require("codecompanion.adapters").extend("ollama", {
					env = {
						url = "http://localhost:8080",
					},
				})
			end,
		},
		opts = {
			log_level = "DEBUG",
		},
	},
}
