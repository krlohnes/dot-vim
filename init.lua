-- security
vim.o.exrc = false  -- ignore ~/.exrc
vim.o.secure = true  -- disallow local rc exec

-- tab / whitespace control
vim.o.expandtab = true  -- expand hard tabs to spaces
vim.o.softtabstop = 4  -- expand tabs to 4 spaces
vim.o.tabstop = 4  -- use 4 spaces for hard tabs

vim.api.nvim_create_autocmd("FileType", {
	pattern = "go",
	command = "setlocal noexpandtab tabstop=4"
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "sql",
	command = "setlocal noexpandtab tabstop=4"
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "proto",
	command = "setlocal softtabstop=2 shiftwidth=2 tabstop=2"
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = {"typescript,typescriptreact,javascript,lua"},
	command = "setlocal softtabstop=2 shiftwidth=2 tabstop=2"
})

-- formatting options
vim.o.autoindent = true
vim.o.shiftwidth = 4
vim.o.shiftround = true
vim.o.textwidth = 79
vim.opt.formatoptions = vim.opt.formatoptions
    + 't'
    + 'c'
    + 'r'
    - 'o'
    + 'q'
    - 'a'
    + 'n'
    - '2'
    + 'j'

-- display settings
vim.o.number = true
vim.o.ruler = true
vim.o.hidden = true
vim.o.hlsearch = true
vim.opt.listchars = {
    trail = '-',
    nbsp = '+',
    eol = '$',
    tab = '>-'
}
vim.opt.termguicolors = true
vim.opt.syntax = 'on'
vim.opt.laststatus = 2

-- windows
vim.o.splitbelow = true
vim.o.splitright = true

-- editing
vim.o.mouse = ''
vim.o.showmatch = true
vim.o.clipboard = 'unnamed,unnamedplus'
vim.o.undofile = true
vim.o.undodir = vim.env.HOME .. '/.vim/undodir'
vim.o.backspace = 'indent,eol,start'

-- spelling
-- set spell to activate
vim.o.spelllang = 'en_us'

---- remap O and o to not leave things in insert mode
vim.api.nvim_set_keymap('n', 'O', 'O<esc>', {noremap = true})
vim.api.nvim_set_keymap('n', 'o', 'o<esc>', {noremap = true})

---- remap C-n to manual completion
vim.api.nvim_set_keymap('n', '<C-n>', '<C-X><C-O>', {noremap = true})

-- Use ctrl-[hjkl] to select the active split
vim.api.nvim_set_keymap('n', '<C-k>', ':wincmd k<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-j>', ':wincmd j<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-h>', ':wincmd h<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', ':wincmd l<CR>', { noremap = true, silent = true })

---- map C-R to rename

-- disable unused providers to speed up start up
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

--Remap Jump To Tag
vim.keymap.set("n", "<F2>", "<C-]>", { noremap = true })
vim.keymap.set("n", "<F3>", "<cmd>Telescope lsp_references<cr>", { noremap = true })
vim.keymap.set("n", "<F14>", "<C-w><C-]><C-w>T", { noremap = true, silent = true })
vim.keymap.set('n', '<F4>', vim.lsp.buf.rename, {noremap = true})
vim.keymap.set('n', '<F5>', vim.diagnostic.open_float, {noremap = true})

vim.fn.setreg('t', "%s/\\s\\+$//e")


-- plugins
vim.cmd('packadd paq-nvim')
local paq = require('paq').paq

paq({'savq/paq-nvim', opt=true})

paq({'nvim-treesitter/nvim-treesitter'})
require('nvim-treesitter.configs').setup({
    folding = {enable = true},
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false
    },
    incremental_selection = {enable = true},
    ensure_installed = {
        'bash',
        'c',
        'comment',
        'cpp',
        'devicetree',
        'diff',
        'disassembly',
        'dockerfile',
        'editorconfig',
        'git_rebase',
        'gitcommit',
        'gitignore',
        'go',
        'groovy',
        'javascript',
        'json',
        'kconfig',
        'latex',
        'lua',
        'make',
        'markdown',
        'markdown_inline',
        'meson',
        'ninja',
        'passwd',
        'pem',
        'perl',
        'promql',
        'proto',
        'python',
        'query',
        'regex',
        'rust',
        'ssh_config',
        'strace',
        'toml',
        'udev',
        'vim',
        'xml',
        'yaml'
    }
})
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
vim.o.foldenable = false

paq({'norcalli/nvim-colorizer.lua'})
require('colorizer').setup()

paq({'marko-cerovac/material.nvim'})
require('material').setup({
    custom_colors = require('custom-material-colors').colors,
    style = 'darker'
})
vim.cmd([[colorscheme material]])
paq({"pmizio/typescript-tools.nvim"})
require("typescript-tools").setup ({
    on_attach =
        function(client, bufnr)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
        end,
    settings = {
        jsx_close_tag = {
            enable = true,
            filetypes = { "javascriptreact", "typescriptreact" },
        }
    }
})

paq({'kyazdani42/nvim-web-devicons', opt = true})
paq({'nvim-lualine/lualine.nvim'})
require('lualine').setup({
    options = {theme = 'material'},
    sections = {
        lualine_y = {
            {'diagnostics', sources = {'nvim_diagnostic'}}
        }
    }
})

paq({'lukas-reineke/lsp-format.nvim'})

local default_parallelism = vim.uv.available_parallelism()

paq({'neovim/nvim-lspconfig'})
local lspconfig = require('lspconfig')
lspconfig.clangd.setup({
    cmd = {
        'clangd',
        '--background-index',
        '-j', math.min(1, default_parallelism / 2),
        '--limit-results=20000',
        '--limit-references=20000'
    }
})

lspconfig.rust_analyzer.setup({
    on_attach = require("lsp-format").on_attach,
    settings = {
      ['rust-analyzer'] = {
         cargo = {
            buildscripts = {
                enable = true,
            },
            procMacro = {
                enable = true,
            },
         },
         diagnostics = {
           enabled = true,
           refreshSupport = true,
         },
         check = {
           command = "clippy",
         },
      },
   }
})

lspconfig.gopls.setup({
    settings = {
        gopls = {
            staticcheck = true
        }
    }
})

paq({'hrsh7th/nvim-cmp'})
paq({'tpope/vim-fugitive'})
paq({'godlygeek/tabular'})
paq({'martinda/Jenkinsfile-vim-syntax'})
paq({'glench/vim-jinja2-syntax'})

paq({'nvim-lua/popup.nvim'})
paq({'nvim-lua/plenary.nvim'})
paq({'nvim-telescope/telescope.nvim'})
paq({'/usr/local/opt/fzf'})
paq({'junegunn/fzf.vim'})
paq({'junegunn/fzf'})

-- miscellaneous
vim.g.vimpager_scrolloff = 0

-- use real tabs in Makefiles and Kconfig
local expand_tabs_override_augroup = vim.api.nvim_create_augroup(
    'ExpandTabsOverride',
    {clear = true}
)
vim.api.nvim_create_autocmd(
    'FileType',
    {
        group = expand_tabs_override_augroup,
        pattern = {'make', 'kconfig'},
        callback = function()
            vim.opt_local.expandtab = false
        end
    }
)

-- detect files named Config.in as Kconfig
local detect_config_in_as_kconfig_augroup = vim.api.nvim_create_augroup(
    'DetectConfigInAsKconfig',
    {clear = true}
)
vim.api.nvim_create_autocmd(
    {'BufNewFile', 'BufRead'},
    {
        group = detect_config_in_as_kconfig_augroup,
        pattern = 'Config.in',
        callback = function()
            vim.opt_local.filetype = 'kconfig'
        end
    }
)
vim.g.fzf_layout = {
    window = '-tabnew'
}
vim.g.fzf_action = { enter = 'tab split' }

paq({'hrsh7th/nvim-cmp'})
paq({'hrsh7th/cmp-nvim-lsp'})
paq({'saadparwaiz1/cmp_luasnip'})
paq({'L3MON4D3/LuaSnip'})
paq({'tpope/vim-abolish'})

paq({'b0o/schemastore.nvim'})

-- Add additional capabilities supported by nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local lspconfig = require('lspconfig')

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = { 'clangd', 'rust_analyzer', 'pyright', 'ts_ls', 'gopls' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    capabilities = capabilities,
  }
end

capabilities.textDocument.completion.completionItem.snippetSupport = true
lspconfig.jsonls.setup {
  capabilities = capabilities,
  settings = {
    json = {
      schemas = require('schemastore').json.schemas({
        select = {"rssdconfig.json", "rssdrules.json", "rssar.json"},
        extra = {
          {
            description = "RunSecurity Sensitive Data Rules Schema",
            fileMatch = {"rssdrules.json", "*.rssdrules.json"},
            name = "rssdrules.json",
            url = "/home/keith/projects/runsecurity/analyzer/resource/sensitive_data_rules/sensitive_data_rules_schema.json",
          },
          {
            description = "RunSecurity Sensitive Data Rule Configuration Schema",
            fileMatch = {"rssdconfig.json", "*.rssdconfig.json"},
            name = "rssdconfig.json",
            url = "/home/keith/projects/runesecurity/analyzer/resource/sensitive_data_rules/sensitive_data_config_schema.json",

          },
          {
            description = "RunSecurity Api Analyzer Rules",
            fileMatch = {"rssar.json", "*.rssar.json"},
            name = "rssar.json",
            url = "/home/keith/projects/runsecurity/analyzer/resource/api_analyzer_rules/api_analyzer_rules_schema.json",

          },
        }
      }),
      validate = { enable = true },
    },
  },
}

require('lspconfig').yamlls.setup {
  settings = {
    yaml = {
      schemaStore = {
        -- You must disable built-in schemaStore support if you want to use
        -- this plugin and its advanced options like `ignore`.
        enable = false,
        -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
        url = "",
      },
      schemas = require('schemastore').yaml.schemas(),
    },
  },
}

-- Format before save
vim.api.nvim_create_augroup('AutoFormatting', {})
vim.api.nvim_create_autocmd('BufWritePre', {
  group = 'AutoFormatting',
  callback = function()
    vim.lsp.buf.format()
  end,
})

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
    ['<C-d>'] = cmp.mapping.scroll_docs(4), -- Down
    -- C-b (back) C-f (forward) for snippet placeholder navigation.
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

vim.api.nvim_create_autocmd("FileType", {
	pattern = "sql",
	command = "setlocal noexpandtab tabstop=4"
})
