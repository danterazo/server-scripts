sudo apt install g++ pkg-config git git-buildpackage pandoc debhelper libfuse-dev libattr1-dev -y
git clone https://github.com/trapexit/mergerfs.git 
cd mergerfs
make clean
make deb
cd ..
sudo dpkg -i mergerfs*_amd64.deb
rm mergerfs*_amd64.deb mergerfs*_amd64.changes mergerfs*.dsc mergerfs*.tar.gz
