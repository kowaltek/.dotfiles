return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		strategies = {
			chat = { adapter = "gemini" },
		},
		adapters = {
			gemini = function()
				return require("codecompanion.adapters").extend("gemini", {
					env = {
                      api_key = "cmd:echo $GEMINI_API_KEY"
					},
				})
			end,
		},
		opts = {
			log_level = "DEBUG",
		},
	},
}
