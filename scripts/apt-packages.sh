tools=("make" "cmake" "subversion" "git" "fzf" "tmux" "universal-ctags")
for tool in "${tools[@]}"; do
    echo "installing $tool"
    sudo apt install -y $tool
done
