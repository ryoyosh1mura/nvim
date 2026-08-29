-- [[ Start screen ]]
--  Show a dashboard only when Neovim is opened with no file arguments
--  (`autoopen` defaults to `true` and already skips the cases where we
--  don't want it, e.g. `nvim somefile.txt` or reading from stdin).
local starter = require 'mini.starter'

-- Same "ANSI Shadow" figlet font as before, one banner per weekday name.
-- Indexed the same way Lua's `os.date('*t').wday` returns it: 1 = Sunday,
-- 2 = Monday, ..., 7 = Saturday.
local weekday_banners = {
  [[
 ███████╗██╗   ██╗███╗   ██╗██████╗  █████╗ ██╗   ██╗
 ██╔════╝██║   ██║████╗  ██║██╔══██╗██╔══██╗╚██╗ ██╔╝
 ███████╗██║   ██║██╔██╗ ██║██║  ██║███████║ ╚████╔╝
 ╚════██║██║   ██║██║╚██╗██║██║  ██║██╔══██║  ╚██╔╝
 ███████║╚██████╔╝██║ ╚████║██████╔╝██║  ██║   ██║
 ╚══════╝ ╚═════╝ ╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═╝   ╚═╝]],
  [[
 ███╗   ███╗ ██████╗ ███╗   ██╗██████╗  █████╗ ██╗   ██╗
 ████╗ ████║██╔═══██╗████╗  ██║██╔══██╗██╔══██╗╚██╗ ██╔╝
 ██╔████╔██║██║   ██║██╔██╗ ██║██║  ██║███████║ ╚████╔╝
 ██║╚██╔╝██║██║   ██║██║╚██╗██║██║  ██║██╔══██║  ╚██╔╝
 ██║ ╚═╝ ██║╚██████╔╝██║ ╚████║██████╔╝██║  ██║   ██║
 ╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═╝   ╚═╝]],
  [[
 ████████╗██╗   ██╗███████╗███████╗██████╗  █████╗ ██╗   ██╗
 ╚══██╔══╝██║   ██║██╔════╝██╔════╝██╔══██╗██╔══██╗╚██╗ ██╔╝
    ██║   ██║   ██║█████╗  ███████╗██║  ██║███████║ ╚████╔╝
    ██║   ██║   ██║██╔══╝  ╚════██║██║  ██║██╔══██║  ╚██╔╝
    ██║   ╚██████╔╝███████╗███████║██████╔╝██║  ██║   ██║
    ╚═╝    ╚═════╝ ╚══════╝╚══════╝╚═════╝ ╚═╝  ╚═╝   ╚═╝]],
  [[
 ██╗    ██╗███████╗██████╗ ███╗   ██╗███████╗███████╗██████╗  █████╗ ██╗   ██╗
 ██║    ██║██╔════╝██╔══██╗████╗  ██║██╔════╝██╔════╝██╔══██╗██╔══██╗╚██╗ ██╔╝
 ██║ █╗ ██║█████╗  ██║  ██║██╔██╗ ██║█████╗  ███████╗██║  ██║███████║ ╚████╔╝
 ██║███╗██║██╔══╝  ██║  ██║██║╚██╗██║██╔══╝  ╚════██║██║  ██║██╔══██║  ╚██╔╝
 ╚███╔███╔╝███████╗██████╔╝██║ ╚████║███████╗███████║██████╔╝██║  ██║   ██║
  ╚══╝╚══╝ ╚══════╝╚═════╝ ╚═╝  ╚═══╝╚══════╝╚══════╝╚═════╝ ╚═╝  ╚═╝   ╚═╝]],
  [[
 ████████╗██╗  ██╗██╗   ██╗██████╗ ███████╗██████╗  █████╗ ██╗   ██╗
 ╚══██╔══╝██║  ██║██║   ██║██╔══██╗██╔════╝██╔══██╗██╔══██╗╚██╗ ██╔╝
    ██║   ███████║██║   ██║██████╔╝███████╗██║  ██║███████║ ╚████╔╝
    ██║   ██╔══██║██║   ██║██╔══██╗╚════██║██║  ██║██╔══██║  ╚██╔╝
    ██║   ██║  ██║╚██████╔╝██║  ██║███████║██████╔╝██║  ██║   ██║
    ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═════╝ ╚═╝  ╚═╝   ╚═╝]],
  [[
 ███████╗██████╗ ██╗██████╗  █████╗ ██╗   ██╗
 ██╔════╝██╔══██╗██║██╔══██╗██╔══██╗╚██╗ ██╔╝
 █████╗  ██████╔╝██║██║  ██║███████║ ╚████╔╝
 ██╔══╝  ██╔══██╗██║██║  ██║██╔══██║  ╚██╔╝
 ██║     ██║  ██║██║██████╔╝██║  ██║   ██║
 ╚═╝     ╚═╝  ╚═╝╚═╝╚═════╝ ╚═╝  ╚═╝   ╚═╝]],
  [[
 ███████╗ █████╗ ████████╗██╗   ██╗██████╗ ██████╗  █████╗ ██╗   ██╗
 ██╔════╝██╔══██╗╚══██╔══╝██║   ██║██╔══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝
 ███████╗███████║   ██║   ██║   ██║██████╔╝██║  ██║███████║ ╚████╔╝
 ╚════██║██╔══██║   ██║   ██║   ██║██╔══██╗██║  ██║██╔══██║  ╚██╔╝
 ███████║██║  ██║   ██║   ╚██████╔╝██║  ██║██████╔╝██║  ██║   ██║
 ╚══════╝╚═╝  ╚═╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═╝   ╚═╝]],
}

-- `header` may be a function instead of a plain string: mini.starter calls
-- it every time the dashboard buffer is (re)built, so the banner below
-- always reflects today's weekday rather than being frozen at `setup()` time.
local function starter_header() return weekday_banners[os.date('*t').wday] end

starter.setup {
  header = starter_header,
  -- `items` accepts a mix of: a single item table, an array of item
  -- tables, or a function returning either — freely nested. The four
  -- plain tables below are one-off actions; `sections.recent_files`
  -- instead returns an array with one item per recently opened file,
  -- spliced in as its own section.
  items = {
    { name = 'New file', action = 'enew', section = 'Actions' },
    -- `require` is deferred inside the action so telescope only has to
    -- load when this item is actually picked, not at every startup.
    { name = 'Find file', action = function() require('telescope.builtin').find_files() end, section = 'Actions' },
    { name = 'Edit config', action = function() vim.cmd.edit(vim.fn.stdpath 'config' .. '/init.lua') end, section = 'Actions' },
    { name = 'Quit Neovim', action = 'qa', section = 'Actions' },
    starter.sections.recent_files(5, false),
  },
  -- Prefix every item with a bullet, then center the whole buffer
  -- (header + items + footer) both horizontally and vertically.
  content_hooks = {
    starter.gen_hook.adding_bullet(),
    starter.gen_hook.aligning('center', 'center'),
  },
}

-- Reopen the dashboard on demand, e.g. after closing every other buffer.
vim.keymap.set('n', '<leader>d', starter.open, { desc = 'Open [D]ashboard' })
