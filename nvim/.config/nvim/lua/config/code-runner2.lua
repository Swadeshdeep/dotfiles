-- Create a new file at ~/.config/nvim/lua/config/code-runner.lua
local M = {}

-- Function to get command based on filetype
function M.get_command(filetype, filename)
  -- Properly escape the filename for shell commands
  local escaped_filename = vim.fn.shellescape(filename)

  -- Command mapping for various programming languages
  local commands = {
    -- Scripting languages
    python = "python3 " .. escaped_filename,
    lua = "lua " .. escaped_filename,
    javascript = "node " .. escaped_filename,
    typescript = "ts-node " .. escaped_filename,
    php = "php " .. escaped_filename,
    ruby = "ruby " .. escaped_filename,
    perl = "perl " .. escaped_filename,
    r = "Rscript " .. escaped_filename,
    julia = "julia " .. escaped_filename,

    -- Web development
    html = function()
      -- Open HTML files in the default browser
      if vim.fn.has("unix") == 1 then
        return "xdg-open " .. escaped_filename
      elseif vim.fn.has("mac") == 1 then
        return "open " .. escaped_filename
      else
        return "start " .. escaped_filename
      end
    end,

    -- Shell scripts
    sh = "bash " .. escaped_filename,
    bash = "bash " .. escaped_filename,
    zsh = "zsh " .. escaped_filename,
    fish = "fish " .. escaped_filename,

    -- Compiled languages
    cpp = function()
      local output = vim.fn.expand("%:p:r")
      local escaped_output = vim.fn.shellescape(output)
      return "g++ -std=c++17 -o " .. escaped_output .. " " .. escaped_filename .. " && " .. escaped_output
    end,
    c = function()
      local output = vim.fn.expand("%:p:r")
      local escaped_output = vim.fn.shellescape(output)
      return "gcc -o " .. escaped_output .. " " .. escaped_filename .. " && " .. escaped_output
    end,
    java = function()
      local dir = vim.fn.expand("%:p:h")
      local file = vim.fn.expand("%:t:r")
      local escaped_dir = vim.fn.shellescape(dir)
      local escaped_file = vim.fn.shellescape(file)
      return "cd " .. escaped_dir .. " && javac " .. escaped_filename .. " && java " .. escaped_file
    end,
    rust = function()
      local output = vim.fn.expand("%:p:r")
      local escaped_output = vim.fn.shellescape(output)
      return "rustc -o " .. escaped_output .. " " .. escaped_filename .. " && " .. escaped_output
    end,
    go = "go run " .. escaped_filename,

    -- JVM languages
    kotlin = function()
      local dir = vim.fn.expand("%:p:h")
      local file = vim.fn.expand("%:t:r")
      local escaped_dir = vim.fn.shellescape(dir)
      local escaped_file = vim.fn.shellescape(file)
      return "cd "
        .. escaped_dir
        .. " && kotlinc "
        .. escaped_filename
        .. " -include-runtime -d "
        .. escaped_file
        .. ".jar && java -jar "
        .. escaped_file
        .. ".jar"
    end,
    scala = function()
      local file = vim.fn.expand("%:t")
      local escaped_file = vim.fn.shellescape(file)
      return "scala " .. escaped_file
    end,
    groovy = "groovy " .. escaped_filename,

    -- .NET languages
    cs = function()
      local output = vim.fn.expand("%:p:r")
      local escaped_output = vim.fn.shellescape(output)
      return "dotnet build " .. escaped_filename .. " && dotnet run"
    end,
    fsharp = function()
      return "dotnet fsi " .. escaped_filename
    end,

    -- Systems programming
    zig = "zig run " .. escaped_filename,
    nim = "nim compile --run " .. escaped_filename,
    crystal = "crystal run " .. escaped_filename,
    d = function()
      return "dmd -run " .. escaped_filename
    end,

    -- Functional languages
    haskell = "runhaskell " .. escaped_filename,
    ocaml = "ocaml " .. escaped_filename,
    elixir = "elixir " .. escaped_filename,
    erlang = function()
      local module = vim.fn.expand("%:t:r")
      local escaped_module = vim.fn.shellescape(module)
      return "erlc " .. escaped_filename .. " && erl -noshell -s " .. escaped_module .. " main -s init stop"
    end,

    -- Data science
    dart = "dart run " .. escaped_filename,
    jupyter = "jupyter nbconvert --execute --to notebook --inplace " .. escaped_filename,

    -- Configuration/markup languages that might be validated
    json = function()
      return "cat " .. escaped_filename .. " | jq '.' || echo 'Invalid JSON!'"
    end,
    yaml = function()
      return "yamllint " .. escaped_filename .. " || echo 'YAML validated!'"
    end,

    -- Build systems / task runners
    make = "make -f " .. escaped_filename,

    -- Frontend frameworks (for running development servers)
    vue = function()
      -- Assumes we're running from project root
      return "npm run serve"
    end,
    svelte = function()
      return "npm run dev"
    end,

    -- SQL (assuming you have sqlite or similar installed)
    sql = function()
      -- Default to running against SQLite; modify as needed
      return "sqlite3 :memory: < " .. escaped_filename
    end,
  }

  local command = commands[filetype]
  if command then
    if type(command) == "function" then
      return command()
    else
      return command
    end
  else
    return nil
  end
end

-- Function to run code
function M.run_code()
  local filetype = vim.bo.filetype
  local filename = vim.fn.expand("%:p")

  local command = M.get_command(filetype, filename)
  if not command then
    vim.notify("No run configuration for filetype: " .. filetype, vim.log.levels.WARN)
    return
  end

  -- Save current buffer
  vim.cmd("silent! write")

  -- Open Snacks terminal and run command
  vim.cmd("lua Snacks.terminal.open()")
  vim.api.nvim_input(command .. "<CR>")
end

-- Set up keymapping
vim.keymap.set({ "n", "i" }, "<F9>", function()
  M.run_code()
end, { desc = "Compile and run code" })

return M
