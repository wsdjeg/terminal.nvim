local M = {}

local winid = -1
local bufid = -1
local fps = 60

local config = {
  shell = vim.o.shell,
  border = { '┌', '─', '┐', '│', '┘', '─', '└', '│' },
}

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

local function open_float_windows()
  winid = vim.api.nvim_open_win(0, true, {
    relative = 'editor',
    width = math.floor(vim.o.columns * 0.8),
    height = 1,
    row = 1,
    col = math.floor(vim.o.columns * 0.1),
    border = config.border,
  })
  vim.api.nvim_set_option_value(
    'winhighlight',
    'NormalFloat:Normal,FloatBorder:WinSeparator',
    { win = winid }
  )
  vim.cmd('setlocal nonumber norelativenumber')
  vim.fn.timer_start(math.floor(1000 / fps + 0.5), increase_window, { ['repeat'] = 1 })
  return winid
end

local function open_win(cwd)
  winid = open_float_windows()
  vim.cmd.enew()
  bufid = vim.api.nvim_get_current_buf()
  vim.api.nvim_create_autocmd({ 'TermClose' }, {
    buffer = bufid,
    callback = function()
      if vim.api.nvim_win_is_valid(winid) then
        vim.api.nvim_win_close(winid, true)
        vim.cmd('doautocmd WinEnter')
      end
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(bufid) then
          vim.api.nvim_buf_delete(bufid, { force = true, unload = false })
        end
      end)
    end,
  })
  vim.cmd('setlocal nobuflisted')
  vim.fn.jobstart(config.shell, { term = true, cwd = cwd or vim.fn.getcwd() })
  vim.schedule(vim.cmd.startinsert)
end

function M.open(cwd)
  if not vim.api.nvim_win_is_valid(winid) then
    open_win(cwd)
  else
    vim.api.nvim_set_current_win(winid)
    vim.schedule(vim.cmd.startinsert)
  end
end

function M.open_with_terminal(term_buf)
  if not vim.api.nvim_win_is_valid(winid) then
    winid = open_float_windows()
  end
  vim.api.nvim_win_set_buf(winid, term_buf)
  vim.api.nvim_set_current_win(winid)
  vim.schedule(vim.cmd.startinsert)
end

function M.setup(opt)
  config = vim.tbl_deep_extend('force', config, opt or {})
end

return M
