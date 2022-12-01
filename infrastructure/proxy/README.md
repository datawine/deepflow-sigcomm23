# proxy

- bash_switch.sh: bash自动化修改
- config.json: v2ray的config，默认路径位于/usr/local/etc/v2ray/config.json
- containerd_switch.sh: containerd自动修改，主要修改/etc/systemd/system/containerd.service.d/http-proxy.conf文件
- docker_switch.sh: docker自动修改，主要修改/etc/systemd/system/docker.service.d/http-proxy.conf
- http-proxy.conf: containerd和docker的http-proxy原型
- install.md: v2ray安装脚本
- v2ray_switch.sh: v2ray的active/inactive切换

```bash

# install v2ray

sh v2ray_switch.sh

sh bash_switch.sh username

sh docker_switch.sh

sh containerd_switch.sh

```