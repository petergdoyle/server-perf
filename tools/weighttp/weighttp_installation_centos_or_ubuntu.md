###weighttp

a lightweight and simple webserver benchmarking tool.

To install weighttp in ubuntu we need to install libev (It is libev not libdev) using the following command

sudo apt-get install libev4 libev-dev

or we can install libev for any linux and unix oses  from source using the following set of commands

wget http://dist.schmorp.de/libev/libev-4.22.tar.gz
tar xvf libev-4.22.tar.gz
cd libev-4.22
sudo ./configure
sudo make
sudo make install

Get the source code of weighttp from the github using the following command.

git clone https://github.com/lighttpd/weighttp.git

cd weighttp
./waf configure
./waf build
sudo ./waf install

to uninstall
sudo ./waf uninstall

To run weighttp use the following command
weighttp

Reference

https://github.com/lighttpd/weighttp
