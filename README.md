# code-runner.nvim
Simple Code Runner for Neovim

* This plugin is designed for quickly running very simple scripts in one click.
* For anything consisting of more than one file this is not suited, use a proper build system instead.

## usage
* Lazy.nvim
```lua
  {
    "HE7086/code-runner.nvim",
    lazy = true,
    cmd = "CodeRunnerRun",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "akinsho/toggleterm.nvim",
    },
    config = true, -- either config or opts must be present for the plugin to load
    opts = {
      runners = {
        { ft = "zsh", runner = "zsh" },
        { ft = "rust", runner = function(dir, file, exe)
          return string.format("cd %s && rustc %s -o %s && %s", dir, file, exe, exe)
        end },
      },
    },
    keys = {
      { "<YOUR_KEY_MAPPING>", "<Cmd>CodeRunnerRun<Cr>", desc = "Run Code" },
    },
  }
```
