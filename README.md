# terminal.nvim

`terminal.nvim` is a simple floating terminal plugin for Neovim.
It provides a clean floating window with smooth open animation,
and integrates with [picker.nvim](https://github.com/wsdjeg/picker.nvim)
for fuzzy-finding terminal buffers and selecting preset shells.

[![Run Tests](https://github.com/wsdjeg/terminal.nvim/actions/workflows/test.yml/badge.svg)](https://github.com/wsdjeg/terminal.nvim/actions/workflows/test.yml)
[![GitHub License](https://img.shields.io/github/license/wsdjeg/terminal.nvim)](LICENSE)
[![GitHub Issues or Pull Requests](https://img.shields.io/github/issues/wsdjeg/terminal.nvim)](https://github.com/wsdjeg/terminal.nvim/issues)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/m/wsdjeg/terminal.nvim)](https://github.com/wsdjeg/terminal.nvim/commits/master/)
[![GitHub Release](https://img.shields.io/github/v/release/wsdjeg/terminal.nvim)](https://github.com/wsdjeg/terminal.nvim/releases)
[![luarocks](https://img.shields.io/luarocks/v/wsdjeg/terminal.nvim)](https://luarocks.org/modules/wsdjeg/terminal.nvim)

![Image](https://github.com/user-attachments/assets/58e919cd-92be-49f8-a7d6-b33ea2a7a423)

<!-- vim-markdown-toc GFM -->

- [✨ Features](#-features)
- [📦 Installation](#-installation)
- [🔧 Configuration](#-configuration)
- [⚙️ Basic Usage](#-basic-usage)
- [🔌 Picker Sources](#-picker-sources)
    - [terminal](#terminal)
    - [terminal_shells](#terminal_shells)
- [❓ FAQ](#-faq)
- [📣 Self-Promotion](#-self-promotion)
- [💬 Feedback](#-feedback)
- [🙏 Credits](#-credits)
- [📄 License](#-license)

<!-- vim-markdown-toc -->

## ✨ Features

- Floating terminal window with smooth open animation
- Open terminal in current directory or custom `cwd`
- Support custom shell commands per terminal
- Reopen existing terminal buffers in a floating window
- Picker sources for [picker.nvim](https://github.com/wsdjeg/picker.nvim):
  - `terminal` — fuzzy find opened terminal buffers
  - `terminal_shells` — select from preset shells with availability check
- Fully configurable border, shell, and highlight groups

## 📦 Installation

terminal.nvim works with all major Neovim plugin managers.

- **Using [nvim-plug](https://github.com/wsdjeg/nvim-plug)**

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

- **Using [lazy.nvim](https://github.com/folke/lazy.nvim)**

  ```lua
  {
    "wsdjeg/terminal.nvim",
    keys = {
      { "<leader>'", '<cmd>lua require("terminal").open()<cr>', desc = "open terminal" },
      { '<leader>"', '<cmd>lua require("terminal").open(vim.fn.expand("%:p:h"))<cr>', desc = "open terminal in file path" },
    },
    opts = {
      border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
    },
  }
  ```

- **Using [packer.nvim](https://github.com/wbthomason/packer.nvim)**

  ```lua
  use({
    'wsdjeg/terminal.nvim',
    config = function()
      require('terminal').setup({
        border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
      })
    end,
  })
  ```

- **Using [luarocks](https://luarocks.org/)**

  ```
  luarocks install terminal.nvim
  ```

## 🔧 Configuration

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

## ⚙️ Basic Usage

### API

| Function | Description |
| -------- | ----------- |
| `terminal.open(cwd, shell)` | Open floating terminal. `cwd` defaults to current directory, `shell` defaults to `config.shell` |
| `terminal.open_with_terminal(term_buf)` | Open existing terminal buffer in floating window |
| `terminal.setup(opt)` | Merge config |
| `terminal.get_config()` | Get current config |

### Examples

Open terminal in current directory:

```lua
require('terminal').open()
```

Open terminal in a specific directory:

```lua
require('terminal').open(vim.fn.expand('%:p:h'))
```

Open terminal with a custom shell:

```lua
require('terminal').open(nil, { 'python3' })
```

Open an existing terminal buffer in a floating window:

```lua
require('terminal').open_with_terminal(bufnr)
```

## 🔌 Picker Sources

terminal.nvim provides two picker sources for [picker.nvim](https://github.com/wsdjeg/picker.nvim):

### terminal

Fuzzy find opened terminal buffers.

```
:Picker terminal
```

![picker-terminal](https://github.com/user-attachments/assets/ac94089e-7106-42f5-b887-143d747c2b7a)

Each entry shows:

```
[25768   ] ✓ { "cmd.exe", "/s", "/c", '"cmd.exe"' } (~\AppData\Local\nvim) buf:2
 jobpid     status            cmd                             cwd            bufnr
```

| key binding | description |
| ----------- | ----------- |
| `<Enter>`   | open selected terminal buffer in floating window |

### terminal_shells

Fuzzy select a preset shell and open a new terminal with it.

```
:Picker terminal_shells
```

Each shell's availability is auto-checked via `executable()`:

```
✓ bash          bash
✓ zsh           zsh
✗ lua           lua
✓ cmd           cmd /c cls
✓ powershell    powershell
```

| key binding | description |
| ----------- | ----------- |
| `<Enter>`   | open new terminal with selected shell |

## ❓ FAQ

1. how to change the floating window border?

```lua
require('terminal').setup({
  border = 'rounded', -- or a custom table: { '╭', '─', '╮', '│', '╯', '─', '╰', '│' }
})
```

2. how to add preset shells for `:Picker terminal_shells`?

```lua
require('terminal').setup({
  shells = {
    { name = 'bash',  cmd = { 'bash' } },
    { name = 'fish',  cmd = { 'fish' } },
    { name = 'python', cmd = { 'python3' } },
  },
})
```

3. how to disable the smooth open animation?

The animation is built-in and cannot be disabled via config.
If you prefer no animation, you can override the `open_float_windows` function
in your config.

## 📣 Self-Promotion

Like this plugin? Star the repository on
GitHub.

Love this plugin? Follow [me](https://wsdjeg.net/) on
[GitHub](https://github.com/wsdjeg) or [Twitter](https://x.com/EricWongDEV).

## 💬 Feedback

If you encounter any bugs or have suggestions, please file an issue in the [issue tracker](https://github.com/wsdjeg/terminal.nvim/issues)

## 🙏 Credits

- [picker.nvim](https://github.com/wsdjeg/picker.nvim)

## 📄 License

Licensed under GPL-3.0.

