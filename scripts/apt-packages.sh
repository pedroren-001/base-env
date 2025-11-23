tools=("make" "cmake" "subversion" "git")
for tool in "${tools[@]}"; do
    echo "installing $tool"
    sudo apt install -y $tool
done
