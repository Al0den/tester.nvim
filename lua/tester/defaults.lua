local M = {}

M.opts = {}
M.askForType = { ".tex" }
M.defaultContent = {
    c = "#include<stdio.h>\n#include<stdlib.h>\n#include<assert.h>\n\nint main() {\n    @\n}",
    py = 'def main():\n    @\n\n\nif __name__ == "__main__":\n    main()\n'
}

return M
