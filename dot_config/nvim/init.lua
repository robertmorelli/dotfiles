-- Auto-install Packer if missing
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd("packadd packer.nvim")
  end
end
ensure_packer()

-- Plugins
require("packer").startup(function(use)
  use "wbthomason/packer.nvim"
  use "tombh/novim-mode"
  use "nvim-tree/nvim-tree.lua"
  use "ellisonleao/gruvbox.nvim"
  use "nvim-lualine/lualine.nvim"
  use "nvim-treesitter/nvim-treesitter"
  use "marko-cerovac/material.nvim"
  use "jeffkreeftmeijer/vim-dim"
  use 'hrsh7th/nvim-cmp'          -- The completion engine
use 'hrsh7th/cmp-nvim-lsp'      -- LSP source for nvim-cmp
use 'hrsh7th/cmp-buffer'        -- Buffer completions
use 'saadparwaiz1/cmp_luasnip'  -- Snippet completions
use 'L3MON4D3/LuaSnip'          -- Snippet engine
    use {
    "neovim/nvim-lspconfig",
    config = function()
      require'lspconfig'.zls.setup{}
    end
  }
  use {
  "supermaven-inc/supermaven-nvim",
  config = function()
    require("supermaven-nvim").setup({})
  end,
}
end)
vim.o.termguicolors = false  -- Use terminal colors
vim.o.background = "dark"     -- Or "light" depending on preference
vim.cmd("colorscheme dim")

-- Novim Mode
-- vim.g.novim_mode = true
-- vim.o.termguicolors = false  -- Disable GUI colors, use terminal colors
-- vim.o.background = "dark"     -- Or "light", depending on your terminal theme
-- vim.cmd("colorscheme default") -- Ensure it sticks to terminal colors

-- UI Enhancements
-- vim.o.termguicolors = true
-- vim.g.material_style = "lighter" -- Options: darker, lighter, oceanic, palenight, deep ocean
-- require("material").setup()
-- vim.cmd("colorscheme material")
-- vim.o.termguicolors = false  -- Use terminal colors
-- -- vim.o.t_Co = "256"           -- Enable 256-color mode
-- vim.cmd("colorscheme default") -- Stick to terminal colors
require("lualine").setup()
require("nvim-tree").setup()



-- Keybindings
vim.api.nvim_set_keymap("n", "<D-b>", ":NvimTreeToggle<CR>", { noremap = false, silent = true })
vim.api.nvim_set_keymap("i", "<D-b>", "<Cmd>NvimTreeToggle<CR>", { noremap = false, silent = true })
vim.api.nvim_set_keymap("i", "<C>", "<Esc>", { noremap = false, silent = true })

vim.api.nvim_set_keymap("i", "<C-c>", "<Esc>", { noremap = false, silent = true })
vim.api.nvim_set_keymap("i", "<D-s>", "<Cmd>:w<Cr>", { noremap = false, silent = true })

vim.api.nvim_set_keymap("n", "<Del>", "x", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<Del>", "<Del>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("i", "<M-BS>", "<C-w>", { noremap = true, silent = true }) -- macOS: Option+Delete
vim.api.nvim_set_keymap("i", "<A-BS>", "<C-w>", { noremap = true, silent = true }) -- Linux: Alt+Delete

vim.api.nvim_set_keymap("i", "<D-BS>", "<C-u>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("v", "<D-BS>", "d", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<D-BS>", "<C-u>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("i", "<D-z>", "<Cmd>u<CR>", { noremap = true, silent = true })
-- vim.cmd("command! Vld execute 'normal! Vd'")
-- -- vim.api.nvim_set_keymap("v", "<D-5>", "<Cmd>Vld<CR>", { noremap = false, silent = false })
-- -- vim.api.nvim_set_keymap("n", "<D-5>", "<Cmd>Vld<CR>", { noremap = false, silent = false })
-- -- vim.api.nvim_set_keymap("i", "<D-5>", "<Cmd>Vld<CR>", { noremap = false, silent = false })
-- -- vim.api.nvim_set_keymap("v", "<D-5>", ":Vld", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("v", "<D-5>", "<Esc>:Vld<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<D-5>", ":Vld<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("i", "<D-5>", "<Esc>:Vld<CR>", { noremap = true, silent = true })
-- Auto-update Plugins
vim.cmd([[
  augroup PackerAutoCompile
    autocmd!
    autocmd BufWritePost init.lua source <afile> | PackerSync
  augroup END
]])

-- Setup nvim-cmp for autocompletion
local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  })
})

-- Setup LSP servers for Rust and Zig
local lspconfig = require('lspconfig')

-- Rust LSP (rust-analyzer)
lspconfig.rust_analyzer.setup({
  settings = {
    ["rust-analyzer"] = {}
  }
})

-- Zig LSP (zls)
lspconfig.zls.setup({})



require("supermaven-nvim").setup({
  keymaps = {
    accept_suggestion = "<Tab>",
    clear_suggestion = "<C-]>",
    accept_word = "<C-j>",
  },
  ignore_filetypes = { "txt" }, -- or { "cpp", }
    suggestion_color = "#112233",
    cterm = 30,
  log_level = "info", -- set to "off" to disable logging completely
  disable_inline_completion = false, -- disables inline completion for use with cmp
  disable_keymaps = false, -- disables built in keymaps for more manual control
  condition = function()
    return false
  end -- condition to check for stopping supermaven, `true` means to stop supermaven when the condition is true.
})