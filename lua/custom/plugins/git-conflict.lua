-- Highlights merge-conflict markers (<<<<<<<, =======, >>>>>>>) in a buffer and
-- provides navigation/resolution commands. gitsigns only tracks the diff
-- against the index (uncommitted changes), so it has no concept of an
-- in-progress merge conflict; this plugin fills that gap.
-- See: https://github.com/akinsho/git-conflict.nvim

vim.pack.add { 'https://github.com/akinsho/git-conflict.nvim' }

require('git-conflict').setup {
  default_mappings = true, -- co/ct/cb/c0 choose ours/theirs/both/none; ]x/[x jump between conflicts
  default_commands = true, -- :GitConflictChooseOurs / :GitConflictChooseTheirs / :GitConflictChooseBoth / :GitConflictChooseNone
  disable_diagnostics = false, -- keep LSP diagnostics active inside conflicted buffers
  list_opener = 'copen', -- command used to open the quickfix list from :GitConflictListQf
  highlights = {
    incoming = 'DiffAdd', -- the side being merged in
    current = 'DiffText', -- the side already in the buffer (ours)
  },
}
