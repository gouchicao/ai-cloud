# Cloud Lab
![](logo.jpg)

## [硬件](hardware)
| 主机                                                                            | 内存   | 电源存储容量 | 适配器 | 散热片 | 高清接口  |　Wi-Fi<br>蓝牙 | 主机 | 用户 | 密码 |
| :---                                                                           | ----:  | ----:     | ---: | ---: | ---:      | ---: | ---: | ---:| ---: |
| 小主机 | 8G | 128G | 12V5A | 自带 | HDMI | 自带 | aiot | wjj | |
| [Raspberry Pi 4](https://www.raspberrypi.org/products/raspberry-pi-4-model-b/) | 4G     | 32G       | 5V3A | 无   | Micro HDMI | 自带 | rpi1  | pi  | raspberry |
| [Raspberry Pi 4](https://www.raspberrypi.org/products/raspberry-pi-4-model-b/) | 4G     | 32G       | 5V3A | 无   | Micro HDMI | 自带 | rpi2  | pi  | raspberry |
| [Raspberry Pi 4](https://www.raspberrypi.org/products/raspberry-pi-4-model-b/) | 4G     | 32G       | 5V3A | 无   | Micro HDMI | 自带 | rpi3  | pi  | raspberry |
| [Jetson Nano B01](https://developer.nvidia.com/embedded/jetson-nano)           | 4G     | 64G       | 5V4A | 自带 | HDMI       | 无   | nano1 | nano| jetson    |

## [系统](system)

## 远程操作多台计算机
### 安装fabric
```bash
pip3 install fabric
```

### 打开 [fab.py](fab.py) 文件，修改您要远程操作的计算机信息，username@ip。

### 执行要操作的命令
* 输出系统信息
```bash
python3 fab.py "uname -a"
What's your sudo password? ＃不需要管理员权限的命令可以直接回车
```
```txt
Linux rpi1 4.19.97-v7l+ #1294 SMP Thu Jan 30 13:21:14 GMT 2020 armv7l GNU/Linux
Linux rpi2 4.19.97-v7l+ #1294 SMP Thu Jan 30 13:21:14 GMT 2020 armv7l GNU/Linux
Linux rpi3 4.19.97-v7l+ #1294 SMP Thu Jan 30 13:21:14 GMT 2020 armv7l GNU/Linux
```

* 安装docker
```bash
python3 fab.py "curl -sfL https://get.k3s.io | sh -"
What's your sudo password? ＃输入您的管理员密码
```


## 解决 GitHub 图片不显示问题
### 各系统的```hosts```文件路径
* macOS
```
/etc/hosts
```
* Linux
```
/etc/hosts
```
* Windows
```
C:\Windows\System32\drivers\etc\hosts
```

### 编辑系统的```hosts```文件，在后面增加下面的文本。
```txt
# GitHub Start
192.30.253.112    github.com
192.30.253.119    gist.github.com
151.101.184.133    assets-cdn.github.com
151.101.184.133    raw.githubusercontent.com
151.101.184.133    gist.githubusercontent.com
151.101.184.133    cloud.githubusercontent.com
151.101.184.133    camo.githubusercontent.com
151.101.184.133    avatars0.githubusercontent.com
151.101.184.133    avatars1.githubusercontent.com
151.101.184.133    avatars2.githubusercontent.com
151.101.184.133    avatars3.githubusercontent.com
151.101.184.133    avatars4.githubusercontent.com
151.101.184.133    avatars5.githubusercontent.com
151.101.184.133    avatars6.githubusercontent.com
151.101.184.133    avatars7.githubusercontent.com
151.101.184.133    avatars8.githubusercontent.com
# GitHub End
```

## 参考资料
* [Welcome to Fabric!](https://www.fabfile.org/)
