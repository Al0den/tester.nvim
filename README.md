# tester.nvim

Simple lightweight plugin for quick testing

## Installation and setup

Any plugin manager should do the trick, and calling the setup function is mandatory

[**packer.nvim**](https://github.com/wbthomason/packer.nvim)
```lua
use { 
  "Al0den/tester.nvim",
  config = function()
    require"tester".setup()
  end
}
```

[**vim-plug**](https://github.com/junegunn/vim-plug)
```vimscript
Plug 'Al0den/tester.nvim'

lua << END
require('tester').setup()
END
```

[**dein**](https://github.com/Shougo/dein.vim)
```lua
call dein#add('Al0den/tester.nvim')

require("tester").setup()
```

Note: Setup function can be called from anywhere at anytime, lazy-loading shouldnt affect it

## How to use

```lua
--Open a new trash window using default settings
vim.keymap.set("n", "<leader>te", require"tester".open)

--Clear all open testing windows
vim.keymap.set("n", "<leader>tc", require"tester".clear)
```

## Customization

The default setup is required and comes with no options at the time being, however some feature are configurable after plugin load
```lua
--The default function needs to be called in order to get all the faetures, and the default setup is as such:
require"tester".setup({
    defaultDir = "vsplit", -- "vsplit" | "split"
    askForType = { ".tex" }, --Any string will work if the files ends with this particular string
    --Default file content when creating a new trash window, "@" represents cursor position, and isn't required
    defaultContent = {
      c = "#include<stdio.h>\n#include<stdlib.h>\n#include<assert.h>\n\nint main() {\n    @\n}",
      py = 'def main():\n    @\n\n\nif __name__ == "__main__":\n    main()\n'
    }
})

--Same thing for the open() function, no parameters required by default
require"tester".open({
    dir = "vsplit", --If no dir is specified, defaultDir from the setup() function will be used
    type = ".c" --If no type is specified, and current file type isnt in askForType from the setup function, the current type will be used
})

--If you want to make the tester window more distinguishable from the others, you can use your own highlight group
vim.api.nvim_set_hl(0, "testerNormal", { bg = "red"})

```



