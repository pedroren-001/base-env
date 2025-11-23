mkdir -p temp/lua/
wget -O temp/lua/lua-5.3.6.tar.gz https://www.lua.org/ftp/lua-5.3.6.tar.gz
mkdir -p temp/src/lua-5.3
tar -xzf temp/lua/lua-5.3.6.tar.gz -C temp/src/lua-5.3
cd temp/src/lua-5.3
make && sudo make install
