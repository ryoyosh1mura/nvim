-- [[ Start screen ]]
--  Show a dashboard only when Neovim is opened with no file arguments
--  (snacks.nvim already skips the cases where we don't want it, e.g.
--  `nvim somefile.txt` or reading from stdin).
--
--  Unlike mini.starter, typed letters are not a search query here: the
--  cursor moves with the usual `j`/`k`, `<CR>` runs the item under the
--  cursor, and each item's own `key` runs it directly.
--
-- See `:help snacks-dashboard` and https://github.com/folke/snacks.nvim/blob/main/docs/dashboard.md

vim.pack.add { 'https://github.com/folke/snacks.nvim' }

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

-- snacks.nvim centers every header line on its own, so lines of different
-- lengths would drift apart and break the ASCII art. Pad each line with
-- trailing spaces up to the longest one so the banner moves as one block.
-- `strdisplaywidth` counts screen cells rather than bytes: each `█` is
-- 3 bytes in UTF-8 but only 1 cell wide.
local function pad_to_block(text)
  local lines = vim.split(text, '\n')
  local width = 0
  for _, line in ipairs(lines) do
    width = math.max(width, vim.fn.strdisplaywidth(line))
  end
  for i, line in ipairs(lines) do
    lines[i] = line .. string.rep(' ', width - vim.fn.strdisplaywidth(line))
  end
  return table.concat(lines, '\n')
end

-- A section may be a function instead of a plain table: snacks.nvim calls
-- it every time the dashboard is (re)drawn, so the banner below always
-- reflects today's weekday rather than being frozen at `setup()` time.
local function weekday_header() return {
  header = pad_to_block(weekday_banners[os.date('*t').wday]), padding = 2
} end

-- snacks.nvim bundles many independent modules ("snacks"). Only the ones
-- listed in this table are enabled, so everything else stays off.
require('snacks').setup {
  dashboard = {
    enabled = true,
    preset = {
      keys = {
        { icon = ' ', key = 'n', desc = 'New file', action = ':enew' },
        {
          icon = ' ', key = 'f', desc = 'Find file',
          action = function() require('telescope.builtin').find_files() end
        },
        {
          icon = ' ', key = 'c', desc = 'Edit config',
          action = function() vim.cmd.edit(vim.fn.stdpath 'config' .. '/init.lua') end
        },
        { icon = ' ', key = 'q', desc = 'Quit Neovim', action = ':qa' },
      },
    },
    sections = {
      weekday_header,
      { section = 'keys', gap = 1, padding = 1 },
      {
        icon = ' ', title = 'Recent Files', section = 'recent_files',
        limit = 5, indent = 2, padding = 1
      },
    },
  },
}

-- Toggle the dashboard: close it when it is the current buffer, open it
-- otherwise. When opened this way it appears as a floating window over the
-- current buffer, so closing it brings you right back to where you were.
vim.keymap.set('n', '<leader>d', function()
  if vim.bo.filetype == 'snacks_dashboard' then
    vim.cmd.bdelete()
  else
    Snacks.dashboard.open()
  end
end, { desc = 'Toggle [D]ashboard' })
