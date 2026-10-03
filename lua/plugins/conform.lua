return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		format_on_save = function(bufnr)
			-- Disable "format_on_save lsp_fallback" for languages that don't
			-- have a well standardized coding style (e.g. c/c++). You can add additional
			-- languages here or re-enable it for the disabled ones.
			local disable_filetypes = { c = true, cpp = true }
			if disable_filetypes[vim.bo[bufnr].filetype] then
				return nil
			else
				return {
					timeout_ms = 2000,
					lsp_format = "fallback",
				}
			end
		end,
		formatters = {
			latexindent = {
				prepend_args = { "-l", "-m" },
			},
		},
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
			rust = { "rustfmt", lsp_format = "fallback" },
			javascript = { "prettierd", "prettier", stop_after_first = true },
			json = { "prettierd", "prettier", stop_after_first = true },
			jsonc = { "prettierd", "prettier", stop_after_first = true },
			markdown = { "prettier" },
			yaml = { "prettier" },
			yml = { "prettier" },
			html = { "prettier" },
			liquid = { "prettier" },
			tex = { "latexindent" },
		},
	},
}
