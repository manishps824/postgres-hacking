# Below script is what I ended up using to compile postgres
# on my Ubuntu VM
# uname -a
#    Linux ip-172-31-10-102 5.15.0-1031-aws #35-Ubuntu SMP Fri Feb 10 02:07:18 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux
# apt --version
#    apt 2.4.8 (amd64)

git clone https://github.com/postgres/postgres.git
cd postgres/
git checkout REL_15_STABLE
sudo apt-get update 
perl -V
openssl version
sudo apt install make 
make --version
sudo apt install tar
sudo apt install zip
sudo apt install unzip
sudo apt install bzip2
sudo apt install flex
sudo apt install bison
sudo apt install libreadline6-dev
sudo apt install zlib1g-dev
sudo apt install pkg-config
sudo apt install liblz4-dev
sudo apt install libssl-dev
sudo apt install libossp-uuid-dev
export CFLAGS='-O1';./configure --with-lz4 --with-ssl=openssl --with-uuid=ossp --with-pgport=4365 --enable-debug --enable-cassert  --enable-depend 
make world
make check
sudo make install
ls /usr/local/pgsql/
