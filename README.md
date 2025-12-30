# dotfiles

WSL環境用の設定ファイル集

## 構成

```text
dotfiles/
├── nvim/                   # Neovim設定 (lazy.nvim + Lua)
│   ├── init.lua
│   └── lua/
│       ├── core/           # 基本設定
│       └── plugins/        # プラグイン設定
├── tmux/                   # tmux設定
│   ├── tmux.conf
│   └── bin/
├── bash/                   # Bash設定
│   ├── bashrc
│   ├── bash_profile
│   ├── bash_aliases
│   └── env.template        # 環境変数テンプレート
├── git/                    # Git設定
│   ├── gitconfig
│   └── gitconfig.local.template
├── ssh/                    # SSH設定テンプレート
│   └── config.template
├── fzf/                    # fzf設定
│   └── fzf.bash
├── docs/                   # リファレンス
│   ├── nvim-reference.md
│   └── tmux-reference.md
├── install.sh
└── README.md
```

## インストール

```bash
git clone https://github.com/your-username/dotfiles.git
cd dotfiles
./install.sh
```

個別インストール:

```bash
./install.sh nvim      # Neovimのみ
./install.sh tmux bash # tmuxとbashのみ
./install.sh fzf       # fzfのみ
./install.sh -h        # ヘルプ
```

## 環境変数の設定

インストール後、`~/.env.local` を編集して環境変数を設定してください：

```bash
# ~/.env.local

# Proxy settings
export HTTP_PROXY=http://your-proxy:port
export HTTPS_PROXY=http://your-proxy:port

# Windows integration (WSL)
export WINDOWS_USER="your_windows_username"
export KIRO_PATH="/mnt/c/Users/${WINDOWS_USER}/AppData/Local/Programs/Kiro/bin"

# API Keys
export OPENAI_API_KEY="your-api-key"
```

## Gitの設定

`~/.gitconfig.local` を編集して名前とメールアドレスを設定：

```ini
[user]
    name = Your Name
    email = your.email@example.com

[http]
    proxy = http://your-proxy:port
```

## 必要なツール

```bash
# Neovim / fzf用
sudo apt install ripgrep fd-find

# fzf (fuzzy finder)
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# その他
sudo apt install tmux neovim
```

## リファレンス

- [Neovim / NvimTree キーバインド](docs/nvim-reference.md)
- [tmux キーバインド](docs/tmux-reference.md)

## ファイル構成

| ファイル             | 説明                                 | 追跡 |
| -------------------- | ------------------------------------ | ---- |
| `~/.env.local`       | 環境変数 (プロキシ、APIキー等)       | No   |
| `~/.gitconfig.local` | Git個人設定 (名前、メール、プロキシ) | No   |
| `~/.ssh/config`      | SSH設定                              | No   |
| `nvim/nvim.env`      | Neovim用APIキー                      | No   |
