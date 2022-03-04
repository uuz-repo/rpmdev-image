# rpmdev-image
用于构建 RPM 的镜像。

利用 rsync  实现 RPM 自动构建后的上传，利用 Inotify 实现 yum 索引自动更新。

## 使用 rsync 实现文件上传

### 服务器端
首先对 rsync 进行 daemon 配置：
```conf
# /etc/rsyncd.conf
[repo]
# 表示 repo 模块的根目录为 /data/rpms/
path = /data/rpms/
read only = no
auth users = repo
# 此文件格式为 user:passwd，并且权限需要设为 600
secrets file = /etc/rsyncd.secrets
```

执行命令启动 rsync 服务，以及开放端口：
```bash
systemctl start rsyncd
systemctl enable rsyncd
firewall-cmd --zone=public --add-port=873/tcp --permanent 
```

### 客户端
在 github ci 中配置命令：
```bash
export RSYNC_PASSWORD=${{secrets.RSYNC_PASSWORD}} && rsync -avSH  x86_64/*.rpm repo@<ip>::repo/centos/$(rpm -qf /etc/os-release --provides  | grep -E releasever | tail -n1 | awk '{print $3}')/os/$(arch)/
```

## 使用 inotify 实现 yum 索引自动更新


## 参考
[ius repo](https://ius.io/)
