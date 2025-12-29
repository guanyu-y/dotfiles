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
├── install.sh
└── README.md
```

## インストール

```bash
git clone https://github.com/your-username/dotfiles.git
cd dotfiles
./install.sh
```

## 環境変数の設定

インストール後、`~/.env.local` を編集して環境変数を設定してください：

```bash
# ~/.env.local

# Proxy settings
export HTTP_PROXY=http://your-proxy:port
export HTTPS_PROXY=http://your-proxy:port

# User info
export GIT_USER_NAME="Your Name"
export GIT_USER_EMAIL="your.email@example.com"

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
# Neovim用
sudo apt install ripgrep fd-find

# その他
sudo apt install tmux neovim
```

## 主要なキーバインド

### Neovim (リーダーキー: `,`)

| キー | 動作 |
| ---- | ---- |
| `<C-t>` | NvimTreeトグル |
| `<C-f>` | ファイル検索 (Telescope) |
| `<C-g>` | テキスト検索 (Telescope) |
| `<leader>cc` | Claude Code トグル |
| `<leader>/` | コメントトグル |
| `<leader>s` | 横分割 |
| `<leader>v` | 縦分割 |
| `<leader>y` | クリップボードにコピー |
| `gh/gj/gk/gl` | ペイン移動 |

### tmux (Prefix: `Ctrl-j`)

| キー | 動作 |
| ---- | ---- |
| `Prefix + s` | 横分割 |
| `Prefix + v` | 縦分割 |
| `Prefix + h/j/k/l` | ペイン移動 |
| `Prefix + r` | 設定リロード |

## ファイル構成

| ファイル | 説明 | 追跡 |
| -------- | ---- | ---- |
| `~/.env.local` | 環境変数 (プロキシ、APIキー等) | No |
| `~/.gitconfig.local` | Git個人設定 (名前、メール、プロキシ) | No |
| `~/.ssh/config` | SSH設定 | No |
| `nvim/nvim.env` | Neovim用APIキー | No |
