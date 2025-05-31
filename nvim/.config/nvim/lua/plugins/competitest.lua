return {
  "xeluxee/competitest.nvim",
  dependencies = "MunifTanjim/nui.nvim",
  config = function()
    require("competitest").setup({
      received_problems_path = "$(HOME)/Competitive Programming/$(JUDGE)/$(CONTEST)/$(PROBLEM).$(FEXT)",
      received_contests_directory = "$(HOME)/Competitive Programming/$(JUDGE)/$(CONTEST)",
      received_contests_problems_path = "$(PROBLEM)/main.$(FEXT)",
      received_problems_prompt_path = false,
    })
  end,
}
