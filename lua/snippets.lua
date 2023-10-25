-- Load the cmp plugin
local cmp = require('cmp')

-- Configure cmp
cmp.setup({
  -- Enable autocompletion
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end
  },

  -- Use the nvim-cmp completion engine
  completion = {
    completeopt = 'menu,menuone,noinsert',
    -- You may need to adjust this path depending on where you installed nvim-cmp
    autocomplete = {
      enable = true,
      keyword_length = 2,
      trigger_keyword_length = 2,
      keyword_pattern = "\\k+",
      max_item_count = 5,
      -- Use the nvim-cmp completion engine
      engine = 'nvim-cmp'}},
  mapping = {
        ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
        ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<C-y>'] = cmp. config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close()}),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'buffer' }
  },
    formatting = {
        format = function(entry, vim_item)
            if vim.tbl_contains({ 'path' }, entry.source.name) then
                local icon, hl_group = require('nvim-web-devicons').get_icon(entry:get_completion_item().label)
                if icon then
                    vim_item.kind = icon
                    vim_item.kind_hl_group = hl_group
                    return vim_item
                end
            end
            return require('lspkind').cmp_format({ with_text = true })(entry, vim_item)
        end
    }
})

