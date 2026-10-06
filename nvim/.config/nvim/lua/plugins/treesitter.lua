-- nvim-treesitter pinned to the master branch.
--
-- Deliberate: master is the legacy API, which builds parsers with gcc and stays
-- compatible with glibc 2.31. The `main` rewrite does not. Do not unpin this
-- without checking the glibc on the target machine first.
--
-- The language extras enabled in lazyvim.json append their own parsers to
-- ensure_installed on top of this list.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    version = false,
    pin = true,
    build = ":TSUpdate",
    event = { "VeryLazy" },
    cmd = { "TSUpdate", "TSInstall", "TSInstallInfo", "TSUninstall" },
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        "bash",
        "c",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "printf",
        "python",
        "query",
        "regex",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
