-- CodeDiff: a VSCode-style git diff viewer.
--  Opens an explorer listing every changed file alongside the diff, and can
--  browse the commit log to inspect any single commit or range of commits.
--  Unlike diffview.nvim, it can render a diff either side-by-side or inline
--  (a single pane where deleted lines are drawn as virtual lines).
--
--  Press `t` inside a diff view to toggle between the two layouts,
--  `q` to close the diff tab, and `g?` to list every keymap of the view.
--
-- See `:help codediff` and https://github.com/esmuellert/codediff.nvim

-- NOTE: The `gh` helper is a local in init.lua, so it is not visible from here.
--  Spell out the full URL instead, the same way lua/kickstart/plugins/gitsigns.lua does.
-- NOTE: CodeDiff relies on a native diff library (`libvscode_diff`). It is
--  downloaded automatically on first use and after plugin updates, so no build
--  step is needed in the `PackChanged` autocmd. Run `:CodeDiff install!` to
--  force a reinstall if it ever breaks.
vim.pack.add { 'https://github.com/esmuellert/codediff.nvim' }

require('codediff').setup {
  diff = {
    -- Open every diff inline by default. `t` still switches to side-by-side.
    layout = 'inline',
  },
}

-- Document the new key chain in which-key. `add()` may be called any number of
--  times, so this does not have to live in the `spec` table back in init.lua.
require('which-key').add { { '<leader>g', group = '[G]it Diff' } }

local function map(keys, cmd, desc) vim.keymap.set('n', keys, cmd, { desc = desc }) end

map('<leader>gd', '<cmd>CodeDiff<cr>', 'git [d]iff of the working tree')
map('<leader>gh', '<cmd>CodeDiff history<cr>', 'git commit [h]istory')
map('<leader>gf', '<cmd>CodeDiff history %<cr>', 'git history of this [f]ile')

-- NOTE: This one deliberately omits the trailing <cr>. It only pre-fills the
--  command line, so a revision can be typed using CodeDiff's own completion,
--  e.g. `main` to compare a branch with the working tree, or `main HEAD` to
--  compare two revisions.
map('<leader>gr', ':CodeDiff ', 'git diff a [r]evision or range')
