-- Install Packer plugin manager if not installed
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.api.nvim_command 'packadd packer.nvim'
end

-- Load settings
require('settings')

-- Install and configure plugins using Packer
return require('packer').startup(function()
    -- Packer manages itself
    use 'wbthomason/packer.nvim'

    -- MasonLSP
    use {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim"}

    -- File explorer
    use 'kyazdani42/nvim-tree.lua'

    -- Status line
    use 'hoob3rt/lualine.nvim'

    -- Git integration
    use 'tpope/vim-fugitive'

    -- LSP zero
    use 'VonHeikemen/lsp-zero.nvim'

    -- LSPkind (icons)
    use 'onsails/lspkind.nvim'

    -- Autocompletion
    use {'hrsh7th/nvim-cmp'}
    use {'hrsh7th/cmp-buffer'}
    use {'hrsh7th/cmp-nvim-lsp'}

    -- Language server protocol
    use 'neovim/nvim-lspconfig'
    use 'nvim-lua/lsp-status.nvim'

    -- Commenting
    use 'tpope/vim-commentary'

    -- OmniSharp integration
    use { 'OmniSharp/omnisharp-roslyn' }

    -- F# autocompletion
    use 'fsharp/FsAutoComplete'

    -- Lua autocompletion
    use 'LuaLS/lua-language-server'

end)

