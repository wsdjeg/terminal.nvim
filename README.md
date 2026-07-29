# terminal.nvim

terminal.nvim is a simple floating terminal plugin for Neovim.

[![Run Tests](https://github.com/wsdjeg/terminal.nvim/actions/workflows/test.yml/badge.svg)](https://github.com/wsdjeg/terminal.nvim/actions/workflows/test.yml)
[![GitHub License](https://img.shields.io/github/license/wsdjeg/terminal.nvim)](LICENSE)
[![GitHub Issues or Pull Requests](https://img.shields.io/github/issues/wsdjeg/terminal.nvim)](https://github.com/wsdjeg/terminal.nvim/issues)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/m/wsdjeg/terminal.nvim)](https://github.com/wsdjeg/terminal.nvim/commits/master/)
[![GitHub Release](https://img.shields.io/github/v/release/wsdjeg/terminal.nvim)](https://github.com/wsdjeg/terminal.nvim/releases)
[![luarocks](https://img.shields.io/luarocks/v/wsdjeg/terminal.nvim)](https://luarocks.org/modules/wsdjeg/terminal.nvim)

![Image](https://github.com/user-attachments/assets/58e919cd-92be-49f8-a7d6-b33ea2a7a423)

<!-- vim-markdown-toc GFM -->

- [Install](#install)
- [Configuration](#configuration)
- [Picker Source](#picker-source)

<!-- vim-markdown-toc -->

## Install

with [nvim-plug](https://github.com/wsdjeg/nvim-plug)

```lua
require('plug').add({
  {
    'wsdjeg/terminal.nvim',
    keys = {
      {
        'n',
        "<leader>'",
        '<cmd>lua require("terminal").open()<cr>',
        { silent = true, desc = 'open terminal in current path' },
      },
      {
        'n',
        '<leader>"',
        '<cmd>lua require("terminal").open(vim.fn.expand("%:p:h"))<cr>',
        { silent = true, desc = 'open terminal in file path' },
      },
    },
    opts = {
      border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
    },
  },
})
```

## Configuration

```lua
require('terminal').setup({
  -- default shell, passed to jobstart
  shell = vim.o.shell,

  -- floating window border
  border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },

  -- preset shells for :Picker terminal_shells
  -- each entry: { name = "display name", cmd = { "executable", "arg1", "arg2" } }
  -- picker auto-checks executable availability and shows ✓/✗
  shells = {
    { name = 'bash',       cmd = { 'bash' } },
    { name = 'zsh',        cmd = { 'zsh' } },
    { name = 'lua',        cmd = { 'lua' } },
    { name = 'cmd',        cmd = { 'cmd', '/c', 'cls' } },
    { name = 'powershell', cmd = { 'powershell' } },
  },

  -- picker highlight groups
  picker = {
    highlight = {
      --  [25768   ] ✓ { "cmd.exe", "/s", "/c", '"cmd.exe"' } (~\AppData\Local\nvim) buf:2
      --   jobpid   status            cmd                             cwd            bufnr
      jobpid = 'Number',
      status_ok = 'DiagnosticOk',
      status_error = 'DiagnosticError',
      cmd = 'String',
      cwd = 'Comment',
      buffer = 'Comment',
      shell_name = 'Function',
      shell_cmd = 'Comment',
    },
  },
})
```

### API

| Function | Description |
|----------|-------------|
| `terminal.open(cwd, shell)` | Open floating terminal. `cwd` defaults to current directory, `shell` defaults to `config.shell` |
| `terminal.open_with_terminal(term_buf)` | Open existing terminal buffer in floating window |
| `terminal.setup(opt)` | Merge config |
| `terminal.get_config()` | Get current config |

## Picker Source

terminal.nvim provides two picker sources for [picker.nvim](https://github.com/wsdjeg/picker.nvim):

### `:Picker terminal`

Fuzzy find opened terminal buffers.

![picker-terminal](https://github.com/user-attachments/assets/ac94089e-7106-42f5-b887-143d747c2b7a)

### `:Picker terminal_shells`

Fuzzy select a preset shell and open a new terminal with it.

```
✓ bash          bash
✓ zsh           zsh
✗ lua           lua
✓ cmd           cmd /c cls
✓ powershell    powershell
```

Each shell's availability is auto-checked via `executable()`. Selecting a shell calls `terminal.open(nil, cmd)`.

