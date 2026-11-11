return {
	"refractalize/oil-git-status.nvim",
	dependencies = { "stevearc/oil.nvim" },
	opts = {
		show_ignored = true,
	},
	config = function(_, opts)
		require("oil-git-status").setup(opts)

		local function match_background()
			for group, source in pairs({
				OilGitStatusIndex = "DiagnosticSignInfo",
				OilGitStatusWorkingTree = "DiagnosticSignWarn",
			}) do
				local highlight = vim.api.nvim_get_hl(0, { name = source, link = false })
				vim.api.nvim_set_hl(0, group, { fg = highlight.fg, ctermfg = highlight.ctermfg })
			end
		end

		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("OilGitStatusBackground", { clear = true }),
			callback = match_background,
		})
		match_background()
	end,
}
