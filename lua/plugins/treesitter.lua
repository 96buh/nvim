return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                highlight = { enable = true },
                indent = { enable = true },
                ensure_installed = {
                    "vim",
                    "vimdoc",
                    "lua",
                    "cpp",
                    "query",
                    "javascript",
                    "typescript",
                    "html",
                    "css",
                },
                sync_install = false,
                auto_install = true,
                ignore_install = { "latex" },
            })
        end,
	},
}
