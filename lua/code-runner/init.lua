local term = require("toggleterm")

local M = {}

M.runners = setmetatable({
  ["c"] = function()
    local cc = os.getenv("CC") or "cc"
    local cflags = os.getenv("CFLAGS") or ""
    return string.format("%s %s %s -o %s && %s; rm -f %s",
      cc,
      cflags,
      vim.fn.expand("%"),
      vim.fn.expand("%:r"),
      vim.fn.expand("%:p:r"),
      vim.fn.expand("%:r")
    )
  end,
  ["cpp"] = function()
    local cxx = os.getenv("CXX") or "c++"
    local cxxflags = os.getenv("CXXFLAGS") or ""
    return string.format("%s %s %s -o %s && %s; rm -f %s",
      cxx,
      cxxflags,
      vim.fn.expand("%"),
      vim.fn.expand("%:r"),
      vim.fn.expand("%:p:r"),
      vim.fn.expand("%:r")
    )
  end,
  ["rust"] = function()
    local rustflags = os.getenv("RUSTFLAGS") or ""
    return string.format("rustc %s %s -o %s && %s; rm -f %s",
      rustflags,
      vim.fn.expand("%"),
      vim.fn.expand("%:r"),
      vim.fn.expand("%:p:r"),
      vim.fn.expand("%:r")
    )
  end,
  ["python"] = "python",
  ["haskell"] = "runhaskell",
  ["sh"] = "bash",
}, { __index = function() return "echo Unsupported Filetype: " end })

function M.run()
  local filetype = vim.bo.filetype
  local runner = M.runners[filetype]
  local command = nil

  if type(runner) == "string" then
    command = runner .. " " .. vim.fn.expand("%:p")
  elseif type(runner) == "function" then
    command = runner()
  else
    return
  end

  -- vim.api.nvim_command("tabnew | terminal " .. command)
  term.exec(command, nil, nil, nil, nil, "Code Runner")
end

function M.setup(opts)
  vim.api.nvim_create_user_command("CodeRunnerRun", function() M.run() end, {})

  if opts.runners then
    for _, r in pairs(opts.runners) do
      M.runners[r.ft] = r.runner
    end
  end
end

return M
