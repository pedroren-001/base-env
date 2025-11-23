vim.opt.backup = false
vim.opt.writebackup = false

vim.g.encoding = "UTF-8"
vim.o.fileencoding="UTF-8"
vim.o.fileencodings = "UTF-8"
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true

vim.wo.number = true
vim.opt.updatetime = 300
vim.opt.signcolumn = "yes"
vim.opt.clipboard = "unnamedplus"
vim.o.expandtab = true
vim.bo.expandtab = true

vim.opt.foldmethod='indent'
vim.opt.foldlevelstart=99 --不自动开启fold

-- 新行对齐当前行
vim.o.autoindent = true
vim.bo.autoindent = true
vim.o.smartindent = true
-- 搜索大小写不敏感，除非包含大写
vim.o.ignorecase = true
vim.o.smartcase = true
-- 搜索不要高亮
-- vim.cmd [[colorscheme codedark]]
-- vim.cmd [[
--     let &t_ZH="\e[3m"
--     let &t_ZR="\e[23m"
-- ]]
vim.cmd [[
    highlight Comment cterm=italic gui=italic
    " set mouse=
]]

-- Set the custom clipboard provider
-- Define the copy function
local function copy(lines, _)
  local text = table.concat(lines, '\n')
  local f = io.popen('pbcopy', 'w')
  if f == nil then
    vim.api.nvim_err_writeln('Failed to open pbcopy')
    return
  end
  f:write(text)
  local success, _, _ = f:close()
  if not success then
    vim.api.nvim_err_writeln('Failed to copy text to clipboard')
  end
end

local function paste()
  return {
    vim.fn.split(vim.fn.getreg(""), "\n"),
    vim.fn.getregtype(""),
  }
end

vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
  },
  paste = {
    ['+'] = paste,
    ['*'] = paste,
  },
}


-- jsonc support
vim.cmd [[
  autocmd FileType json syntax match Comment +\/\/.\+$+
]]

-- highligh current line (number only)
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.o.swapfile = false

vim.opt.shada = "!,'5000,<100,s10,h"

-- python3
vim.g.python3_host_prog = vim.fn.expand('~/.venv/bin/python')

-- relative number
-- vim.opt.relativenumber = true

-- 打开concel support
-- vim.opt.conceallevel = 2

-- vim.cmd [[
--     Copilot disable
-- - ]]


------------------------------------------------------------------ diagnostics systems -------------------------------------------------
diagnostics_opts = {
    virtual_text = true, -- Show diagnostics inline with the code
    signs = true,        -- Show icons in the sign column
    underline = true,    -- Underline the problematic code
    severity_sort = true, -- Sort by severity (errors first)
    float = {
        focusable = false,
        style = 'minimal',
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    },
}
vim.diagnostic.config(diagnostics_opts)

local qf_is_open = false
vim.keymap.set('n', '<leader>qw', function ()
    if qf_is_open then
        vim.cmd('cclose')
        qf_is_open = false
    else
        vim.diagnostic.setqflist()
        vim.cmd("copen") -- Open the quickfix window
        qf_is_open = true
    end
end
, { desc = 'Goto next coverage chunk' })

vim.keymap.set('n', '<leader>qf', function()
    if qf_is_open then
        vim.cmd('cclose')
        qf_is_open = false
        return
    end

    vim.diagnostic.setloclist({open=true})
    qf_is_open = true
end)

vim.api.nvim_create_autocmd("DiagnosticChanged", {
    callback = function()
        if qf_is_open then
            -- 如果quickfix窗口打开， 则更新quickfix内容
            vim.diagnostic.setloclist()
            return
        end
    end,
})


------------------------------------------------------------------------- end diagnostics systems -------------------------------------------------







