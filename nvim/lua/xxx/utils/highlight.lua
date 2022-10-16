local M = {}

local loaded_highlights = {}

local function highlight_exists(highlight_name)
    return loaded_highlights[highlight_name] or false
end

---converts cterm, color_name type colors to #rrggbb format
---@param color string|number
---@return string
local function sanitize_color(color)
    if color == nil or color == '' or (type(color) == 'string' and color:lower() == 'none') then
        return 'None'
    end
    return tostring(color)
end

function M.highlight(name, foreground, background, gui, link)
    if name == nil or name == '' then
        return
    end
    if highlight_exists(name) then
        return
    end

    local command = { "highlight!" }
    if link and #link > 0 then
        vim.list_extend(command, { "link", name, link })
    else
        foreground = sanitize_color(foreground)
        background = sanitize_color(background)
        gui = (gui ~= nil and gui ~= '') and gui or "None"
        table.insert(command, name)
        table.insert(command, 'guifg=' .. foreground)
        table.insert(command, 'guibg=' .. background)
        table.insert(command, 'gui=' .. gui)
    end
    vim.cmd(table.concat(command, " "))
    loaded_highlights[name] = true
end

-- Note for now only works for termguicolors scope can be bg or fg or any other
-- attr parameter like bold/italic/reverse
---@param color_group string hl_group name
---@param scope       string|nil bg | fg | sp
---@return table|string|nil returns #rrggbb formatted color when scope is specified
----                       or complete color table when scope isn't specified
function M.extract_highlight_colors(color_group, scope)
    if vim.fn.hlexists(color_group) == 0 then
        return nil
    end
    local color = vim.api.nvim_get_hl_by_name(color_group, true)
    if color.background ~= nil then
        color.bg = string.format('#%06x', color.background)
        color.background = nil
    end
    if color.foreground ~= nil then
        color.fg = string.format('#%06x', color.foreground)
        color.foreground = nil
    end
    if color.special ~= nil then
        color.sp = string.format('#%06x', color.special)
        color.special = nil
    end
    if scope then
        return color[scope]
    end
    return color
end

--- retrieves color value from highlight group name in syntax_list
--- first present highlight is returned
---@param scope string|table
---@param syntaxlist string|table
---@param default string
---@return string|nil
function M.extract_color_from_hllist(scope, syntaxlist, default)
    scope = type(scope) == 'string' and { scope } or scope
    syntaxlist = type(syntaxlist) == 'string' and { syntaxlist } or syntaxlist
    for _, hl_name in ipairs(syntaxlist) do
        if vim.fn.hlexists(hl_name) ~= 0 then
            local color = M.extract_highlight_colors(hl_name)
            if color ~= nil then
                for _, sc in ipairs(scope) do
                    if color.reverse then
                        if sc == 'bg' then
                            sc = 'fg'
                        else
                            sc = 'bg'
                        end
                    end
                    if color[sc] then
                        return color[sc]
                    end
                end
            end
        end
    end
    return default

end

return M
