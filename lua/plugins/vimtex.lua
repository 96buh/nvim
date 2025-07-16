return {
	{
		"lervag/vimtex",
		lazy = false, -- we don't want to lazy load VimTeX
		-- tag = "v2.15", -- uncomment to pin to a specific release
		config = function()
			-- 自動縮排(latexindent)
			vim.g.vimtex_indent_enabled = 1
			vim.g.vimtex_indent_latexindent = "latexindent"
			vim.g.vimtex_indent_look_for_local = 1

			-- 2) 打开或新建 .tex 时，设定 indentexpr
			vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "FileType" }, {
				pattern = "*.tex",
				callback = function()
					vim.bo.shiftwidth = 3
					vim.bo.expandtab = true
					vim.bo.autoindent = true
					vim.bo.smartindent = false
					vim.bo.indentexpr = "v:lua.ForestIndent()"
				end,
			})

			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*.tex",
				callback = function()
					local view = vim.fn.winsaveview()
					vim.cmd("silent! %!latexindent -l -m")
					local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
					local new_lines = {}
					local shiftwidth = 3
					local i = 1
					while i <= #lines do
						local line = lines[i]
						if line:match("\\begin{forest}") then
							table.insert(new_lines, line)
							i = i + 1
							local forest_block = {}
							while i <= #lines and not lines[i]:match("\\end{forest}") do
								table.insert(forest_block, lines[i])
								i = i + 1
							end
							local processed = {}
							local depth = 0
							for _, l in ipairs(forest_block) do
								-- 檢查是否為設定行 (for tree, 空白行, %註解)
								if l:match("^%s*[^%[%]]") or l:match("^%s*$") then
									table.insert(processed, l)
								else
									-- 將行拆成多個 token
									local j = 1
									local curr = ""
									while j <= #l do
										local c = l:sub(j, j)
										if c == "[" or c == "]" then
											if #curr > 0 then
												local content = curr:gsub("^%s+", "")
												if #content > 0 then
													table.insert(
														processed,
														string.rep(" ", depth * shiftwidth) .. content
													)
												end
												curr = ""
											end
											if c == "[" then
												table.insert(processed, string.rep(" ", depth * shiftwidth) .. "[")
												depth = depth + 1
											elseif c == "]" then
												depth = depth - 1
												if depth < 0 then
													depth = 0
												end
												table.insert(processed, string.rep(" ", depth * shiftwidth) .. "]")
											end
											j = j + 1
										else
											curr = curr .. c
											j = j + 1
										end
									end
									-- 行結束還有內容
									if #curr > 0 then
										local content = curr:gsub("^%s+", "")
										if #content > 0 then
											table.insert(processed, string.rep(" ", depth * shiftwidth) .. content)
										end
									end
								end
							end
							-- 合併 leaf: 若某行形如 [xxx]，直接成一行
							local output = {}
							local k = 1
							while k <= #processed do
								if
									processed[k]:match("^%s*%[$")
									and processed[k + 2]
									and processed[k + 2]:match("^%s*%]$")
								then
									local middle = processed[k + 1]:gsub("^%s+", "")
									local indent = processed[k]:match("^(%s*)%[")
									table.insert(output, (indent or "") .. "[" .. middle .. "]")
									k = k + 3
								else
									table.insert(output, processed[k])
									k = k + 1
								end
							end
							for _, l in ipairs(output) do
								table.insert(new_lines, l)
							end
							if i <= #lines then
								table.insert(new_lines, lines[i]) -- \end{forest}
								i = i + 1
							end
						else
							table.insert(new_lines, line)
							i = i + 1
						end
					end
					vim.api.nvim_buf_set_lines(0, 0, -1, false, new_lines)
					vim.fn.winrestview(view)
				end,
			})

			function _G.ForestIndent()
				local lnum = vim.v.lnum
				local line = vim.fn.getline(lnum)

				local bs = vim.fn.search("\\begin{forest}", "bnW")
				local be = vim.fn.search("\\end{forest}", "nW")
				if bs == 0 or (be ~= 0 and (lnum < bs or lnum > be)) then
					return vim.fn.indent(lnum - 1)
				end

				if not line:match("^%s*%[") then
					return 0
				end

				local base_indent = vim.fn.indent(bs)
				local shiftwidth = vim.bo.shiftwidth

				local open_brackets = 0
				for i = bs, lnum - 1 do
					local l = vim.fn.getline(i)
					open_brackets = open_brackets + select(2, l:gsub("%[", ""))
					open_brackets = open_brackets - select(2, l:gsub("%]", ""))
				end
				if open_brackets < 0 then
					open_brackets = 0
				end

				-- leaf 或閉合 ] 單獨一行的話，不再進一層
				if line:match("^%s*%]") then
					open_brackets = open_brackets - 1
					if open_brackets < 0 then
						open_brackets = 0
					end
				end

				return base_indent + open_brackets * shiftwidth
			end

			-- VimTeX configuration goes here, e.g. pdf reader
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
