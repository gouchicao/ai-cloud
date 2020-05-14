# Flash [JetPack](https://developer.nvidia.com/embedded/jetpack)

## 下载 Jetson Nano Developer Kit
* [Jetson Nano Developer Kit](https://developer.nvidia.com/embedded/jetpack)

## 手动
### Flash ```Jetson Nano Developer Kit``` to SD卡
```
打开Etcher程序。选择Jetson Nano Developer Kit镜像，插入要烧入的SD卡，Etcher程序会自动检测到并自动选择，单击Flash!。
```

### 插入SD卡到Jetson Nano，通电启动，根据向导设置用户名、密码等信息。

### 配置静态IP
```
打开网络配置，选择Wired -> Options...，在编辑对话框中选择IPv4 Settings，Method中选择Manual(手动)，配置您的静态IP信息。
```

### SSH 使用密匙登录
```
将您的公匙id_rsa.pub文件分发到Raspbian系统的/home/username/.ssh/目录下，文件名改为authorized_keys。
```

### 安装[jtop](https://pypi.org/project/jetson-stats/)，用于实时监控Jetson的硬件状态。
```bash
sudo -H pip install -U jetson-stats
sudo jtop
```

### 显示设备的详细信息
```
jetson_release -v

 - NVIDIA Jetson Nano (Developer Kit Version)
   * Jetpack 4.4 DP [L4T 32.4.2]
   * NV Power Mode: MAXN - Type: 0
   * jetson_clocks service: inactive
 - Board info:
   * Type: Nano (Developer Kit Version)
   * SOC Family: tegra210 - ID:33
   * Module: P3448-0000 - Board: P3449-0000
   * Code Name: porg
   * Boardids: 3448
   * CUDA GPU architecture (ARCH_BIN): 5.3
   * Serial Number: 1422919148586
 - Libraries:
   * CUDA: 10.2.89
   * cuDNN: 8.0.0.145
   * TensorRT: 7.1.0.16
   * Visionworks: 1.6.0.501
   * OpenCV: 4.1.1 compiled CUDA: NO
   * VPI: 0.2.0
   * Vulkan: 1.2.70
 - jetson-stats:
   * Version 2.1.0
   * Works on Python 3.6.9
```

### 更新系统组件
```
sudo apt update
sudo apt dist-upgrade
```

### 安装curl
```
sudo apt install curl
```
