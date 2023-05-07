
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
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close()}),
        ['<C-M>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
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

-- LSP setup
local lsp = require('lsp-zero').preset({
  name = 'minimal',
  set_lsp_keymaps = true,
  manage_nvim_cmp = true,
  suggest_lsp_servers = false,
})

lsp.nvim_workspace()

lsp.setup()


local dap, dapui = require("dap"), require("dapui")

dap.adapters.coreclr = {
    type = 'executable',
    command = '/home/grn/.local/share/nvim/mason/packages/netcoredbg/netcoredbg',
    args = {'--interpreter=vscode'}
}
dap.configurations.cs = {
  {
    type = "coreclr",
    name = "launch - netcoredbg",
    request = "launch",
    program = function()
        return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
    end,
  },
}

vim.api.nvim_set_keymap('n', '<F5>', "<Cmd>lua require'dap'.continue()<CR>", {silent = true})
vim.api.nvim_set_keymap('n', '<F10>', "<Cmd>lua require'dap'.step_over()<CR>", {silent = true})
vim.api.nvim_set_keymap('n', '<F11>', "<Cmd>lua require'dap'.step_into()<CR>", {silent = true})
vim.api.nvim_set_keymap('n', '<F12>', "<Cmd>lua require'dap'.step_out()<CR>", {silent = true})
vim.api.nvim_set_keymap('n', '<C-b>', "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", {silent = true})
vim.api.nvim_set_keymap('n', '<C-B>', "<Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", {silent = true})
vim.api.nvim_set_keymap('n', '<C-lp>', "<Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", {silent = true})
vim.api.nvim_set_keymap('n', '<C-dr>', "<Cmd>lua require'dap'.repl.open()<CR>", {silent = true})
vim.api.nvim_set_keymap('n', '<C-dl>', "<Cmd>lua require'dap'.run_last()<CR>", {silent = true})


dapui.setup({
  icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  -- Use this to override mappings for specific elements
  element_mappings = {
    -- Example:
    -- stacks = {
    --   open = "<CR>",
    --   expand = "o",
    -- }
  },
  -- Expand lines larger than the window
  -- Requires >= 0.7
  expand_lines = vim.fn.has("nvim-0.7") == 1,
  -- Layouts define sections of the screen to place windows.
  -- The position can be "left", "right", "top" or "bottom".
  -- The size specifies the height/width depending on position. It can be an Int
  -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
  -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
  -- Elements are the elements shown in the layout (in order).
  -- Layouts are opened in order so that earlier layouts take priority in window sizing.
  layouts = {
    {
      elements = {
      -- Elements can be strings or table with id and size keys.
        { id = "scopes", size = 0.25 },
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 40, -- 40 columns
      position = "left",
    },
    {
      elements = {
        "repl",
        "console",
      },
      size = 0.25, -- 25% of total lines
      position = "bottom",
    },
  },
  controls = {
    -- Requires Neovim nightly (or 0.8 when released)
    enabled = true,
    -- Display controls in this element
    element = "repl",
    icons = {
      pause = "",
      play = "",
      step_into = "",
      step_over = "",
      step_out = "",
      step_back = "",
      run_last = "↻",
      terminate = "□",
    },
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = "single", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil, -- Can be integer or nil.
    max_value_lines = 100, -- Can be integer or nil.
  }
})


dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end


-- Set tabs to 4 spaces
vim.o.tabstop=4
vim.o.shiftwidth=4
vim.o.expandtab=true

-- Disable swapfile
vim.cmd [[set noswapfile]]

-- Enable Unicode support
vim.o.encoding='utf-8'

-- Show line numbers
vim.o.number=true

-- Mouse disabling
vim.o.mouse=''

-- Enable mouse support
-- vim.o.mouse='a'

-- Enable syntax highlighting
vim.o.syntax='on'

-- Add a status line with file information
vim.o.laststatus=2

-- Set the default file format to Unix (LF line endings)
vim.o.fileformat='unix'

-- Add a trailing newline to files if one doesn't exist
vim.o.endofline=true

-- Enable highlighting of matching parentheses
vim.o.showmatch=true

-- Show the current mode (normal, insert, etc.) in the status line
vim.o.showmode=true

-- Enable incremental search
vim.o.incsearch=true

-- Enable case-insensitive search
vim.o.ignorecase=true
vim.o.smartcase=true
