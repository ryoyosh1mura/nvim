# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## このリポジトリについて

[kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) を複製した個人用リポジトリ（remote: `ryoyosh1mura/nvim`）。**これから自分好みにカスタマイズしていくことが目的**であり、上流をそのまま維持することが目的ではない。

チェックアウト先が `~/.config/nvim` そのもの、つまり**実際に使用中の Neovim 設定ディレクトリ**である点に注意。ビルドもデプロイも存在せず、ここを編集した時点で次回の `nvim` 起動から反映される。ただしクラウドセッション（claude.ai/code）では、GitHub から一時ディレクトリに clone された複製を編集することになる。→「[git の運用](#git-の運用)」参照。

Neovim **0.12 以降**が必要（現在 `v0.12.0-dev`）。プラグイン管理は Neovim 組み込みの `vim.pack` を使用しており、**lazy.nvim ではない**。ネット上の kickstart 解説の多くは lazy.nvim 時代のものなのでそのままでは通用しない。

## このリポジトリでの規則

- **既存のコメントを削除しない。** kickstart のコメントは教材として意図的に書かれているため、リファクタリングや整形のついでに消さないこと。ただし、機能を有効化するためにコメントアウトを解除するのは可（例: セクション 10 の `require` 行）。
- **`.md` 以外のファイル内のコメントはすべて英語で書く。** Lua ファイルに新しくコメントを追加する場合も英語。日本語を使うのは `.md` ファイルとチャットでの会話のみ。
- **チャットでの回答は日本語。**
- **コードを追記・変更したら、そのコードの説明を必ず添える。** ユーザーはソフトウェア初学者のため、「何をするコードか」だけでなく「なぜそう書くのか」「どの API・記法が使われているか」まで日本語で説明する。専門用語は初出時に噛み砕く。関連する `:help` のタグや公式ドキュメントへの参照も示すとよい。説明はチャットの回答として書く（コード内のコメントで代替しない）。クラウドセッションでは、この説明を PR 本文案にも書く（ユーザーがスマホで差分を見ながら読めるようにするため）。
- **git の扱いはセッションの種類で変わる。** →「[git の運用](#git-の運用)」を参照。

## git の運用

Claude が git をどこまで操作してよいかは、**セッションがどこで動いているか**によって変わる。作業を始める前にどちらかを判定すること。

### セッションの判定

|                  | ローカルセッション                                   | クラウドセッション                            |
| ---------------- | ---------------------------------------------------- | --------------------------------------------- |
| 作業ディレクトリ | `~/.config/nvim`（実際に使用中の設定ディレクトリ）   | それ以外（クラウド VM 上の一時 clone）        |
| 起動元           | 手元のターミナルの `claude`                          | claude.ai/code・Claude モバイルアプリ         |
| ユーザーの所在   | PC の前にいる                                        | いない（外出先からスマホで指示している）      |

迷ったら `pwd` で判定する。

クラウドセッションが見ているのは **GitHub に push 済みの内容だけ**である。ユーザーの手元にある未コミットの変更やローカル専用のブランチは存在しないものとして扱う。

### ローカルセッションでの規則

履歴や差分の読み取り（`git log`、`git diff`、`git show` など）は自由に行ってよいが、`git commit`、`git branch`、`git switch`、`git checkout`、`git merge`、push などはこちらから実行しない。ユーザーが判断して行う。

### クラウドセッションでの規則

ユーザーは手元におらず自分では git を操作できないため、**Claude が push まで行う**。

1. **作業開始時に必ず `master` からブランチを切る。** master に直接コミットしない。

   ```sh
   git fetch origin
   git switch -c <ブランチ名> origin/master
   ```

   セッション開始時にどのブランチにいても、起点は常に `origin/master` にする。既存ブランチの続きを明示的に頼まれた場合のみ例外とし、その旨をチャットで断る。

2. 変更をコミットする（メッセージ形式は後述）。
3. `git push -u origin <ブランチ名>` で push する。
4. **プルリクエストは作らない。** push したうえで、PR のタイトル案と本文案を日本語でチャットに書く。ユーザーがアプリの差分ビューを確認してから **Create PR** ボタンで作成する。

### ブランチの命名規則

`<type>/<英語の要約-kebab-case>`

`<type>` はコミットメッセージの prefix と同じ 5 種類を使う。

| type       | 用途                                       | 例                            |
| ---------- | ------------------------------------------ | ----------------------------- |
| `feat`     | 機能・設定の追加                           | `feat/relative-line-number`   |
| `fix`      | 不具合修正                                 | `fix/lsp-lua-format-disable`  |
| `docs`     | `.md` ファイルのみの変更                   | `docs/dependency-notes`       |
| `chore`    | 雑務（依存更新、lockfile、設定ファイル）   | `chore/bump-plugins`          |
| `refactor` | 挙動を変えない整理                         | `refactor/section6-servers`   |

- 要約は**英語の小文字 kebab-case**（単語をハイフンでつなぐ）。スラッシュとハイフン以外の記号、スペース、日本語は使わない。
- 3〜5 語程度に収める。

### コミットメッセージ

既存の履歴に合わせ、`<type>: <日本語の要約>` の形式にする。`<type>` はブランチ名と同じ 5 種類。

```
feat: 相対行番号を追加/行番号の表示・非表示機能を追加
```


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

### クラウドセッションでの検証の限界

クラウド VM は素の Ubuntu であり、**Neovim も stylua もプラグインも入っていない**。上に挙げた検証コマンドはどれも実行できない。

- Lua の妥当性は目視で判断するしかない。
- **何を検証できなかったかを必ずチャットと PR 本文案に明記する。「動作確認済み」とは書かない。**
- ユーザーが後で手元にブランチをチェックアウトして確認する前提で書く。

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
