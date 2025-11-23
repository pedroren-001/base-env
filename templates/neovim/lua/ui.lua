local function setup_diagnostics_icons()
  -- 定义符号（需要 Nerd Font 支持）
  local signs = {
    [vim.diagnostic.severity.ERROR] = " ",
    [vim.diagnostic.severity.WARN]  = " ",
    [vim.diagnostic.severity.HINT]  = " ",
    [vim.diagnostic.severity.INFO]  = " ",
  }

  -- 定义颜色（行号高亮）
  local colors = {
    [vim.diagnostic.severity.ERROR] = "#db4b4b",
    [vim.diagnostic.severity.WARN]  = "#e0af68",
    [vim.diagnostic.severity.INFO]  = "#0db9d7",
    [vim.diagnostic.severity.HINT]  = "#10B981",
  }

  -- 设置高亮组用于行号颜色
  for severity, color in pairs(colors) do
    local type_name
    if severity == vim.diagnostic.severity.ERROR then type_name = "Error"
    elseif severity == vim.diagnostic.severity.WARN then type_name = "Warn"
    elseif severity == vim.diagnostic.severity.INFO then type_name = "Info"
    elseif severity == vim.diagnostic.severity.HINT then type_name = "Hint"
    end

    local numhl = "DiagnosticLineNr" .. type_name
    vim.api.nvim_set_hl(0, numhl, { fg = color, bold = true })
  end

  -- 使用新 API 配置诊断符号
  vim.diagnostic.config({
    signs = {
      text = signs,
      numhl = {
        [vim.diagnostic.severity.ERROR] = "DiagnosticLineNrError",
        [vim.diagnostic.severity.WARN]  = "DiagnosticLineNrWarn",
        [vim.diagnostic.severity.INFO]  = "DiagnosticLineNrInfo",
        [vim.diagnostic.severity.HINT]  = "DiagnosticLineNrHint",
      },
    }
  })
end

-- 在 LSP 初始化前调用一次即可
setup_diagnostics_icons()
