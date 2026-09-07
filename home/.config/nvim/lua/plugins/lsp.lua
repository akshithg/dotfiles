return {
  -- LSP servers
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {},
        ts_ls = {},
        lua_ls = {},
      },
    },
  },

  -- Mason tools
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
      },
    },
  },

  -- TypeScript extras (sets up treesitter, mason, and lspconfig)
  { import = "lazyvim.plugins.extras.lang.typescript" },

  -- JSON extras (jsonls, schemastore, treesitter)
  { import = "lazyvim.plugins.extras.lang.json" },
}
