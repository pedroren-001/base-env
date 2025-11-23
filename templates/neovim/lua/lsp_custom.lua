vim.lsp.config('*', {
    flags = {
        debounce_text_changes = 500
    }
})


local lsp_configs = {}
local has_lua_ls = false
for _, f in pairs(vim.api.nvim_get_runtime_file('lsp/*.lua', true)) do
  local server_name = vim.fn.fnamemodify(f, ':t:r')
  table.insert(lsp_configs, server_name)
  if server_name == "lua_ls" then
      has_lua_ls = true
  end
end
vim.lsp.enable(lsp_configs)

-- inlay-hints
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
        end

        -- codelens
        -- if client:supports_method("textDocument/codeLens", { bufnr = args.buf }) then
        --     vim.lsp.codelens.refresh { bufnr = args.buf }
        --     vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
        --         buffer = args.buf,
        --         callback = function()
        --             vim.lsp.codelens.refresh { bufnr = args.buf }
        --         end,
        --     })
        -- end
    end
})

-- 针对lua_helper只在项目里用
local utils = vim.lsp.util
local function has_lua_helper(path)
    local root = vim.fs.find("luahelper.json", {
        upward = true,
        path = path,
    })
    if root and next(root) then
        return root[1]
    end
    return nil
end

-- ls
if has_lua_ls then
    vim.lsp.config("lua_ls", {
        root_dir = function(bufno, callback)
            local path = vim.api.nvim_buf_get_name(bufno)
            local stat = vim.loop.fs_stat(path)
            if stat and has_lua_helper(path) then
                return nil
            else
                return callback()
            end
        end
    })
end
