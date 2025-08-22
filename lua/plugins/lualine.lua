return {

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local function os_icon()
				local icons = {
					unix = "", -- e712
					dos = "", -- e70f
					mac = "", -- e711
				}
				if vim.fn.has("mac") == 1 then
					return icons.mac
				elseif vim.fn.has("win32") == 1 then
					return icons.dos
				else
					return icons.unix
				end
			end

			require("lualine").setup({
				icons_enabled = true,
				theme = "gruvbox",
				sections = {
					-- lualine_x = { "encoding", { "fileformat", symbols = { unix = os_icon() } }, "filetype" },
					lualine_x = { "filetype" },
				},
			})
		end,
	},
}
