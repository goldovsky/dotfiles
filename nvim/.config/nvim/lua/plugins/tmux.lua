-- Seamless C-h/j/k/l movement between nvim splits and tmux panes.
--
-- The tmux half has been installed for a while (christoomey/vim-tmux-navigator
-- in tmux/.config/tmux/plugins.tmux); this is the nvim half it expects. Without
-- it tmux intercepts the keys but nvim never cooperates, so the motion stops
-- dead at the first nvim split.
return {
  "christoomey/vim-tmux-navigator",
  -- The commands must exist before the keys are pressed, and lazy.nvim can load
  -- the plugin on first use of either.
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
  },
  keys = {
    { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Go to left window/pane" },
    { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Go to lower window/pane" },
    { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Go to upper window/pane" },
    { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Go to right window/pane" },
  },
}
