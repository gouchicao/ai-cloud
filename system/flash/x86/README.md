# 安装[Ubuntu 20.04](https://cn.ubuntu.com/download)

### 配置静态IP
```
打开网络配置，选择Wired -> Options...，在编辑对话框中选择IPv4 Settings，Method中选择Manual(手动)，配置您的静态IP信息。
```

### SSH 使用密匙登录
```
将您的公匙id_rsa.pub文件分发到Raspbian系统的/home/username/.ssh/目录下，文件名改为authorized_keys。
```

### 更新系统组件
```bash
sudo apt update
sudo apt dist-upgrade
```

### 安装curl
```bash
sudo apt install curl
```

## 安装ssh服务
```bash
sudo apt install openssh-server
```
