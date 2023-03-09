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



