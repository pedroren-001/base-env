vim.g.mapleader = ","
vim.g.maplocalleader = ","
local map = vim.api.nvim_set_keymap
local opt = { noremap = true, silent = true }

-- 小快捷键
map("i", "<leader>s", "<esc>:w<CR>", opt)
map("n", "<leader>s", "<esc>:w<CR>", opt)
-- map("n", "<leader>a", "ggvG", opt)

-- 连续缩进
map("v", "<", "<gv", opt)
map("v", ">", ">gv", opt)

-- 快速进入normal模式
map("i", "jk", "<Esc>", opt)

-- 文件快速检索
map("n", "<leader>f", "<esc>:FzfLua files<CR>", opt)
map("n", "<leader>r", "<esc>:Telescope live_grep<CR>", opt)

-- map("n", "<leader>q", "<esc>:Telescope treesitter theme=get_dropdown<CR>", opt)
map("n", "<leader>q", "<esc>:BTags<CR>", opt)
map("n", "<leader>a", "<esc>:FzfLua marks<CR>", opt)
map("n", "<leader><tab>", "<esc>:FzfLua oldfiles<CR>", opt)
map("n", "<leader><space>", "<esc>:BLines<CR>", opt)
map("n", "<leader>w", "<esc>:Buffers<CR>", opt)
map("n", "<leader>e", ":<C-u>FzfLua lsp_live_workspace_symbols<CR>", opt)
map("n", "<leader>z", "<esc>:Telescope projects<CR>", opt)
map("n", "<leader>x", "<esc>:Neotree float<CR>", opt)

-- map("n", "<C-k>", "<C-Up>", opt)
-- map("n", "<C-j>", "<C-Down>", opt)

-- visual-multi mapping

vim.cmd [[
let g:VM_maps = {}
let g:VM_maps['Find Under']         = '<C-n>'           " replace C-n
let g:VM_maps['Find Subword Under'] = '<C-n>'           " replace visual C-n
let g:VM_maps["Select Cursor Down"] = '<C-j>'           " start selecting down
let g:VM_maps["Select Cursor Up"]   = '<C-k>'           " start selecting up
]]


-- barbar.nvim
-- map("n", "gt", "<esc>:BufferNext<CR>", opt)
-- map("n", "gT", "<esc>:BufferPrevious<CR>", opt)
-- map("n", "<leader>1", "<esc>:BufferGoto 1<CR>", opt)
-- map("n", "<leader>2", "<esc>:BufferGoto 2<CR>", opt)
-- map("n", "<leader>3", "<esc>:BufferGoto 3<CR>", opt)
-- map("n", "<leader>4", "<esc>:BufferGoto 4<CR>", opt)
-- map("n", "<leader>5", "<esc>:BufferGoto 5<CR>", opt)
-- map("n", "<leader>6", "<esc>:BufferGoto 6<CR>", opt)


-- fold
map("n", "<space>", "za", opt)

-- 用了conform.nvim 来做format
-- format
-- map("x", "<leader>ff", "<Plug>(coc-format-selected)", opt)
-- map("n", "<leader>ff", "<Plug>(coc-format-selected)", opt)

-- 全局的终端
function Newtermintab()
  local input_opts = {
      prompt  = "terminal name:",
      default = string.format("t-%s", os.date("%H-%M-%S"))
  }
  local term_func = function(input)
      if input == nil then
          return
      end
      if input == '' then
          vim.notify("input is empty", vim.log.levels.ERROR)
          input = string.format("t-%s", os.date("%H-%M-%S"))
      end
      vim.cmd('tabnew')
      vim.cmd('terminal')
      vim.cmd('file ' .. input)
      -- 调成insert模式
      vim.cmd('startinsert')
  end
  vim.ui.input(input_opts, term_func)
end
map("n", "<leader>t", "<esc>: lua Newtermintab()<cr>", opt)


-- Function to handle smart pane and tab navigation in Neovim
function NavigatePaneOrTab(direction)
  local current_win = vim.fn.winnr()  -- Get the current window number
  local panes       = vim.fn.winnr('$')      -- Total number of panes
  local tabs        = vim.fn.tabpagenr('$')   -- Total number of tabs
  local buffers     = vim.api.nvim_list_bufs() -- Total number of buffers

  -- 优先移动pane
  if panes > 1 then
      -- Check if moving in the specified direction keeps us in the same pane
      vim.cmd('wincmd ' .. direction)
      if vim.fn.winnr() ~= current_win then
          return 
      end
  end

  -- 移动buffer
  if direction == 'h' or direction == 'k' then
      vim.cmd('tabprevious')
  elseif direction == 'l' or direction == 'j' then
      vim.cmd('tabnext')
  end
end

-- alt+hjkl来切换对应的pane
map('n', '<M-h>', ":lua NavigatePaneOrTab('h')<CR>", opt)
map('n', '<M-j>', ":lua NavigatePaneOrTab('j')<CR>", opt)
map('n', '<M-k>', ":lua NavigatePaneOrTab('k')<CR>", opt)
map('n', '<M-l>', ":lua NavigatePaneOrTab('l')<CR>", opt)

-- 在终端模式中使用 Alt + h/j/k/l 切换窗口
map('t', '<M-h>', [[<C-\><C-n><C-w>h]], opt)
map('t', '<M-j>', [[<C-\><C-n><C-w>j]], opt)
map('t', '<M-k>', [[<C-\><C-n><C-w>k]], opt)
map('t', '<M-l>', [[<C-\><C-n><C-w>l]], opt)

-- 翻译
map('v', '<C-T>', '<esc>:<C-u>Ydv<CR>', opt)
map('n', '<C-T>', '<esc>:<C-u>Ydc<CR>', opt)
map('n', '<leader>yd', '<esc>:<C-u>Yde<CR>', opt)

-- SSH拷贝和粘贴, 已经不需要了，可以看一下options.lua里面的配置了
-- map('v', '<leader>c', '<Plug>OSCYankVisual', opt)


-- 在终端模式中使用 Alt + n 切换到 Normal 模式
map('t', '<M-n>', [[<C-\><C-n>]], opt)

-- 使用CTRL-F 在编辑模式下粘贴
map('i', '<C-f>', '<C-r>"', opt)
map('n', '<C-p>', '"0p', opt)



-- 使用alt+方向键调整pane的大小
map('i', '<M-Up>', '<esc>:resize +2<CR>', opt)
map('i', '<M-Down>', '<esc>:resize -2<CR>', opt)
map('i', '<M-Left>', '<esc>:vertical resize -2<CR>', opt)
map('i', '<M-Right>', '<esc>:vertical resize +2<CR>', opt)

map('n', '<M-Up>', '<esc>:resize +2<CR>', opt)
map('n', '<M-Down>', '<esc>:resize -2<CR>', opt)
map('n', '<M-Left>', '<esc>:vertical resize -2<CR>', opt)
map('n', '<M-Right>', '<esc>:vertical resize +2<CR>', opt)

map('n', '<M-d>', ':lua MiniDiff.toggle_overlay()<CR>', opt)
map('i', '<M-d>', '<esc>:lua MiniDiff.toggle_overlay()<CR>', opt)

-- 使用alt+x alt+v 打开FZF的文件
vim.g.fzf_action = {
  ['ctrl-x'] = 'split', -- Change `ctrl-s` to horizontal split
  ['ctrl-t'] = 'tabedit', -- Open in a new tab
  ['alt-v'] = 'vsplit', -- Use `Alt-v` for vertical split
}

-- alt-b打开Blame模式
map('i', '<M-b>', '<esc>:BlameToggle<CR>', opt)
map('n', '<M-b>', '<esc>:BlameToggle<CR>', opt)


-- 使用ctrl+o可以执行一个命令模式的命令
-- sss

-- 定义 Reload 函数，用于重新加载配置文件
function _G.ReloadConfig()
    -- 重启 Neovim
    -- 清除已加载的 Lua 模块缓存
    for name,_ in pairs(package.loaded) do
        if name:match('^user') or name:match('^plugins') then
            package.loaded[name] = nil
        end
    end

    -- 重新加载 init.lua
    dofile(vim.fn.stdpath('config') .. '/init.lua')
    print("Configuration Reloaded!")
end

-- neo-test
-- Neotest
vim.keymap.set('n', '<leader>tn', function()
  require('neotest').run.run()
end, { desc = 'Run nearest test in the file' })

vim.keymap.set('n', '<leader>tt', function()
  require('neotest').run.run(vim.fn.expand '%')
end, { desc = 'Run all the tests in the file' })

vim.keymap.set('n', '<leader>to', function()
  require('neotest').output.open { enter = true }
end, { desc = 'output.open' })

vim.keymap.set('n', '<leader>ts', function()
  require('neotest').summary.toggle()
end, { desc = 'summary_toggle' })

vim.keymap.set('n', '<leader>tw', function()
  require('neotest').watch.watch()
end, { desc = 'watch current test for changes' })

vim.keymap.set('n', '<leader>tc', function()
  require('neotest-lua.cov').toggle_cov_highlight()
  require('neotest-lua.livelog').clear_all_livelog()
end, { desc = 'clear lua cov' })


vim.keymap.set('n', '<leader>tf', function()
  require('neotest-lua.livelog').open_file_log()
end, { desc = 'clear lua cov' })

-- map ctrl-l to clear search highlight and <leader> tc
vim.keymap.set('n', '<C-l>', function()
    
    -- bypass
    require('neotest-lua.cov').toggle_cov_highlight()
    require('neotest-lua.livelog').clear_all_livelog()
    vim.cmd('noh')
end, { desc = 'Clear search highlight' })

-- map [c to previous coverage chunk
vim.keymap.set('n', '[c', function()
  require('neotest-lua.cov').prev_cov_chunk()
end, { desc = 'Goto previous coverage chunk' })

-- map ]c to next coverage chunk
vim.keymap.set('n', ']c', function()
  require('neotest-lua.cov').next_cov_chunk()
end, { desc = 'Goto next coverage chunk' })

vim.keymap.set('x', '/', '<Esc>/\\%V')

-- ]g and [g map to next diagnostics
vim.keymap.set('n', ']g', function()
  vim.diagnostic.goto_next()
end, { desc = 'Go to next diagnostic message' })

vim.keymap.set('n', '[g', function()
  vim.diagnostic.goto_prev()
end, { desc = 'Go to previous diagnostic message' })


-- rename
-- vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {
--     desc = 'LSP: [R]e[n]ame symbol'
-- })
vim.keymap.set('n', '<leader>ca', function() require("tiny-code-action").code_action(
) end,{ desc = 'LSP: Code Action' })
-- range code action with builtin lsp

vim.keymap.set('x', '<leader>ca', function() vim.lsp.buf.code_action({
}) end,{ desc = 'LSP: Code Action' })

vim.keymap.set('v', '<leader>ca', function() vim.lsp.buf.code_action({
}) end,{ desc = 'LSP: Code Action' })

-- codelens
vim.keymap.set('n', '<leader>cl', vim.lsp.codelens.run, {
    desc = 'LSP: [C]ode[L]ens Action'
})

vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {
    desc = 'LSP: Go to Definition'
})

-- gd. use Glance to preview definition
vim.keymap.set('n', 'gD', '<cmd>Glance definitions<cr>', {
    desc = 'Glance: Go to Definition'
})

vim.keymap.set('n', 'gr', '<cmd>Glance references<cr>', {
    desc = 'Glance: Go to References'
})

vim.keymap.set('n', 'gy', '<cmd>Glance type_definitions<cr>', {
    desc = 'Glance: Go to Type Definition'
})
