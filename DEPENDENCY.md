# dependency

## tree-sitterのインストール
```sh
sudo rm /usr/local/bin/tree-sitter
# Rustツールチェーンをインストール
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"

# cargo install tree-sitter-cliでbindgenが見つけられない場合
ls /usr/lib/gcc/x86_64-linux-gnu/12/include/stdbool.h
export BINDGEN_EXTRA_CLANG_ARGS="-I/usr/lib/gcc/x86_64-linux-gnu/12/include"
cargo install tree-sitter-cli

# tree-sitter-cliをソースからビルド
cargo install tree-sitter-cli
tree-sitter --version

# .zshrcにパスが入っているかを確認
grep cargo ~/.zshrc
# ないなら追記
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.zshrc
```

