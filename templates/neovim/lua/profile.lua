-- Function to check if the file is larger than the specified size (1MB)
local function is_large_file()
  local max_filesize = 1 * 1024 * 1024 -- 1MB in bytes
  local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(0))
  if ok and stats and stats.size > max_filesize then
    return true
  else
    return false
  end
end

-- Autocommand to disable plugins and features for large files
vim.api.nvim_create_autocmd({"BufReadPre", "FileReadPre"}, {
  callback = function()
    if is_large_file() then
      -- Disable Treesitter syntax highlighting
      if vim.fn.exists(':TSBufDisable') == 2 then
        vim.cmd("TSBufDisable highlight")
      end

      -- Disable Coc.nvim
      vim.g.coc_start_at_startup = 0

      -- Disable EditorConfig
      vim.g.EditorConfig_exclude_patterns = {'*'}

      -- Disable Luasnip
      package.loaded['luasnip'] = nil

      -- Turn off syntax highlighting plugins but keep basic highlighting
      vim.cmd("syntax on")
      vim.opt.syntax = 'on'

      -- Ensure line numbers are displayed
      vim.opt.number = true

      -- Display a message
      print("Large file detected: Disabling heavy plugins for better performance.")
    else
      -- Enable or configure plugins as normal
      vim.g.coc_start_at_startup = 1
    end
  end
})
