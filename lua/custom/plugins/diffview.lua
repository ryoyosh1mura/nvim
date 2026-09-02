-- Diffview: a source control view for Git, in the spirit of VSCode's.
--  Opens a panel listing every changed file alongside a side-by-side diff, and
--  can browse the commit log to inspect the contents of any single commit or
--  any range of commits.
--
-- See `:help diffview` and https://github.com/sindrets/diffview.nvim

-- NOTE: The `gh` helper is a local in init.lua, so it is not visible from here.
--  Spell out the full URL instead, the same way lua/kickstart/plugins/gitsigns.lua does.
vim.pack.add { 'https://github.com/sindrets/diffview.nvim' }

require('diffview').setup {}

-- Folds inside a diff
--  Diffview opens its diff windows with `foldmethod=diff`, `foldlevel=0` and
--  `foldcolumn=1`, so every region that is *unchanged* gets collapsed into a
--  single fold line. Only a few lines of context around each change stay
--  visible; that amount is the `context:` item of 'diffopt' (6 by default).
--
--  Those are ordinary folds, so they can be opened and closed again:
--    <leader>z     toggle every fold in the window (see SECTION 2 of init.lua)
--    za / zo / zc  toggle / open / close only the fold under the cursor
--
--  Diffview remaps the `z` fold commands inside its own buffers so that both
--  sides of the diff fold and unfold together.
--  See `:help fold-commands`, `:help 'diffopt'` and `:help fold-diff`

-- Document the new key chain in which-key. `add()` may be called any number of
--  times, so this does not have to live in the `spec` table back in init.lua.
require('which-key').add { { '<leader>g', group = '[G]it Diff' } }

local function map(keys, cmd, desc) vim.keymap.set('n', keys, cmd, { desc = desc }) end

map('<leader>gd', '<cmd>DiffviewOpen<cr>', 'git [d]iff against HEAD')
map('<leader>gh', '<cmd>DiffviewFileHistory<cr>', 'git commit [h]istory')
map('<leader>gf', '<cmd>DiffviewFileHistory %<cr>', 'git history of this [f]ile')
map('<leader>gq', '<cmd>DiffviewClose<cr>', 'git diff [q]uit')

-- NOTE: This one deliberately omits the trailing <cr>. It only pre-fills the
--  command line, so a revision can be typed using Diffview's own completion,
--  e.g. `a0a4566..31209a0` for a range, or `31209a0^!` for a single commit.
map('<leader>gr', ':DiffviewOpen ', 'git diff a [r]evision or range')
