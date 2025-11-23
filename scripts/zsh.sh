# 安装ZSH
if [ ! command -v zsh &> /dev/null]; then
    sudo apt install zsh -y
fi

# 安装oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 拷贝template配置
cp template/zsh/* ~/
