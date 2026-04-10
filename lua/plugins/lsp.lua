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
		local lsp_servers = {
			"lua_ls",
			"clangd",
			"pyright",
			"html",
			"cssls",
			"tailwindcss",
			"vtsls",
			"tinymist",
			"rust_analyzer",
		}
		local mason_tools = {
			"prettier",
			"stylua",
			"pylint",
			"eslint_d",
		}
		local enabled_servers = {
			"lua_ls",
			"clangd",
			"pyright",
			"html",
			"cssls",
			"tailwindcss",
			"vtsls",
			"tinymist",
			"rust_analyzer",
		}

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
				if client and client:supports_method("textDocument/documentHighlight", event.buf) then
					local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })

					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})

					vim.api.nvim_create_autocmd("LspDetach", {
						group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
						callback = function(detach_event)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({
								group = "kickstart-lsp-highlight",
								buffer = detach_event.buf,
							})
						end,
					})
				end
			end,
		})

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

		vim.lsp.config("clangd", {
			capabilities = capabilities,
			cmd = { "clangd", "--background-index", "--clang-tidy" },
			filetypes = { "c", "cpp", "objc", "objcpp" },
		})

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

		vim.lsp.config("html", { capabilities = capabilities })
		vim.lsp.config("cssls", { capabilities = capabilities })

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

		vim.lsp.config("rust_analyzer", {
			capabilities = capabilities,
		})

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
						importModuleSpecifier = "non-relative",
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

		vim.lsp.config("tinymist", {
			cmd = { "tinymist" },
			filetypes = { "typst" },
			settings = {
				formatterMode = "typstyle",
				formatterIndentSize = 4,
			},
		})

		require("mason-lspconfig").setup({
			ensure_installed = lsp_servers,
			automatic_installation = true,
		})

		require("mason-tool-installer").setup({
			ensure_installed = mason_tools,
			auto_update = false,
			run_on_start = true,
		})

		for _, server in ipairs(enabled_servers) do
			vim.lsp.enable(server)
		end
	end,
}
