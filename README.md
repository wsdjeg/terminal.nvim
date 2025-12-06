# terminal.nvim

terminal.nvim is a simple floating terminal plugin for Neovim.

[![GitHub License](https://img.shields.io/github/license/wsdjeg/terminal.nvim)](LICENSE)
[![GitHub Issues or Pull Requests](https://img.shields.io/github/issues/wsdjeg/terminal.nvim)](https://github.com/wsdjeg/terminal.nvim/issues)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/m/wsdjeg/terminal.nvim)](https://github.com/wsdjeg/terminal.nvim/commits/master/)
[![GitHub Release](https://img.shields.io/github/v/release/wsdjeg/terminal.nvim)](https://github.com/wsdjeg/terminal.nvim/releases)
[![luarocks](https://img.shields.io/luarocks/v/wsdjeg/terminal.nvim)](https://luarocks.org/modules/wsdjeg/terminal.nvim)

![Image](https://github.com/user-attachments/assets/58e919cd-92be-49f8-a7d6-b33ea2a7a423)

<!-- vim-markdown-toc GFM -->

- [Install](#install)
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
        },
      },
    },
  },
})
```

## Picker Source

terminal.nvim also provides a `terminal` source for picker.nvim. Use `:Picker terminal` to fuzzy find opened terminal buffers.

![picker-terminal](https://github.com/user-attachments/assets/ac94089e-7106-42f5-b887-143d747c2b7a)
