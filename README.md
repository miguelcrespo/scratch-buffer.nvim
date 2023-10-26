# 📋 Scratch Buffer

Get a scratch buffer when Neovim starts that you can use to easily execute small pieces of code in any of the supported languages with full autocompletion, language server (LSP) support and interactive evaluation through Conjure.

Heavily inspired by the Emacs Scratch buffer.



https://github.com/miguelcrespo/scratch-buffer.nvim/assets/5839623/810ec94b-6f19-47fe-a5de-7cf0a9aae66b



## Features
- Support multiple languages:
	- lua (default)
	- fennel
	- python
- Customize the buffer heading to your liking 🎨

## Requirements
- Optional: [Conjure](https://github.com/Olical/conjure) if you want interactive evaluation **recommended**

## Installation

Install with your plugin manager of choice. Example for `lazy`
```lua
  {
    "miguelcrespo/scratch-buffer.nvim",
    event = 'VimEnter',
    config = function()
      require('scratch-buffer').setup()
    end,
    dependencies = {
     -- Recommended if you want interactive evaluation
      "Olical/conjure"
    }
  },
```

## Configuration

**Scratch Buffer** comes with the following defaults:
```lua
{
  filetype = "lua", -- fennel, python
  buffname = "*scratch*",
  with_lsp = true, -- Use a temporal file to start the LSP server
  heading = "...", -- A nice Neovim ASCII header, feel free to change it :D
  with_neovim_version = true, -- Display the Neovim version bellow the heading
}
```

## Usage

After installing the plugin, just open Neovim as you normally do and you will see the new scratch buffer 🚀

To evaluate a piece of code inside the buffer you can use the default Conjure mappings (it won't work if you have not mapped the `localleader`):

- `<localleader>er` Evaluate the root form under the cursor 
- `<localleade>ee` Evaluate the current form under the cursor
- `<localleader>eb` Evaluate the current buffer contents

[Conjure mappings](https://github.com/Olical/conjure/blob/master/doc/conjure.txt)

## Credits
- Startup ASCII art taken from [ascii.nvim](https://github.com/MaximilianLloyd/ascii.nvim/)
- [Conjure](https://github.com/Olical/conjure) for being such an amazing plugin
- [Emacs](https://www.gnu.org/software/emacs/) for the idea
- [Fennel](https://fennel-lang.org/) because I built this plugin just to learn it
