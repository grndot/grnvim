-- Load the cmp plugin
local cmp = require('cmp')

-- Configure cmp keymaps
local cmp_keymap = {
  ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
  ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
  ['<C-Space>'] = cmp.mapping.complete(),
  ['<CR>'] = cmp.mapping.confirm({
    behavior = cmp.ConfirmBehavior.Replace,
    select = true,
  }),
}

-- Set up the nvim-cmp keymap
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  completion = {
    completeopt = 'menu,menuone,noinsert',
    keyword_length = 2,
    trigger_keyword_length = 2,
    keyword_pattern = "\\k+",
    max_item_count = 5,
    mapping = cmp_keymap,
    sources = {
      { name = 'nvim_lsp' },
      { name = 'path' },
      { name = 'buffer' },
    },
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
    },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'buffer' },
  },
})

