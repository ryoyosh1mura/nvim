# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## このリポジトリについて

[kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) を複製した個人用リポジトリ（remote: `ryoyosh1mura/nvim`）。**これから自分好みにカスタマイズしていくことが目的**であり、上流をそのまま維持することが目的ではない。

チェックアウト先が `~/.config/nvim` そのもの、つまり**実際に使用中の Neovim 設定ディレクトリ**である点に注意。ビルドもデプロイも存在せず、ここを編集した時点で次回の `nvim` 起動から反映される。

Neovim **0.12 以降**が必要（現在 `v0.12.0-dev`）。プラグイン管理は Neovim 組み込みの `vim.pack` を使用しており、**lazy.nvim ではない**。ネット上の kickstart 解説の多くは lazy.nvim 時代のものなのでそのままでは通用しない。

## このリポジトリでの規則

- **既存のコメントを削除しない。** kickstart のコメントは教材として意図的に書かれているため、リファクタリングや整形のついでに消さないこと。ただし、機能を有効化するためにコメントアウトを解除するのは可（例: セクション 10 の `require` 行）。
- **`.md` 以外のファイル内のコメントはすべて英語で書く。** Lua ファイルに新しくコメントを追加する場合も英語。日本語を使うのは `.md` ファイルとチャットでの会話のみ。
- **チャットでの回答は日本語。**
- **コードを追記・変更したら、そのコードの説明を必ず添える。** ユーザーはソフトウェア初学者のため、「何をするコードか」だけでなく「なぜそう書くのか」「どの API・記法が使われているか」まで日本語で説明する。専門用語は初出時に噛み砕く。関連する `:help` のタグや公式ドキュメントへの参照も示すとよい。説明はチャットの回答として書く（コード内のコメントで代替しない）。
- **git のコミットとブランチ操作はユーザーが判断して行う。** 履歴や差分の読み取り（`git log`、`git diff`、`git show` など）は自由に行ってよいが、`git commit`、`git branch`、`git checkout`、`git merge`、push などはこちらから実行しない。

## コマンド

```sh
stylua .                 # フォーマット（stylua は Mason 経由: ~/.local/share/nvim/mason/bin/stylua）
stylua --check .         # CI 相当のチェック

nvim --headless "+checkhealth kickstart" +qa   # Neovim のバージョンと外部依存（git, make, unzip, rg）を確認
nvim --headless "+lua require('nvim-treesitter')" +qa   # init.lua がエラーなく読み込めるかのスモークテスト
```

テストスイートは存在しない。`.github/workflows/stylua.yml` は `github.repository == 'nvim-lua/kickstart.nvim'` という条件付きなので、**このフォークでは CI が一切動かない**。`stylua --check .` はローカルで実行する必要がある。

Neovim 内でのプラグイン操作:
- `:lua vim.pack.update(nil, { offline = true })` — 現在の状態と更新可能なものを確認
- `:lua vim.pack.update()` — 更新を取得。`:write` で適用、`:quit` で取り消し
- `:Mason` — LSP サーバーやツールの管理

## 構成

### `init.lua` が設定のすべて

約 1000 行の単一ファイル（上流が「教材」として意図的に 1 ファイルにしている）。10 個の番号付きバナーコメントで区切られ、**各セクションが `do ... end` ブロックで囲まれている**ためローカル変数がセクション間に漏れない。

1. オプション · 2. キーマップと autocmd · 3. プラグインマネージャ／ビルドフック · 4. UI・基本 UX（guess-indent, gitsigns, which-key, tokyonight, todo-comments, mini.nvim）· 5. Telescope · 6. LSP + Mason · 7. conform.nvim · 8. blink.cmp + LuaSnip · 9. Treesitter · 10. オプション例

新しい設定はファイル末尾に追記するのではなく、**該当セクションの `do` ブロック内**に置く。`gh 'owner/repo'`（セクション 3 と 4 の間で定義）が `vim.pack.add` 用の GitHub URL を組み立てるヘルパー。

`init.lua` を大きく再構成すると将来の upstream 取り込みが困難になるため、大規模な構造変更を提案する際はそのトレードオフを明示すること。

### ビルドフックは 1 箇所に集約されている

インストール後にビルドが必要なプラグインは、**セクション 3 の単一の `PackChanged` autocmd** 内でプラグイン名によって分岐処理される。現在の対象は `telescope-fzf-native.nvim`（`make`）、`LuaSnip`（`make install_jsregexp`、Windows 以外）、`nvim-treesitter`（`:TSUpdate`）。ビルドを伴うプラグインを追加する場合は、`vim.pack.add` の呼び出し箇所ではなくこの autocmd を編集する。

### `servers` テーブルは Mason のインストール一覧を兼ねている

セクション 6 では `ensure_installed` が `vim.tbl_keys(servers)` から生成される。LSP サーバーではない `stylua = {}` が `servers` に入っているのはそのためで、Mason にツールをインストールさせるためのこの設定固有のイディオムである。編集時の注意点:

- LSP を追加するには `servers` にキーを追加するだけでよい。自動でインストールされ、セクション末尾のループが `vim.lsp.config` と `vim.lsp.enable` を実行する。
- `mason-lspconfig` は `automatic_enable = false` で動いているため、`:Mason` から手動インストールしたサーバーは `servers` に追加しない限り**有効化されない**。
- `lua_ls` のフォーマット機能は 2 箇所（`on_init` の capability と `settings.Lua.format.enable`）で意図的に無効化してある。Lua のフォーマットは stylua / conform 側の担当。

### フォーマットと Treesitter はファイルタイプ単位のオプトイン

- conform の `format_on_save` が参照する `enabled_filetypes` テーブルは**現在空**なので、保存時フォーマットは何も起きない。`<leader>f` で手動フォーマットする。`formatters_by_ft` も空で、LSP フォーマットにフォールバックする。
- Treesitter はプラグインの `main` ブランチを追跡している（`master` ではない）。`FileType` autocmd がパーサーを遅延アタッチし、利用可能なパーサーは初回使用時に**自動インストール**されるため、新しい言語のために設定を書く必要は基本的にない。

### 拡張ポイント

- `lua/kickstart/plugins/*.lua`（debug, indent_line, lint, autopairs, neo-tree, gitsigns）は上流のサンプルで、**すべて無効**。セクション 10 の `require` 行がコメントアウトされている。
- `lua/custom/plugins/init.lua` は同ディレクトリ内の他の `.lua` ファイルを自動で `require` するが、セクション 10 の `require 'custom.plugins'` 自体がコメントアウトされている。**このコメントを外さない限り `lua/custom/plugins/` 配下は一切実行されない**。

## その他

- `DEPENDENCY.md` には、この kickstart を動かすために実際に必要だったセットアップ手順が書かれている。現状は `tree-sitter` CLI を cargo でソースからビルドする手順（`stdbool.h` が見つからない場合の `BINDGEN_EXTRA_CLANG_ARGS` 回避策を含む）。同種の依存関係が新たに必要になった場合はここに追記する。
