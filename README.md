# terminal.nvim

terminal.nvim is a simple floating terminal plugin for Neovim.

## Install

with [nvim-plug](https://github.com/wsdjeg/nvim-plug)

```lua
require('plug').add({
  {
    'wsdjeg/terminal.nvim',

    config = function()
      vim.keymap.set('n', "<leader>'", '<cmd>lua require("terminal").open()<cr>', { silent = true })
    end,
  },
})
```
