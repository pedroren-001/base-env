# 如果neovim没有安装
if ! command -v nvim > /dev/null; then
    echo "installing neovim"
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    sudo rm -rf /opt/nvim-linux-x86_64
    sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
    sudo ln -s /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
fi


mkdir -p ~/.config/nvim
cp templates/neovim/init.lua ~/.config/nvim/init.lua
cp -r templates/neovim/lsp ~/.config/nvim/lsp
cp -r templates/neovim/lua ~/.config/nvim/lua
