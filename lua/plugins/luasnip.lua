return {
	{
		"L3MON4D3/LuaSnip",
		config = function()
			require("luasnip").config.set_config({
				enable_autosnippets = true,
				update_events = "TextChanged,TextChangedI",
				store_selection_keys = "<Tab>",
			})
			require("luasnip").filetype_extend("typescript", { "tsdoc" })
			require("luasnip").filetype_extend("javascript", { "jsdoc" })
			require("luasnip").filetype_extend("typescriptreact", { "html" })
			require("luasnip").filetype_extend("javascriptreact", { "html" })
		end,
	},
}
