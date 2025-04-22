local M = {}

local winid = -1
local bufid = -1
local fps = 60

local function increase_window()
  if vim.api.nvim_win_is_valid(winid) then
    local wininfo = vim.api.nvim_win_get_config(winid)
    wininfo.height = wininfo.height + 2
    vim.api.nvim_win_set_config(winid, { height = wininfo.height })
    if wininfo.height <= math.floor(vim.o.lines * 0.4) then
      vim.fn.timer_start(math.floor(1000 / fps + 0.5), increase_window, { ['repeat'] = 1 })
    end
  end
end
local function open_win(cwd)
  winid = vim.api.nvim_open_win(0, true, {
    relative = 'editor',
    width = math.floor(vim.o.columns * 0.8),
    height = 1,
    row = 1,
    col = math.floor(vim.o.columns * 0.1),
    border = { '┌', '─', '┐', '│', '┘', '─', '└', '│' },
  })
  vim.cmd.enew()
  bufid = vim.api.nvim_get_current_buf()
  vim.api.nvim_create_autocmd({ 'TermClose' }, {
    buffer = bufid,
    callback = function()
      vim.api.nvim_win_close(winid, true)
      vim.cmd('doautocmd WinEnter')
      vim.api.nvim_buf_delete(bufid, { force = true, unload = false })
    end,
  })
  vim.cmd('setlocal nobuflisted nonumber norelativenumber')
  vim.fn.jobstart(vim.o.shell, { term = true, cwd = cwd or vim.fn.getcwd() })
  vim.cmd.startinsert()
  vim.api.nvim_set_option_value(
    'winhighlight',
    'NormalFloat:Normal,FloatBorder:WinSeparator',
    { win = winid }
  )
  vim.fn.timer_start(math.floor(1000 / fps + 0.5), increase_window, { ['repeat'] = 1 })
end

function M.open(cwd)
  if not vim.api.nvim_win_is_valid(winid) then
    open_win(cwd)
  else
    vim.api.nvim_set_current_win(winid)
    vim.cmd.startinsert()
  end
end

return M
