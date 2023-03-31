# tester.nvim

Simple lightweight plugin for quick testing inside [neovim](https://neovim.io), easy to setup, use and expand

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
```lua
Plug 'Al0den/tester.nvim'

lua << END
require('tester').setup()
END
```

[**dein**](https://github.com/Shougo/dein.vim)
```lua
call dein#add('Al0den/tester.nvim')

lua << END
require('tester').setup()
END
```

Note: `setup` function can be called from anywhere at anytime, lazy-loading shouldnt affect it

## How to use

```lua
--Open a new trash window using default settings
vim.keymap.set("n", "<leader>te", require"tester".open)

--Clear all open testing windows
vim.keymap.set("n", "<leader>tc", require"tester".clear)
```

## Customization

The default setup function needs to be ran before the plugin is correctly usable, and comes with the defaults:
```lua
--The default function needs to be called in order to get all the faetures, and the default setup is as such:
require"tester".setup({
    defaultDir = "vsplit", -- "vsplit" | "split"
    askForType = { ".tex" }, --Any string will work if the files ends with this particular string
    --Default file content when creating a new trash window, "@" represents cursor position, and isn't required
    defaultContent = {
      c = "#include<stdio.h>\n#include<stdlib.h>\n#include<assert.h>\n\nint main() {\n    @\n}",
      py = 'def main():\n    @\n\n\nif __name__ == "__main__":\n    main()\n'
      html = '<!DOCTYPE html>\n<html lang="en">\n  <head>\n    <meta charset="UTF-8">\n    <meta name="viewport" content="width=device-width, initial-scale=1.0">\n    <meta http-equiv="X-UA-Compatible" content="ie=edge">\n    <title>Testing</title>\n    <link rel="stylesheet" href="style.css">\n  </head>\n  <body>\n     @\n  </body>\n</html>',
      ml = 'let print_bool val = match val with\n    | true -> print_string"true"\n    | false -> print_string"false"\n@\n'
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

## Features

Some other functions, mostly for user-addons or convenience are available, and are listed here.
No options are ever required as arguments in the functions, and will default to the `setup()` function

```lua
--Write the current file to the specified path, if unspecified defaults to the current working directory.
--Note:  Relative path unsupported, cwd will write the file to the current working directory of the main file
require"tester".write({ 
    path = "~/Desktop/TesterFiles/" --For the current working directory, use 'cwd'
    name = "testerFile"
})

--Get the status of the testing file. False if not opened, otherwise returns the window ID of the window containing the buffer 
require"tester".isOpened()
```

## Roadmap

- Add relative path support for `write` function
- Add custom file headers, especially for C with classic packages included in a single header




