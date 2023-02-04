sudo apt update
sudo apt install build-essential git make libelf-dev clang strace tar bpfcc-tools linux-headers-$(uname -r) gcc-multilib
cd /tmp
git clone --depth 1 git://kernel.ubuntu.com/ubuntu/ubuntu-bionic.git
sudo mv ubuntu-bionic /kernel-src
cd /kernel-src/tools/lib/bpf
sudo make && sudo make install prefix=/usr/local
sudo mv /usr/local/lib64/libbpf.* /lib/x86_64-linux-gnu/
