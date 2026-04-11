return {
	"chomosuke/typst-preview.nvim",
	lazy = false,
	version = "1.*",
	opts = {
		dependencies_bin = {
			tinymist = vim.fn.stdpath("data") .. "/mason/bin/tinymist",
		},
		follow_cursor = true,
	},
	keys = {
		{ "<localleader>v", "<cmd>TypstPreviewToggle<cr>", ft = "typst", desc = "Typst preview" },
	},
}
