return {
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "┃" },
					change = { text = "┃" },
					delete = { text = "▁" },
					topdelete = { text = "▔" },
					changedelete = { text = "█" },
				},
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns
					local map = vim.keymap.set
					-- 跳到下一個/上一個 hunk
					map("n", "]c", function()
						gs.next_hunk()
					end)
					map("n", "[c", function()
						gs.prev_hunk()
					end)
					-- 預覽 hunk
					map("n", "<leader>hp", gs.preview_hunk)
					-- stage/unstage hunk
					map("n", "<leader>hs", gs.stage_hunk)
					map("n", "<leader>hu", gs.undo_stage_hunk)
				end,
			})
		end,
	},
}
