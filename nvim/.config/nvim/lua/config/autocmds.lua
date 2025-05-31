-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Create editor switcher
local function setup_editor_switcher()
  -- First check if we can load Snacks
  local ok, snacks = pcall(require, "snacks")
  if not ok or not snacks.picker then
    vim.notify("Snacks plugin with picker is required for editor switcher", vim.log.levels.ERROR)
    return false
  end

  -- Function to get the git root or fallback to current working directory
  local function get_project_root()
    -- Try to find the git root
    local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
    if vim.v.shell_error == 0 and git_root and git_root ~= "" then
      return git_root
    end
    -- Fallback to current working directory
    return vim.fn.getcwd()
  end

  -- Function to open current file and working directory in selected editor
  local function open_in_editor()
    -- Simple list of editors with display names
    local editor_list = {
      { text = "VS Code", cmd = "code" },
      { text = "Cursor", cmd = "cursor" },
      { text = "Zed Editor", cmd = "zeditor" },
      { text = "PyCharm", cmd = "pycharm" },
      { text = "Emacs", cmd = "emacs" },
      { text = "Sublime Text", cmd = "subl" },
    }

    -- Use Snacks.picker.pick with custom items
    Snacks.picker.pick({
      items = editor_list,
      title = "Select Editor",
      format = "text",
      layout = { preview = false },
      confirm = function(picker, item)
        if not item then
          return
        end

        local editor = item.cmd

        -- Get current buffer's full file path and quote it
        local file_path = vim.fn.expand("%:p")
        if file_path == "" then
          file_path = nil -- No file open, only open directory
        else
          -- Shell-escape the file path to handle spaces
          file_path = vim.fn.shellescape(file_path)
        end

        -- Get project root (git root or cwd)
        local project_root = vim.fn.shellescape(get_project_root())

        -- Build command based on editor
        local cmd
        if editor == "code" or editor == "cursor" then
          -- VS Code and Cursor: Open folder and file
          cmd = string.format("%s %s %s", editor, project_root, file_path or "")
        elseif editor == "emacs" then
          -- Emacs: Open file or directory
          cmd = string.format("%s %s %s", editor, file_path or "", project_root)
        elseif editor == "zeditor" then
          -- Zed: Open directory and file
          cmd = string.format("%s %s %s", editor, project_root, file_path or "")
        elseif editor == "subl" then
          -- Sublime Text: Open directory and file
          cmd = string.format("%s %s %s", editor, project_root, file_path or "")
        elseif editor == "pycharm" then
          -- PyCharm: Open directory and file
          cmd = string.format("%s %s %s", editor, project_root, file_path or "")
        else
          -- Default: Just open the file or directory
          cmd = string.format("%s %s", editor, file_path or project_root)
        end

        -- Execute command
        vim.fn.jobstart(cmd, { detach = true })

        -- Close the picker
        picker:close()
      end,
    })
  end

  -- Create a keymap to trigger the function when F5 is pressed
  vim.keymap.set("n", "<F5>", open_in_editor, { noremap = true, silent = true, desc = "Open in Editor" })

  return true
end

-- Set up the editor switcher
setup_editor_switcher()

--------------------------------------------------------------------------------------------

-- Use LazyVim's root utility for the Cursor shortcut
local Util = require("lazyvim.util")

-- Open current file/project in Cursor with better root detection
local function open_in_cursor()
  local file_path = vim.fn.expand("%:p")
  if file_path == "" then
    file_path = nil
  end

  local project_root = Util.root() -- <- the magic!
  local cmd
  if file_path then
    file_path = vim.fn.shellescape(file_path)
    cmd = string.format("cursor %s %s", vim.fn.shellescape(project_root), file_path)
  else
    cmd = string.format("cursor %s", vim.fn.shellescape(project_root))
  end

  vim.fn.jobstart(cmd, { detach = true })
end

-- Set keybinding globally for Cursor shortcut
vim.keymap.set("n", "<F6>", open_in_cursor, { noremap = true, silent = true, desc = "Open in Cursor" })
