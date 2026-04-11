return {
	"saghen/blink.cmp",
	version = "1.*",
	dependencies = {
		{
			"L3MON4D3/LuaSnip",
			dependencies = {
				{
					"rafamadriz/friendly-snippets",
					config = function()
						require("luasnip.loaders.from_vscode").lazy_load({
							-- 關閉LaTeX的snippet
							exclude = { "tex", "plaintex" },
						})
					end,
				},
			},
			opts = {},
		},
		{
			"saghen/blink.compat",
			version = "*",
			lazy = true,
			opts = {},
		},
		"micangl/cmp-vimtex",
	},
	opts = {
		keymaps = { preset = "default" },
		appearance = { nerd_font_variant = "mono" },
		completion = {
			menu = {
				draw = { treesitter = { "lsp" } },
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 500,
			},
		},
		snippets = { preset = "luasnip" },
		sources = {
			default = { "lsp", "path", "snippets", "buffer", "vimtex" },
			providers = {
				vimtex = {
					name = "vimtex",
					min_keyword_length = 2,
					module = "blink.compat.source",
					score_offset = 80,
				},
			},
		},
		fuzzy = { implementation = "prefer_rust_with_warning" },
		signature = { enabled = true },
	},
}
