-- dashboard
return {
	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		config = function()
			require("alpha.term")
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")

			-- dashboard.section.terminal.command = "fastfetch"
			-- dashboard.section.terminal.width = 80
			-- dashboard.section.terminal.height = 20
			dashboard.section.terminal.command = "bash ~/.config/nvim/ansi/gopher.sh; sleep 9999"
			dashboard.section.terminal.width = 46
			dashboard.section.terminal.height = 25
			dashboard.section.terminal.opts.redraw = true

			dashboard.section.header.val = "Hello"

			dashboard.section.buttons.val = {
				-- dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
				-- dashboard.button("f", "  Find Files", ":Telescope find_files <CR>"),
				dashboard.button("o", "󱋡  Recent Files", "<cmd>Telescope oldfiles<cr>"),
				dashboard.button("q", "󰈆  Quit", ":qa<CR>"),
			}

			dashboard.config.layout = {
				{ type = "padding", val = 2 },
				dashboard.section.terminal,
				{ type = "padding", val = 6 },
				dashboard.section.header,
				{ type = "padding", val = 2 },
				dashboard.section.buttons,
			}

			alpha.setup(dashboard.config)
		end,
	},
}
