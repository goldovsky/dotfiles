-- Colorscheme.
--
-- cobalt.nvim is the nvim counterpart of the terminal palette. Note the rest of
-- the stack (alacritty/tmux/starship) is generated from the `nuxt` preset by
-- shell/common/themes/generate-colors.sh, which has no nvim target — so this
-- has to be kept in sync by hand.
return {
  { "wurli/cobalt.nvim" },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "cobalt",
    },
  },
}
