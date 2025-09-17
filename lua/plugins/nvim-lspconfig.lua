return {
    'neovim/nvim-lspconfig',
    events = 'LazyFile',
    ft = { 'c', 'cpp', 'rust', 'typescript', 'go' },
    opts = {
      inlay_hints = {enabled = true},
    },
    config = function()
        local lspconfig = require('lspconfig')
        local default_parallelism = vim.uv.available_parallelism()
        lspconfig.basedpyright.setup({
          settings = {
            basedpyright = {
              analysis = {
                diagnosticMode = "openFilesOnly",
                inlayHints = {
                  callArgumentNames = true
                }
              }
            }
          }
        })
        lspconfig.clangd.setup({
            cmd = {
                'clangd',
                '--background-index',
                '-j', math.max(1, default_parallelism / 2),
                '--limit-results=20000',
                '--limit-references=20000'
            }
        })
        lspconfig.gopls.setup {
            {
                settings = {
                    gopls = {
                        staticcheck = true
                    }
                }
            }
        }
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
    end
}
