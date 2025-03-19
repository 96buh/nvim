return {
	{
		"lervag/vimtex",
		lazy = false, -- we don't want to lazy load VimTeX
		-- tag = "v2.15", -- uncomment to pin to a specific release
		init = function()
			-- VimTeX configuration goes here, e.g.
			vim.g.vimtex_view_method = "skim"
			-- vim.g.tex_flavor = "latex"
			vim.g.vimtex_complete_enable = 1

			vim.o.conceallevel = 2
			-- 設定 vimTeX 的 conceal 選項
			vim.g.vimtex_syntax_conceal = {
				accents = 1,
				ligatures = 1,
				cites = 1,
				fancy = 1,
				spacing = 1,
				greek = 1,
				math_bounds = 0,
				math_delimiters = 1,
				math_fracs = 1,
				math_symbols = 1,
				math_super_sub = 1,
				sections = 1,
				styles = 1,
			}
			-- 設定符號
			vim.g.vimtex_syntax_custom_cmds = {
				{ name = "multiply", cmdre = "times", mathmode = 1, concealchar = "" },
			}
			-- 關掉QuickFix訊息
			vim.g.vimtex_quickfix_open_on_warning = 0
			-- 編譯後的檔案儲存在temp資料夾
			vim.g.vimtex_compiler_latexmk = {
				aux_dir = "temp",
				options = {
					"-verbose",
					"-file-line-error",
					"-synctex=1",
					"-interaction=nonstopmode",
					"-shell-escape",
				},
			}

			vim.g.vimtex_quickfix_ignore_filters = {
				"Underfull \\\\hbox",
				"Overfull \\\\hbox",
				"LaTeX Warning: .\\+ float specifier changed to",
				"LaTeX hooks Warning",
				'Package siunitx Warning: Detected the "physics" package:',
				"Package hyperref Warning: Token not allowed in a PDF string",
			}

			-- vimTeX鍵位
			vim.cmd([[
                nmap dsm <Plug>(vimtex-env-delete-math)
                " Use `ai` and `ii` for the item text object
                omap ai <Plug>(vimtex-am)
                xmap ai <Plug>(vimtex-am)
                omap ii <Plug>(vimtex-im)
                xmap ii <Plug>(vimtex-im)

                " Use `am` and `im` for the inline math text object
                omap am <Plug>(vimtex-a$)
                xmap am <Plug>(vimtex-a$)
                omap im <Plug>(vimtex-i$)
                xmap im <Plug>(vimtex-i$)

                " Example: make `<leader>wc` call the command `VimtexCountWords`;
                noremap <leader>wc <Cmd>VimtexCountWords<CR>

                " Use `<localleader>c` to trigger continuous compilation...
                noremap <localleader>c <Cmd>update<CR><Cmd>VimtexCompileSS<CR>

                " Define a custom shortcut to trigger VimtexView
                nmap <localleader>v <plug>(vimtex-view)
            ]])
		end,
	},
}
