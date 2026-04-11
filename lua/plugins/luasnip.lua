return {
	"L3MON4D3/LuaSnip",
	config = function()
		local ls = require("luasnip")

		ls.config.set_config({
			enable_autosnippets = true,
			update_events = "TextChanged,TextChangedI",
			store_selection_keys = "<Tab>",
		})
		ls.filetype_extend("typescript", { "tsdoc" })
		ls.filetype_extend("javascript", { "jsdoc" })
		ls.filetype_extend("typescriptreact", { "html" })
		ls.filetype_extend("javascriptreact", { "html" })

		require("luasnip.loaders.from_lua").lazy_load({
			paths = { vim.fn.stdpath("config") .. "/lua/snippets" },
		})
		require("luasnip.loaders").load_lazy_loaded(vim.api.nvim_get_current_buf())
	end,
}
