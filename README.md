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
```vimscript
Plug 'Al0den/tester.nvim'

lua << END
require('tester').setup()
END

```

Note: Setup function can be called from anywhere at anytime, lazy-loading shouldnt affect it

## How to use

```lua
--Open a new trash window using default settings
vim.keymap.set("n", "<leader>te", require"tester".open())

--Clear all open testing windows
vim.keymap.set("n", "<leader>tc", require"tester".clear())
```

## Customization

The default setup is required and comes with no options at the time being, however some feature are configurable after plugin load
```lua
-- the setup() function doesnt need to be called with any parameters, and the defaults are:
require"tester".setup({
    defaultDir = "vsplit", -- "vsplit" | "split"
    askForType = { ".tex" } --Any string will work if the files ends with this particular string
})

--Same thing for the open() function
require"tester".open({
    dir = "vsplit", --If no dir is specified, defaultDir from the setup() function will be used
    type = ".c" --If no type is specified, and current file type isnt in askForType from the setup function, the current type will be used
})
```



