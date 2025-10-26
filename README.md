# terminal.nvim

terminal.nvim is a simple floating terminal plugin for Neovim.

![Image](https://github.com/user-attachments/assets/58e919cd-92be-49f8-a7d6-b33ea2a7a423)

## Install

with [nvim-plug](https://github.com/wsdjeg/nvim-plug)

```lua
require('plug').add({
  {
    'wsdjeg/terminal.nvim',
    opts = {
      shell = vim.o.shell,
      border = { '┌', '─', '┐', '│', '┘', '─', '└', '│' },
    },
    keys = {
      { 'n', "<leader>'", '<cmd>lua require("terminal").open()<cr>', { silent = true } },
    },
  },
})
```
