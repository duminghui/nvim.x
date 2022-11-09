local M = {}

M.opts = {
  max_lines = 500,
  marks = {
    Search = {
      color = "#FFD700"
    },
  },
  handlers = {
    diagnostic = true,
    -- not set to true, will conflict hlslens's setup
    search = false,
  }
}

function M.setup()
  local ok, scrollbar = safe_require("scrollbar")
  if not ok then
    return
  end

  scrollbar.setup(M.opts)
  require("xxx.plugin-config.scroll.hlslens-rc").integrate_with_scrollbar()

end

return M
