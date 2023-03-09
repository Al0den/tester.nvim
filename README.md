# tester.nvim

Simple lightweight plugin for quick testing

## Installation and setup

Any plugin manager should do the trick, but calling the setup function is required to access the functions

**Packer**
```lua
use { "Al0den/tester.nvim",
  config = function()
    require"tester".setup()
  end
}
```

## How to use

```lua
--Default behavior, lets the plugin decide filetype, and use vertical as direction
vim.keymap.set("n", "<leader>t", function()
  vim.api.nvim_command("TesterTrash")
end)

--Specified filetype and direction
vim.keymap.set("n", "<leader>tc", function()
  vim.api.nvim_command("TesterTrash c horizontal")
end)

--Let the plugin decide filetype, but force direction as horizontal
--The plugin treats & as no arguments for the selected parameter
vim.keymap.set("n", "<leader>th", function()
  vim.api.nvim_command("TesterTrash & horizontal")
end)
```

