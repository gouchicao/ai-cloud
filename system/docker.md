# Docker

## 安装Docker
```bash
curl -fsSL https://get.docker.com | sh -
```

## 卸载Docker
* 删除Docker及其依赖
```bash
sudo apt-get remove --auto-remove docker
```

* 删除所有数据
```bash
sudo rm -rf /var/lib/docker
```

## 非root用户身份使用Docker
> 将您的用户添加到“ docker”组中。注：您必须先注销然后重新登录才能生效！
```bash
sudo usermod -aG docker username
```
