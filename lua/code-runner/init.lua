local M = {}

local function compile_run_remove(compiler, flags)
    return string.format("%s %s %s -o %s && %s; rm -f %s",
      compiler,
      flags,
      vim.fn.expand("%"),
      vim.fn.expand("%:r"),
      vim.fn.expand("%:p:r"),
      vim.fn.expand("%:r")
    )
end

M.runners = setmetatable({
  ["ahk"] = "autohotkey",
  ["applescript"] = "osascript",
  ["autoit"] = "autoit3",
  ["bat"] = "cmd /c",
  ["c"] = function()
    local cc = os.getenv("CC") or "cc"
    local cflags = os.getenv("CFLAGS") or ""
    return compile_run_remove(cc, cflags)
  end,
  ["closure"] = "lein exec",
  ["coffeescript"] = "coffee",
  ["cpp"] = function()
    local cxx = os.getenv("CXX") or "c++"
    local cxxflags = os.getenv("CXXFLAGS") or ""
    return compile_run_remove(cxx, cxxflags)
  end,
  ["crystal"] = "crystal",
  ["csharp"] = "scriptcs",
  -- ["d"] = function() end,
  ["dart"] = "dart",
  ["erlang"] = "escript",
  ["fortran"] = function()
    local fc = os.getenv("FC") or "gfortran"
    local fflags = os.getenv("FFLAGS") or ""
    return compile_run_remove(fc, fflags)
  end,
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
    return compile_run_remove("rustc", rustflags)
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
  else
    M.term = function(command)
      vim.api.nvim_command("tabnew | terminal " .. command)
    end
  end

end

return M
