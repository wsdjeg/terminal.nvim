local M = {}

M.get = function()
  local hi = require('terminal').get_config().picker.highlight
  local terminals = {}

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buftype == 'terminal' then
      local running = vim.fn.jobwait({ vim.bo[buf].channel }, 0)[1] == -1
      local status = running and '✓' or '✗'
      local chan_info = vim.api.nvim_get_chan_info(vim.bo[buf].channel)
      local jobpid = string.format('%-8d', vim.fn.jobpid(vim.bo[buf].channel))
      local cmd = string.format('%-12s', vim.inspect(chan_info.argv))
      local cwd = vim.fn.fnamemodify(vim.split(vim.api.nvim_buf_get_name(buf), '//')[2], ':~')
      local display =
        string.format('[%s] %s %s (%s) buf:%d', jobpid, status, cmd, cwd, chan_info.buffer)
      table.insert(terminals, {
        -- buf name is term://D:\wsdjeg\terminal.nvim//16196:cmd.exe
        str = display,
        value = {
          buf = buf,
          running = running,
        },
        --  [25768   ] ✓ { "cmd.exe", "/s", "/c", '"cmd.exe"' } (~\AppData\Local\nvim) buf:2
        --   jobpid   status            cmd                             cwd            bufnr
        highlight = {
          { 0, 1, 'Comment' },
          { 1, 1 + #jobpid, hi.jobpid }, -- jobpid
          { 1 + #jobpid, 2 + #jobpid, 'Comment' },
          { 3 + #jobpid, 4 + #jobpid, running and hi.status_ok or hi.status_error }, -- status
          { 5 + #jobpid, 8 + #jobpid + #cmd, hi.cmd }, -- argv
          {
            8 + #jobpid + #cmd,
            9 + #jobpid + #cmd,
            'Comment',
          }, -- argv
          {
            9 + #jobpid + #cmd,
            9 + #jobpid + #cmd + #cwd,
            hi.cwd,
          }, -- argv
          {
            9 + #jobpid + #cmd + #cwd,
            10 + #jobpid + #cmd + #cwd,
            'Comment',
          }, -- argv
          {
            10 + #jobpid + #cmd + #cwd,
            #display,
            hi.buffer,
          }, -- argv
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
