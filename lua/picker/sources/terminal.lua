local M = {}

M.get = function()
  local terminals = {}

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buftype == 'terminal' then
      local running = vim.fn.jobwait({ vim.bo[buf].channel }, 0)[1] == -1
      local status = running and '✓' or '✗'
      local chan_info = vim.api.nvim_get_chan_info(vim.bo[buf].channel)
      local jobpid = vim.fn.jobpid(vim.bo[buf].channel)
      local cmd = vim.inspect(chan_info.argv)
      local cwd = vim.fn.fnamemodify(vim.split(vim.api.nvim_buf_get_name(buf), '//')[2], ':~')
      local display =
        string.format('[%-8d] %s %-12s (%s) buf:%d', jobpid, status, cmd, cwd, chan_info.buffer)
      table.insert(terminals, {
        -- buf name is term://D:\wsdjeg\terminal.nvim//16196:cmd.exe
        str = display,
        value = {
          buf = buf,
          running = running,
        },
        highlight = {
          { 0, 1, 'Comment' },
          { 1, 9, 'Number' }, -- jobpid
          { 9, 10, 'Comment' },
          { 11, 13, running and 'DiagnosticOk' or 'DiagnosticError' }, -- status
          { 13, math.max(13 + 2 + 14, 13 + 2 + #cmd), 'String' }, -- argv
          { math.max(13 + 2 + 14, 13 + 2 + #cmd), #display, 'Comment' }, -- argv
        },
      })
    end
  end

  return terminals
end

M.default_action = function(entry)
  require('terminal').open_with_terminal(entry.value.buf)
end

return M
