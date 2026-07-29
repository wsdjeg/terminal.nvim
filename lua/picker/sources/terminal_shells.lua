local M = {}

M.get = function()
  local terminal = require('terminal')
  local hi = terminal.get_config().picker.highlight
  local shells = terminal.get_config().shells or {}
  local results = {}

  for _, shell in ipairs(shells) do
    local exe = shell.cmd[1]
    local available = vim.fn.executable(exe) == 1
    local status = available and '✓' or '✗'
    local name = string.format('%-14s', shell.name)
    local cmd_str = table.concat(shell.cmd, ' ')
    local display = string.format('%s %s%s', status, name, cmd_str)

    table.insert(results, {
      str = display,
      value = {
        cmd = shell.cmd,
        available = available,
      },
      highlight = {
        { 0, 1, available and hi.status_ok or hi.status_error },
        { 2, 2 + #name, hi.shell_name },
        { 2 + #name, #display, hi.shell_cmd },
      },
    })
  end

  return results
end

M.default_action = function(entry)
  require('terminal').open(nil, entry.value.cmd)
end

return M

