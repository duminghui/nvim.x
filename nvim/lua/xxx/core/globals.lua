---Require a module using [pcall] and report any errors
---@param module string
---@param opts table?
---@return boolean, any
function _G.safe_require(module, opts)
    opts = opts or { silent = false }
    local ok, result = pcall(require, module)
    if not ok and not opts.silent then
        vim.schedule(function()
            vim.notify(result, vim.log.levels.ERROR, { title = string.format("Error requiring: %s", module) })
        end)
    end
    return ok, result
end
