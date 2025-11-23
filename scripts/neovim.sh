# 如果neovim没有安装
if [ command -v nvim > /dev/null ]; then
    echo "neovim is installed. skipped"
    exit 1
fi

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
sudo ln -s /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim

mkdir -p ~/.config/nvim
cp templates/nvim/init.vim ~/.config/nvim/init.vim
cp templates/nvim/lsp ~/.config/nvim/lsp
cp templates/nvim/lua ~/.config/nvim/lua
