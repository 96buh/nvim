return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim", opts = {} },
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{ "j-hui/fidget.nvim", opts = {} },
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		-- nvim-cmp capabilities → broadcast to all servers
		local capabilities = vim.tbl_deep_extend(
			"force",
			vim.lsp.protocol.make_client_capabilities(),
			require("cmp_nvim_lsp").default_capabilities()
		)

		-- Keymaps & highlights on LSP attach
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
				map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
				map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
				map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
				map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
				map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
				map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
				map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
				map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
				map("K", vim.lsp.buf.hover, "Hover")
				map("<leader>e", function()
					vim.diagnostic.open_float(0, {
						scope = "line",
						border = "rounded",
						focus = false,
					})
				end, "Show line diagnostics")

				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
					local hl = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = hl,
						callback = vim.lsp.buf.document_highlight,
					})
					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = hl,
						callback = vim.lsp.buf.clear_references,
					})
					vim.api.nvim_create_autocmd("LspDetach", {
						group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
						callback = function(ev)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = ev.buf })
						end,
					})
				end

				if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
					vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })

					map("<leader>th", function()
						vim.lsp.inlay_hint.enable(
							not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }),
							{ bufnr = event.buf }
						)
					end, "[T]oggle Inlay [H]ints")
				end
			end,
		})

		vim.diagnostic.config({
			-- virtual_text = {
			-- 	prefix = "⚠️",
			-- 	spacing = 4,
			-- },
			signs = true, -- 顯示E/W/H
			underline = true,
			float = {
				border = "rounded",
				focusable = false,
				style = "minimal",
				source = "always",
				header = "",
				prefix = "",
			},
			severity_sort = true,
			update_in_insert = false,
		})

		------------------------------------------------------------------
		-- LSP CONFIGS                                                  --
		------------------------------------------------------------------
		-- local util = require("lspconfig.util")

		-- Lua
		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					diagnostics = { globals = { "vim" } },
					workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
					completion = { callSnippet = "Replace" },
					telemetry = { enable = false },
				},
			},
		})

		-- C/C++
		vim.lsp.config("clangd", {
			capabilities = capabilities,
			cmd = { "clangd", "--background-index", "--clang-tidy" },
			filetypes = { "c", "cpp", "objc", "objcpp" },
		})

		-- Python
		vim.lsp.config("pyright", {
			capabilities = capabilities,
			settings = {
				python = {
					analysis = {
						diagnosticSeverityOverrides = {
							reportUnusedExpression = "none",
						},
					},
				},
			},
		})

		-- HTML / CSS
		vim.lsp.config("html", { capabilities = capabilities })
		vim.lsp.config("cssls", { capabilities = capabilities })

		-- TailwindCSS
		vim.lsp.config("tailwindcss", {
			capabilities = capabilities,
			filetypes = {
				"html",
				"css",
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
			},
		})

		-- typescript
		vim.lsp.config("vtsls", {
			capabilities = capabilities,
			settings = {
				vtsls = {
					autoUseWorkspaceTsdk = true,
					maxTsServerMemory = 4096,
				},
				typescript = {
					inlayHints = {
						enumMemberValues = { enabled = true },
						functionLikeReturnTypes = { enabled = true },
						parameterNames = { enabled = "all" }, -- "none" | "literals" | "all"
						parameterTypes = { enabled = true },
						propertyDeclarationTypes = { enabled = true },
						variableTypes = { enabled = true },
					},
					format = {
						semicolons = "remove", -- "insert" | "remove" | "ignore"
					},
					preferences = {
						importModuleSpecifier = "non-relative", -- 選擇 import style
						includeCompletionsForModuleExports = true,
						includeCompletionsWithInsertText = true,
					},
				},
				javascript = {
					inlayHints = {
						enumMemberValues = { enabled = true },
						functionLikeReturnTypes = { enabled = true },
						parameterNames = { enabled = "all" },
						parameterTypes = { enabled = true },
						propertyDeclarationTypes = { enabled = true },
						variableTypes = { enabled = true },
					},
				},
			},
		})

		-- mason
		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"clangd",
				"pyright",
				"html",
				"cssls",
				"tailwindcss",
				"vtsls",
			},
			automatic_installation = true,
		})

		-- formatter/linter
		require("mason-tool-installer").setup({
			ensure_installed = {
				-- formatting
				"prettier",
				"stylua",
				"isort",
				"black",
				-- linting
				"pylint",
				"eslint_d",
			},
			auto_update = false,
			run_on_start = true,
		})

		vim.lsp.enable("lua_ls")
		vim.lsp.enable("clangd")
		vim.lsp.enable("pyright")
		vim.lsp.enable("html")
		vim.lsp.enable("cssls")
		vim.lsp.enable("tailwindcss")
	end,
}
