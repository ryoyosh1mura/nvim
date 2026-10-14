-- Inline git diff for the buffer being edited, toggled on demand.
--  Uses the overlay of `mini.diff` (part of mini.nvim, installed in init.lua):
--  deleted and changed lines from the git index are drawn as virtual lines,
--  and added lines are highlighted, right inside the normal editing window.
--
-- See `:help MiniDiff.toggle_overlay()` and `:help MiniDiff-source-specification`

local minidiff = require 'mini.diff'
local git_source = minidiff.gen_source.git()

-- NOTE: gitsigns already owns the sign column and the hunk keymaps, so
--  mini.diff must stay invisible until the toggle below is used. mini.diff
--  tries to enable itself on every `BufEnter`; this wrapper source refuses to
--  attach (returns `false`) unless the buffer was opted in by the toggle,
--  which makes mini.diff disable itself again for that buffer.
local on_demand_source = {
  name = 'git_on_demand',
  attach = function(buf_id)
    if not vim.b[buf_id].inline_diff_enabled then return false end
    return git_source.attach(buf_id)
  end,
  detach = git_source.detach,
  apply_hunks = git_source.apply_hunks,
}

minidiff.setup {
  source = on_demand_source,
  -- Disable every mapping so they do not clash with the gitsigns ones.
  mappings = {
    apply = '',
    reset = '',
    textobject = '',
    goto_first = '',
    goto_prev = '',
    goto_next = '',
    goto_last = '',
  },
}

local function toggle_inline_diff()
  local buf_id = vim.api.nvim_get_current_buf()

  -- Ask mini.diff itself whether the overlay is shown, instead of trusting the
  --  buffer variable alone: `:edit` disables mini.diff behind our back.
  local data = minidiff.get_buf_data(buf_id)
  if data ~= nil and data.overlay then
    vim.b[buf_id].inline_diff_enabled = false
    minidiff.disable(buf_id)
    return
  end

  vim.b[buf_id].inline_diff_enabled = true
  minidiff.enable(buf_id)

  -- `enable()` gives up silently when the source fails to attach, e.g. for a
  --  buffer that is not a file on disk.
  if minidiff.get_buf_data(buf_id) == nil then
    vim.b[buf_id].inline_diff_enabled = false
    vim.notify('Inline diff is not available for this buffer', vim.log.levels.WARN)
    return
  end

  minidiff.toggle_overlay(buf_id)
end

vim.keymap.set('n', '<leader>td', toggle_inline_diff, { desc = '[T]oggle inline git [d]iff' })
