local M = {}

vim.cmd [[
  function! QuickFixToggle()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
      copen
    else
      cclose
    endif
  endfunction
]]

local cmd_bdelete = "bdelete"
if vim.fn.has "nvim-0.8" == 1 then
    cmd_bdelete = "Bdelete"
end

M.defaults = {
    {
        name = "BufferKill",
        fn = function()
            -- require("xxx.core.buffers").buf_kill "bd"
            require("xxx.core.buffers").buf_kill(cmd_bdelete)
        end,
    },
    {
        name = "PrintRtp",
        fn = function()
            for k, v in pairs(vim.opt.rtp:get()) do
                print(k, v)
            end
        end
    }
}


function M.load(collection)
    local common_opts = { force = true }
    for _, cmd in pairs(collection) do
        local opts = vim.tbl_deep_extend("force", common_opts, cmd.opts or {})
        vim.api.nvim_create_user_command(cmd.name, cmd.fn, opts)
    end
end

return M
