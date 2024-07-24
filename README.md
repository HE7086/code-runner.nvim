# code-runner.nvim
Simple Code Runner for Neovim

* This plugin is designed for quickly running very simple scripts in one click.
* For anything consisting of more than one file this is not suited, use a proper build system instead.

## usage
* Lazy.nvim
```lua
  {
    "HE7086/code-runner.nvim",
    cmd = "CodeRunnerRun",
    opts = { -- make sure to have this none empty so the plugin could load. E.g. opts = {}
      runners = {
        -- customize your own runners overriding builtin ones
        { ft = "zsh", runner = "zsh" },
        {
          ft = "rust",
          runner = function()
            return string.format(
              "rustc %s -o %s && %s; rm -f %s",
              vim.fn.expand("%"),
              vim.fn.expand("%:r"),
              vim.fn.expand("%:p:r"),
              vim.fn.expand("%:r")
            )
          end
        },
      },
      term = function(command)
        -- use neovim's builtin terminal
        vim.api.nvim_command("tabnew | terminal " .. command)

        -- default value: use toggleterm (make sure to add it as dependency)
        -- require("toggleterm").exec(command, nil, nil, nil, nil, "Code Runner")
      end,
    },
    keys = {
      { "<YOUR_KEY_MAPPING>", "<Cmd>CodeRunnerRun<Cr>", desc = "Run Code" },
    },
  }
```
