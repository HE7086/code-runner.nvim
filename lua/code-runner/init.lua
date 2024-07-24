local M = {}

M.runners = setmetatable({
  ["ahk"] = "autohotkey",
  ["applescript"] = "osascript",
  ["autoit"] = "autoit3",
  ["bat"] = "cmd /c",
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
  ["closure"] = "lein exec",
  ["coffeescript"] = "coffee",
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
  ["crystal"] = "crystal",
  ["csharp"] = "scriptcs",
  -- ["d"] = function() end,
  ["dart"] = "dart",
  ["erlang"] = "escript",
  -- ["fortran"] = function() end,
  ["fsharp"] = "fsi",
  -- ["gleam"] = function() end,
  ["go"] = "go run",
  ["groovy"] = "groovy",
  ["haskell"] = "runhaskell",
  -- ["haxe"] = function() end,
  -- ["java"] = function() end,
  ["javascript"] = "node",
  ["julia"] = "julia",
  ["kit"] = "kitc --run",
  -- ["less"] = function() end,
  ["lisp"] = "sbcl --script",
  ["lua"] = "lua",
  ["mojo"] = "mojo run",
  ["nim"] = "nim compile --verbosity:0 --hints:off --run",
  -- ["objective-c"] = function() end,
  ["ocaml"] = "ocaml",
  -- ["pascal"] = function() end,
  ["perl"] = "perl",
  ["php"] = "php",
  -- ["pkl"] = function() end,
  ["powershell"] = "powershell -ExecutionPolicy ByPass -File",
  ["python"] = "python",
  ["r"] = "Rscript",
  ["racket"] = "racket",
  ["ruby"] = "ruby",
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
  ["sass"] = "sass --style expanded",
  ["scala"] = "scala",
  ["scheme"] = "csi -script",
  ["scss"] = "scss --style expanded",
  ["sh"] = "bash",
  -- ["sml"] = function() end,
  ["spwn"] = "spwn build",
  ["swift"] = "swift",
  ["typescript"] = "ts-node",
  ["v"] = "v run",
  ["vbscript"] = "cscript //Nologo",
  ["zig"] = "zig run",
  ["zsh"] = "zsh",
}, { __index = function() return "echo Unsupported Filetype: " end })

M.term = nil

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

  M.term(command)
end

function M.setup(opts)
  vim.api.nvim_create_user_command("CodeRunnerRun", function() M.run() end, {})

  if opts.runners then
    for _, r in pairs(opts.runners) do
      M.runners[r.ft] = r.runner
    end
  end

  if opts.term then
    M.term = opts.term
    -- M.term = function(command)
    --   vim.api.nvim_command("tabnew | terminal " .. command)
    -- end
  else
    M.term = function(command)
      require("toggleterm").exec(command, nil, nil, nil, nil, "Code Runner")
    end
  end

end

return M
