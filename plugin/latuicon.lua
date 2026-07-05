if vim.g.loaded_latuicon then
	return
end
vim.g.loaded_latuicon = true

vim.api.nvim_create_user_command("Latuicon", function()
	require("latuicon").pick()
end, { desc = "Open latuicon icon picker" })
