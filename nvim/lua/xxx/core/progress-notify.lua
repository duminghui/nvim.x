local spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }

---@class ProgressNotify
local ProgressNotify = {
    is_finish = false,
    spinner = 1,
}

function ProgressNotify:update_spinner()
    -- if self.spinner then
    if not self.is_finish then
        local new_spinnter = (self.spinner + 1) % #spinner_frames
        self.spinner = new_spinnter
        local msg = "::" .. self.spinner .. "  "
        self.notificate = vim.notify(msg, nil, {
            hide_from_history = true,
            icon = spinner_frames[new_spinnter],
            replace = self.notificate,
        })
        vim.defer_fn(function()
            self:update_spinner()
        end, 100)
    end
end

function ProgressNotify:start(title, msg)
    title = title or "NO TITLE"
    msg = msg or "NO MESSAGE"
    self.notificate = vim.notify(msg, "info", {
        title = title,
        icon = spinner_frames[1],
        timeout = false,
        hide_from_history = false,
    })
    self.spinner = 1
    self:update_spinner()
end

local icons = require("xxx.core.icons")

function ProgressNotify:finish(msg, level, icon)
    icon = icon or ""
    icon = icon == "" and icons.ui.CircleCheck or icon
    msg = msg or "NO MESSAGE"
    level = level or "info"
    self.is_finish = true
    self.notificate = vim.notify(msg, level, {
        icon = icon,
        replace = self.notificate,
        timeout = 3000,
    })
end

function ProgressNotify:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

return ProgressNotify
