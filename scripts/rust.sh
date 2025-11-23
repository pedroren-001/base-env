# 没有rustup命令，才安装
echo "installing rust"
if ! command -v rustup &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    source "$HOME/.cargo/env"
else
    echo "rustup already installed. skipping"
fi

# 装一些工具
tools=("ripgrep" "aichat" "gitui")
for tool in "${tools[@]}"; do
    echo "installing $tool"
    cargo install $tool
done
