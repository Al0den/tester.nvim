# tester.nvim

Simple lightweight plugin for quick testing

## Installation and setup

Any plugin manager should do the trick, but calling the setup function is required to access the functions as normal commands

**packer.nvim**
```lua
use { "Al0den/tester.nvim",
  config = function()
    require"tester".setup()
  end
}
```

**vim-plug**
```lua
Plug 'Al0den/tester.nvim'

lua << END
require('tester').setup()
END

```

Note: Setup function can be called from anywhere at anytime, lazy-loading shouldnt affect it

## How to use

```lua
--Default behavior, lets the plugin decide filetype, and use vertical as direction
vim.keymap.set("n", "<leader>t", vim.api.nvim_command("TesterTrash"))

--Specified filetype and direction
vim.keymap.set("n", "<leader>tc", vim.api.nvim_command("TesterTrash c horizontal"))

--Let the plugin decide filetype, but force direction as horizontal
--The plugin treats & as no arguments, treated as default setting for the selected parameter
vim.keymap.set("n", "<leader>th", vim.api.nvim_command("TesterTrash & horizontal"))

--Plugin can also ask the user which filetype he wants to use, as such
vim/keymap.set("n", "<leader>ta", vim.api.nvim_command("TesterTrash ask &"))
)
```

## Customization

The default setup is required and comes with no options at the time being, however some feature are configurable after plugin load
```lua
--Hide window, for the time being only a window close shortcut 
require"tester".hide_window()

--Clear all test windows
require"tester".clear_tester()

--Add a filetype in which the user will be explicitely asked what type the test file needs to be
require"tester".add_special_type(type)
--type being a string, defaults are "tex"

```



All of those commands are directly available as user command, as such:
```lua
vim.keymap.set("n", "<leader>tc", vim.api.nvim_command(":TesterHide"))
vim.keymap.set("n", "<leader>tc", vim.api.nvim_command(":TesterClear"))
```

