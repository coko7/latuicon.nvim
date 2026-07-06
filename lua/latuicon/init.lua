local M = {}

M.config = {
	cmd = "latuicon",
	theme = nil, -- passed via ICON_PICKER_THEME env
	border = "rounded",
	width = 0.5,
	height = 0.6,
}

function M.setup(opts)
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

--- Opens latuicon in a floating terminal and inserts the picked icon.
--- @param callback fun(icon: string)|nil defaults to inserting at cursor
function M.pick(callback)
	local cfg = M.config
	local tmpfile = vim.fn.tempname()

	local width = math.floor(vim.o.columns * cfg.width)
	local height = math.floor(vim.o.lines * cfg.height)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local buf = vim.api.nvim_create_buf(false, true)
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = cfg.border,
	})

	-- latuicon renders its UI on /dev/tty directly, so redirecting stdout
	-- here does not break the picker (same trick as `VAR=$(latuicon)`).
	local cmd = string.format("%s > %s", cfg.cmd, vim.fn.shellescape(tmpfile))

	local env = nil
	if cfg.theme then
		env = { ICON_PICKER_THEME = cfg.theme }
	end

	vim.fn.jobstart({ "sh", "-c", cmd }, {
		term = true,
		env = env,
		on_exit = function(_, code)
			if vim.api.nvim_win_is_valid(win) then
				vim.api.nvim_win_close(win, true)
			end

			if code ~= 0 or vim.fn.filereadable(tmpfile) == 0 then
				os.remove(tmpfile)
				return
			end

			local lines = vim.fn.readfile(tmpfile)
			os.remove(tmpfile)

			local icon = lines[1]
			if not icon or icon == "" then
				return
			end

			if callback then
				callback(icon)
			else
				M.insert_at_cursor(icon)
			end
		end,
	})

	vim.cmd("startinsert")
end

function M.insert_at_cursor(text)
	vim.api.nvim_put({ text }, "c", true, true)
end

return M
