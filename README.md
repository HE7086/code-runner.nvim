# code-runner.nvim
Simple Code Runner for Neovim

## usage
```lua
  {
    "HE7086/code-runner.nvim",
    lazy = true,
    cmd = "CodeRunnerRun",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "akinsho/toggleterm.nvim",
    },
    config = true,
    keys = {
      { "<YOUR_KEY_MAPPING>", "<Cmd>CodeRunnerRun<Cr>", desc = "Run Code" },
    },
  }
```
