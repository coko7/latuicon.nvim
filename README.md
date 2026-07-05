# 😴 latuicon.nvim

Neovim plugin wrapping [latuicon](https://github.com/coko7/latuicon) — pick an emoji, kaomoji, Unicode char, or Nerd Font glyph and insert it at the cursor.

<p align="center">
    <img width="694" height="692" alt="latuicon-demo" src="https://github.com/user-attachments/assets/62ee3bb8-5870-4f97-96b0-d5571e64fea0" />
</p>

## Requirements

- Neovim >= 0.8
- `latuicon` binary on `$PATH` (install with cargo: `cargo install latuicon`)

## Install

lazy.nvim:

```lua
{
  "coko7/latuicon.nvim",
  cmd = "Latuicon",
  keys = {
    { "<leader>ie", function() require("latuicon").pick() end, desc = "Insert icon" },
  },
  opts = {},
}
```

packer.nvim:

```lua
use({
  "coko7/latuicon.nvim",
  config = function()
    require("latuicon").setup()
  end,
})
```

## Usage

- `:Latuicon` opens the picker in a floating terminal.
- Pick and confirm inside latuicon as usual; the selected icon is inserted at the cursor.
- Bind `require("latuicon").pick()` to a key, or pass a callback: `require("latuicon").pick(function(icon) ... end)`.

## Config

```lua
require("latuicon").setup({
  cmd = "latuicon",   -- binary name/path
  theme = "dracula",  -- optional, sets ICON_PICKER_THEME
  border = "rounded",
  width = 0.5,         -- fraction of editor width
  height = 0.6,        -- fraction of editor height
})
```
