local M = {}

M.opts = {}
M.askForType = { ".tex" }
M.defaultContent = {
    c = "#include<stdbool.h>\n#include<stdio.h>\n#include<stdlib.h>\n#include<assert.h>\n\nint main() {\n    @\n}",
    py = 'def main():\n    @\n\n\nif __name__ == "__main__":\n    main()\n',
    html =
    '<!DOCTYPE html>\n<html lang="en">\n  <head>\n    <meta charset="UTF-8">\n    <meta name="viewport" content="width=device-width, initial-scale=1.0">\n    <meta http-equiv="X-UA-Compatible" content="ie=edge">\n    <title>Testing</title>\n    <link rel="stylesheet" href="style.css">\n  </head>\n  <body>\n     @\n  </body>\n</html>',
    ml = 'let print_bool val = match val with\n    | true -> print_string"true"\n    | false -> print_string"false"\n@\n'
}
M.writeDir = "current"
M.formatOnOpen = false
M.defaultDir = "vsplit"

return M
