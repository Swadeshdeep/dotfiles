-- Function to compile and run code based on file type
local function compile_and_run()
  -- Get the current file path and name
  local current_file = vim.fn.expand("%:p")
  local file_name = vim.fn.expand("%:r")
  local file_ext = vim.fn.expand("%:e")
  -- Define commands for different languages
  local commands = {
    cpp = {
      ext = "cpp",
      cmd = string.format("g++ -std=c++17 -Wall -Wextra -o %s %s && ./%s", file_name, current_file, file_name),
      title = "C++ Compile & Run",
    },
    c = {
      ext = "c",
      cmd = string.format("gcc -Wall -Wextra -o %s %s && ./%s", file_name, current_file, file_name),
      title = "C Compile & Run",
    },
    python = {
      ext = "py",
      cmd = string.format("python3 %s", current_file),
      title = "Python Run",
    },
    java = {
      ext = "java",
      cmd = string.format("javac %s && java %s", current_file, file_name),
      title = "Java Compile & Run",
    },
    javascript = {
      ext = "js",
      cmd = string.format("node %s", current_file),
      title = "JavaScript Run",
    },
    go = {
      ext = "go",
      cmd = string.format("go run %s", current_file),
      title = "Go Run",
    },
    rust = {
      ext = "rs",
      cmd = string.format("rustc %s -o %s && ./%s", current_file, file_name, file_name),
      title = "Rust Compile & Run",
    },
  }
  -- Find the appropriate language settings
  local lang_settings = nil
  for _, settings in pairs(commands) do
    if file_ext == settings.ext then
      lang_settings = settings
      break
    end
  end
  -- Notify if file type not supported
  if not lang_settings then
    vim.notify("Unsupported file type: " .. file_ext, vim.log.levels.WARN, {
      title = "Compilation Error",
    })
    return
  end
  -- Two-step simulation to prevent Ctrl+Return
  vim.defer_fn(function()
    -- First, simulate Ctrl+/ to input the command
    local ctrl_slash_cmd = string.format("wtype -M ctrl -k slash -m ctrl")
    os.execute(ctrl_slash_cmd)
  end, 50)

  vim.defer_fn(function()
    -- Add a small delay
    os.execute("sleep 0.17")
  end, 100)

  vim.defer_fn(function()
    -- Then, simulate typing the command with a delay
    local cmd_type_cmd = string.format("wtype '%s'", lang_settings.cmd)
    os.execute(cmd_type_cmd)
  end, 100)

  vim.defer_fn(function()
    -- Then, simulate a clean Return key press without Ctrl
    os.execute("wtype -k Return")
  end, 100)

  -- Notify about the command being sent
  vim.notify("Command sent for " .. file_ext .. " file", vim.log.levels.INFO, {
    title = lang_settings.title,
  })
end
-- Expose the function globally
_G.compile_and_run = compile_and_run
-- Set the keymap
vim.api.nvim_set_keymap("n", "<F10>", "<cmd>lua compile_and_run()<CR>", { noremap = true, silent = true })

-- for running c++ programms
local function compile_and_run_cpp()
  -- Get the current file path and name
  local current_file = vim.fn.expand("%:p")
  local file_name = vim.fn.expand("%:r")
  -- Check if the file is a C++ source file
  if not current_file:match("%.cpp$") then
    vim.notify("Not a C++ file", vim.log.levels.WARN, {
      title = "Compilation Error",
    })
    return
  end
  -- Two-step simulation to prevent Ctrl+Return
  vim.defer_fn(function()
    -- First, simulate Ctrl+/ to input the command
    local ctrl_slash_cmd = string.format("wtype -M ctrl -k slash -m ctrl")
    os.execute(ctrl_slash_cmd)
  end, 50)

  vim.defer_fn(function()
    -- Add a small delay
    os.execute("sleep 0.3")
  end, 100)

  vim.defer_fn(function()
    -- Then, simulate typing the command with a delay
    local cmd = string.format("g++ -std=c++17 -Wall -Wextra -o %s %s && ./%s", file_name, current_file, file_name)
    local cmd_type_cmd = string.format("wtype '%s'", cmd)
    os.execute(cmd_type_cmd)
  end, 100)

  vim.defer_fn(function()
    -- Then, simulate a clean Return key press without Ctrl
    os.execute("wtype -k Return")
  end, 100)

  -- Optional: Notify about the command being sent
  vim.notify("Compilation and run command sent", vim.log.levels.INFO, {
    title = "C++ Compile & Run",
  })
end
-- Expose the function globally
_G.compile_and_run_cpp = compile_and_run_cpp
-- Set the keymap
vim.api.nvim_set_keymap("n", "<F11>", "<cmd>lua compile_and_run_cpp()<CR>", { noremap = true, silent = true })

------------------------------------------------------------------
