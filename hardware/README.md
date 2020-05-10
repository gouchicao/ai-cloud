# 硬件

* 英特尔 NUC
* 树莓派4
* NVIDIA JETSON NANO

| 硬件         | 内存   | TF卡容量 | 个数 |
| :---        | ----:  | ----:  | ---:|
| 树莓派4      | 4G     | 32G    | 3   |
| JETSON NANO | 4G     | 64G    | 1   |

## Raspbian 镜像写入构建TF卡
> 用法：bash make.sh hostname [ip-suffix]
>      例：bash make.sh rpi1 101

* 写入[Raspbian Buster Lite](http://downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2020-02-14/2020-02-13-raspbian-buster-lite.zip)镜像
``` txt
下载Raspbian Buster Lite镜像保存到raspbian目录下。
修改make.sh文件中的IMAGE变量。
```

* 打开SSH
* 配置Wi-Fi
```json
修改dhcpcd.conf文件设置您的无线路由器的用户名和密码。

network={
    ssid="username"
    psk="password"
}
```

* 设置上海时区
``` txt
修改make.sh文件中的/usr/share/zoneinfo/Asia/Shanghai，设置您的时区。
```

* 配置静态IP
``` txt
根据您的需要修改wpa_supplicant.conf文件中的网段。

static ip_address=xxx.xxx.xxx.255/24
static routers=xxx.xxx.xxx.1
static domain_name_servers=xxx.xxx.xxx.1 8.8.8.8
```

* 不用密码登录
``` txt
运行命令：ssh-keygen -t rsa，在~/.ssh/目录下生成id_rsa和id_rsa.pub两个文件。
修改make.sh文件中的YOUR_PUBLIC_KEY变量。
客户端登录时需要id_rsa，直接运行命令：ssh pi@rpi1
```
