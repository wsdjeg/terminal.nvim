-- test/example_spec.lua
-- Example test for terminal.nvim

local lu = require('luaunit')
local terminal = require('terminal')

TestTerminal = {}

function TestTerminal:setUp()
  terminal.setup({
    shell = vim.o.shell,
    border = { '┌', '─', '┐', '│', '┘', '─', '└', '│' },
  })
end

function TestTerminal:tearDown()
  -- Clean up any created windows/buffers
  vim.cmd('bd! | qa!')
end

function TestTerminal:test_setup_config()
  local config = terminal.get_config()
  lu.assertNotNil(config)
  lu.assertEquals(type(config.shell), 'string')
  lu.assertNotNil(config.border)
end

function TestTerminal:test_setup_merge()
  terminal.setup({
    shell = '/bin/bash',
  })
  local config = terminal.get_config()
  lu.assertEquals(config.shell, '/bin/bash')
  -- border should still be preserved from previous setup
  lu.assertNotNil(config.border)
end

function TestTerminal:test_open_function_exists()
  lu.assertEquals(type(terminal.open), 'function')
end

function TestTerminal:test_open_with_terminal_exists()
  lu.assertEquals(type(terminal.open_with_terminal), 'function')
end

return TestTerminal

