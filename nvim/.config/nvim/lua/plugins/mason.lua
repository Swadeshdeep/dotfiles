-- ~/.config/nvim/lua/plugins/mason-tools.lua
-- Simple Mason tools installer for LazyVim with exclusion support
return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      local function list_to_set(list)
        local set = {}
        for _, item in ipairs(list) do
          set[item] = true
        end
        return set
      end

      local disabled_tools = {
        -- tools to disable
      }
      local disabled_set = list_to_set(disabled_tools)

      opts.ensure_installed = opts.ensure_installed or {}
      local existing_set = list_to_set(opts.ensure_installed)

      local my_tools = {
        -- language servers
        "bash-language-server",
        "clangd",
        "cmake-language-server",
        "css-lsp",
        "dockerfile-language-server",
        "gopls",
        "html-lsp",
        "json-lsp",
        "lua-language-server",
        "rust-analyzer",
        "svelte-language-server",
        "tailwindcss-language-server",
        "taplo",
        "typescript-language-server",
        "yaml-language-server",
        "sqls",
        -- debug adapters
        "codelldb",
        "js-debug-adapter",
        -- formatters/linters
        "cmakelang",
        "cmakelint",
        "prettier",
        "shellcheck",
        "shfmt",
        "stylua",
      }

      for _, tool in ipairs(my_tools) do
        if not disabled_set[tool] and not existing_set[tool] then
          table.insert(opts.ensure_installed, tool)
        end
      end
    end,
  },
}
