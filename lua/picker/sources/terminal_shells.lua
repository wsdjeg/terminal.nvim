local M = {}

local previewer = require('picker.previewer.buffer')

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
        name = shell.name,
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

M.preview_win = true ---@type boolean

---@param item PickerItem
---@param win integer
---@param buf integer
function M.preview(item, win, buf)
  previewer.buflines = {}
  table.insert(previewer.buflines, 'Name:       ' .. item.value.name)
  table.insert(previewer.buflines, 'Command:    ' .. table.concat(item.value.cmd, ' '))
  if item.value.available then
    table.insert(previewer.buflines, 'Executable: ' .. vim.fn.exepath(item.value.cmd[1]))
  else
    table.insert(previewer.buflines, 'Status:     ✗ not available in current os')
  end
  previewer.filetype = nil
  previewer.preview(1, win, buf, true)
end

return M

