return {
	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		build = "make install_jsregexp",
		config = function()
			require("luasnip").config.set_config({
				enable_autosnippets = true,
				update_events = "TextChanged,TextChangedI",
				store_selection_keys = "<Tab>",
			})
			-- friendly-snippets - enable standardized comments snippets
			require("luasnip").filetype_extend("typescript", { "tsdoc" })
			require("luasnip").filetype_extend("javascript", { "jsdoc" })
			require("luasnip").filetype_extend("typescriptreact", { "html" })
			require("luasnip").filetype_extend("javascriptreact", { "html" })
		end,
	},
}
