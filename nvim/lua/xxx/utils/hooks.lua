local M = {}

local Log = require "xxx.core.log"

function M.run_on_packer_complete()
    Log:debug "Packer operation complete"
    vim.api.nvim_exec_autocmds("User", { pattern = "PackerComplete" })

    vim.g.colors_name = Xvim.colorscheme
    pcall(vim.cmd, "colorscheme " .. Xvim.colorscheme)

    -- vim.g.colors_name = "onedark"
    -- pcall(vim.cmd, "colorscheme onedark")

    if M._reload_triggered then
        Log:debug "Reloaded configuration"
        M._reload_triggered = nil
    end

end

return M
