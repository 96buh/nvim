return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")
		local map = vim.keymap.set

		harpoon:setup()
		local list = harpoon:list()

		map("n", "<leader>a", function()
			list:add()
		end)
		map("n", "<C-e>", function()
			harpoon.ui:toggle_quick_menu(list)
		end)

		for index = 1, 4 do
			map("n", "<leader>" .. index, function()
				list:select(index)
			end, { desc = "Harpoon file " .. index })
		end

		map("n", "<C-S-P>", function()
			list:prev()
		end)
		map("n", "<C-S-N>", function()
			list:next()
		end)
	end,
}
