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

M.defaults = {
    {
        name = "BufferKill",
        fn = function()
            require("xxx.plugin-config.bufferline").buf_kill "bd"
        end,
    },
    {
        name = "PrintRtp",
        fn = function()
            PrintRtp()
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
