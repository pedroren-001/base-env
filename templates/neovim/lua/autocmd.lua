--[[
-- 自动关闭Location
--]]
local function close_location_if_last()
    -- Check if the current buffer is a location list
    if vim.bo.buftype == 'quickfix' and vim.fn.getloclist(0, {size = 0}).size > 0 then
        -- Count the number of windows in the current tab
        if vim.fn.winnr('$') == 1 then
            -- Close the location list if it is the last window
            vim.cmd('quit')
        end
    end
end

-- Create an autocmd to trigger the function on window enter
vim.api.nvim_create_autocmd('WinEnter', {
    callback = close_location_if_last,
    group = vim.api.nvim_create_augroup('CloseLastLocation', { clear = true }),
})
