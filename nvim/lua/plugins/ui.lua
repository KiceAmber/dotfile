return {
	{
		"nvim-lualine/lualine.nvim",
		opts = function(_, opts)
			if true == true then
				opts.options = {
					icons_enabled = true,
					theme = "auto",
				}
			end
		end,
	},
}
