-- Usage: :SplitLine <delimiter>

local string_len = string.len
local string_find = string.find
local string_sub = string.sub
local table_insert = table.insert


function _G.split_string(str, d) --str是需要查分的对象 d是分界符
    local lst = {nil, nil, nil, nil,} --for rehash
    local len = string_len(str)--长度
    local index = 1
    while index <= len do
        local i = string_find(str, d, index) -- find 'next' 0
        if i == nil then
            table_insert(lst, string_sub(str, index, len))
            break
        end
        table_insert(lst, string_sub(str, index, i-1))
        if i == len then
            table_insert(lst, "")
            break
        end
        index = i + 1
    end
    return lst
end

function split_line(delimiter)
    if delimiter == nil or delimiter == '' then
        delimiter = ' '
    end

    -- 检查是否有选区
    local mode = vim.fn.mode()
    local start_line, end_line
    if mode == 'v' or mode == 'V' or mode == '' then
        -- Visual mode
        start_line, _, end_line, _ = table.unpack(vim.fn.getpos("'<"), 2, vim.fn.getpos("'>"), 2)
    else
        -- Normal mode, use the current line
        start_line, end_line = vim.fn.line('.'), vim.fn.line('.')
    end

    -- 读取行
    local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

    -- 处理每一行
    local new_lines = {}
    for _, line in ipairs(lines) do
        for _, split_line in ipairs(split_string(line,delimiter)) do
            table.insert(new_lines, split_line)
        end
    end

    -- 替换原来的文本
    vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, new_lines)
end

-- Create a command that can be called from Neovim
vim.api.nvim_create_user_command(
    'SplitLines',
    function(opts)
        split_line(opts.args)
    end,
    {
        nargs = '?',  -- 可选参数
        range = '%',  -- 默认范围是当前行
        desc = 'split lines by a delimiter'  -- 命令描述
    }
)

vim.api.nvim_create_user_command(
    "TestTouch",
    function()
        local bufnr = vim.api.nvim_get_current_buf()
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

        for _, line in ipairs(lines) do
            local path = line:match("%-%-@ptest:(.+)")
            if path then
                local trimmed_path = vim.fn.trim(path)
                os.execute("touch " .. vim.fn.shellescape(trimmed_path))
                print("Touched: " .. trimmed_path)
                return
            end
        end

        print("no matching line found")
    end, 
    { 
        nargs = 0
    }
)

vim.api.nvim_create_user_command("SwitchTest", function()
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

    for _, line in ipairs(lines) do
        local path = line:match("%-%-@ptest:(.+)")
        if path then
            local trimmed_path = vim.fn.trim(path)

            -- Check if the file is already open in another tab
            for tabnr = 1, vim.fn.tabpagenr("$") do
                for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(tabnr)) do
                    local buf = vim.api.nvim_win_get_buf(winid)
                    local bufname = vim.api.nvim_buf_get_name(buf)
                    if bufname == trimmed_path then
                        vim.cmd("tabnext " .. tabnr) -- Switch to the existing tab
                        print("switched to tab with: " .. trimmed_path)
                        return
                    end
                end
            end

            -- Open the file in a new tab if not already open
            vim.cmd("tabnew " .. vim.fn.fnameescape(trimmed_path))
            print("opened in new tab: " .. trimmed_path)
            return
        end
    end

    print("no matching line found")
end, { nargs = 0 })


------------------------------------------ multi-picker 
local picks = {}
function pick_selection()
    local _, csrow, cscol, _ = unpack(vim.fn.getpos("v"))
    local _, cerow, cecol, _ = unpack(vim.fn.getpos("."))
    if csrow > cerow or (csrow == cerow and cscol > cecol) then
        csrow, cerow = cerow, csrow
        cscol, cecol = cecol, cscol
    end
    local lines = vim.api.nvim_buf_get_text(0, csrow - 1, cscol - 1, cerow - 1, cecol, {})
    local text = table.concat(lines, "\n")
    table.insert(picks, text)
    vim.notify('picked: "' .. text .. '"', vim.log.levels.INFO)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), 'n', true)
end

function pick_clear()
    picks = {}
    vim.notify('cleared picks', vim.log.levels.INFO)
end

--- 如果有内容，粘贴到当前光标位置. 否则正常粘贴
function pick_paste()
    if #picks == 0 then
        vim.notify('no picks to paste', vim.log.levels.INFO)
        -- do normal paste
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("p", true, false, true), 'n', true)
        return
    end

    -- paste selected content
    local paste_text = table.concat(picks, "\n")
    vim.api.nvim_put(vim.split(paste_text, "\n"), "l", true, true)
    pick_clear()
end

vim.keymap.set(
    'v', 's', '<Cmd>lua pick_selection()<CR>', { noremap = true, silent = true, desc = 'pick selection' }
)

vim.keymap.set(
    'n', 's', '<Cmd>lua pick_selection()<CR>', { noremap = true, silent = true, desc = 'pick selection' }
)

vim.keymap.set(
    'n', 'p', '<Cmd>lua pick_paste()<CR>', { noremap = true, silent = true, desc = 'paste picks' }
)

--------------------------------------------------------
--- AI 助手集成
--------------------------------------------------------
--- chat => Toggleterm: and focus on it
local Terminal = require("toggleterm.terminal").Terminal
local aichat_term_opts = {
    noremap = true,
    silent  = true,
    desc    = 'open aichat window'
}

local aichat_func = function()
    local datestr = os.date("%Y-%m-%d")
    local ai_term = Terminal:new({
        cmd = "aichat -s " .. datestr,
        direction = "tab", -- /horizontal, /vertical, /float
        float_opts = {
            border   = "curved",
            width    = 10,
            height   = 50,
            winblend = 3,
        },
    })
    ai_term:toggle()
end
vim.keymap.set('n', '<leader>ch', aichat_func, aichat_term_opts)

--- codebuddy
local codebuddy_term_opts = {
    noremap = true,
    silent  = true,
    desc    = 'open codebuddy window'
}
local codebuddy_func = function()
    local ai_term = Terminal:new({
        cmd = "codebuddy-code",
        direction = "tab", -- /horizontal, /vertical, /float
        float_opts = {
            border = "curved",
            width = 10,
            height = 50,
            winblend = 3,
        },
    })
    ai_term:toggle()
end
vim.keymap.set('n', '<leader>cb', codebuddy_func, codebuddy_term_opts)

--------------------------------------------------------
---
---
--------------------------------------------------------
--- copy current buffer path
vim.api.nvim_create_user_command("CopyBufferPath", function()
    local file_name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":." .. vim.fn.getcwd())
    vim.fn.setreg("+", file_name)
    print(string.format("Copied: %s", file_name))
end, { desc = "Copy current buffer path" })
--------------------------------------------------------



--------------------------------------------------------
---
---
--------------------------------------------------------
--- Telescope: Open file under cursor in new tab
local builtin = require('telescope.builtin')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

function MyTelescope_gf()
  -- Get word under cursor
  local word = vim.fn.expand('<cfile>')
  if not word or word == '' then
    print('No file under cursor')
    return
  end

  -- Gather all files (you could use find_files or git_files)
  builtin.find_files({
    default_text = word,
  })
end

vim.keymap.set('n', 'gf', MyTelescope_gf, { noremap = true, silent = true, desc = 'Open file under cursor in new tab' })



vim.api.nvim_create_user_command('Rename', function(opts)
  local old = vim.fn.expand('%')
  local new = opts.args
  if old == new then
    print("New filename is the same as the old one.")
    return
  end
  os.rename(old, new)
  vim.cmd('edit '..new)
  vim.cmd('bwipeout '..old)
end, { nargs = 1, complete = 'file' })




vim.api.nvim_create_user_command("Tabnewf", function(opts)
  -- Open new tab and edit the file
  vim.cmd('tabnew '..opts.args)
  -- Set autoread for this buffer
  vim.bo.autoread = true
  -- Clear previous autocmds for this buffer (avoid duplication)
  vim.api.nvim_clear_autocmds({ group = vim.api.nvim_create_augroup("TabNewfChecktime", {clear=false}), buffer = 0 })
  -- Set up CursorHold autocmd (buffer-local)
  vim.api.nvim_create_autocmd("CursorHold", {
    group = vim.api.nvim_create_augroup("TabNewfChecktime", {clear=false}),
    buffer = 0,
    callback = function()
      vim.cmd('checktime')
    end,
    desc = "Autoread Tail-like checktime in Tabnewf buffer"
  })
end, {
  nargs = 1,     -- Requires *exactly* one argument (the filename)
  complete = "file", -- Enable file completion
})

local function eval_under_cursor()
  local expr = vim.fn.expand('<cword>')     -- get word under cursor
  local ft = vim.bo.filetype

  vim.notify("Evaluating: " .. expr, vim.log.levels.INFO)

  if ft == 'lua' then
    local chunk, err = load("return " .. expr)
    if not chunk then
      vim.notify("Error: " .. err, vim.log.levels.ERROR)
      return
    end
    local ok, result = pcall(chunk)
    if not ok then
      vim.notify("Eval Error: " .. result, vim.log.levels.ERROR)
      return
    end
    vim.notify(expr .. " = " .. vim.inspect(result))
    return
  end

  if ft == 'python' then
    local cmd = string.format([[python3 -c "print(repr(%s))"]], expr)
    local output = vim.fn.systemlist(cmd)
    if vim.v.shell_error ~= 0 then
      vim.notify("Python error: " .. table.concat(output, '\n'), vim.log.levels.ERROR)
      return
    end
    vim.notify(expr .. " = " .. table.concat(output, " "))
    return
  end

  vim.notify("Evaluation not supported for filetype: " .. ft)
end

vim.keymap.set('n', 'E', eval_under_cursor, { noremap = true, silent = true, desc = "Eval under cursor" })
vim.keymap.set('v', 'E', function()
  local expr = vim.fn.getreg('"')
  local ft = vim.bo.filetype

  vim.notify("Evaluating: " .. expr, vim.log.levels.INFO)

  if ft == 'lua' then
    local chunk, err = load("return " .. expr)
    if not chunk then
      vim.notify("Error: " .. err, vim.log.levels.ERROR)
      return
    end
    local ok, result = pcall(chunk)
    if not ok then
      vim.notify("Eval Error: " .. result, vim.log.levels.ERROR)
      return
    end
    vim.notify(expr .. " = " .. vim.inspect(result))
    return
  end

  if ft == 'python' then
    local cmd = string.format([[python3 -c "print(repr(%s))"]], expr)
    local output = vim.fn.systemlist(cmd)
    if vim.v.shell_error ~= 0 then
      vim.notify("Python error: " .. table.concat(output, '\n'), vim.log.levels.ERROR)
      return
    end
    vim.notify(expr .. " = " .. table.concat(output, " "))
    return
  end

  vim.notify("Evaluation not supported for filetype: " .. ft)
end, { noremap = true, silent = true, desc = "Eval selection" })
