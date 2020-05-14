# Flash [Raspbian](https://www.raspberrypi.org/downloads/raspbian/)

## 下载树莓派系统
* [Raspbian Buster Lite](https://www.raspberrypi.org/downloads/raspbian/)

    默认用户：pi
    
    密码：baspberry

## 手动
### Flash Raspbian to SD卡
```
打开Etcher程序。选择Raspbian Lite镜像，插入要烧入的SD卡，Etcher程序会自动检测到并自动选择，单击Flash!。
```

### 启用 SSH 远程登录
在boot分区创建ssh空文件。
```bash
touch $BOOT/ssh
```

### 配置 Wi-Fi
复制[wpa_supplicant.conf](wpa_supplicant.conf)文件到boot分区。
```bash
cp wpa_supplicant.conf $BOOT/

编辑 $BOOT/wpa_supplicant.conf 文件，修改ssid和psk为您的路由器信息。
network={
    ssid="Youku"
    psk="1234567890"
}
```

### 配置静态IP
编辑 $ROOT/etc/dhcpcd.conf 文件，根据您的需求进行设置。
```
interface wlan0 # 如果是Wi-Fi使用wlan0，以太网使用eth0。
static ip_address=192.168.3.100/24
static routers=192.168.3.1
static domain_name_servers=192.168.3.1 8.8.8.8
```

### SSH 使用密匙登录
运行命令：```ssh-keygen -t rsa```，在~/.ssh/目录下生成私匙id_rsa和公匙id_rsa.pub两个文件。
```bash
ssh-keygen -t rsa
Generating public/private rsa key pair.
Enter file in which to save the key (/home/username/.ssh/id_rsa): 直接回车
Enter passphrase (empty for no passphrase): 直接回车
Enter same passphrase again: 直接回车
Your identification has been saved in /home/username/.ssh/id_rsa.
Your public key has been saved in /home/username/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:foo-YWwIv/a/HGEGt9P6vvmff/QjBGEvzlYM4hBWeR0 username@hostname
The key's randomart image is:
+---[RSA 2048]----+
|         +oo.ooE.|
|        . o..o+. |
|      . .  .. .+ |
|  .    o o  o.o  |
|   o o  S .  +.  |
|    o =+ +  .. ..|
|     + .+ . . o..|
|    o .o = . + .o|
|   . o+o=o+o. o..|
+----[SHA256]-----+
```

树莓派默认是pi用户，将公匙id_rsa.pub文件分发到Raspbian系统的/home/pi/.ssh/目录下，文件名改为authorized_keys。远程登录树莓派即可直接登录，如：ssh pi@rpi1

### 设置本地时区
启动树莓派系统，从系统目录 /usr/share/zoneinfo/ 中选择您所在的时区，运行下列命令。
```bash
sudo timedatectl set-timezone Asia/Shanghai

#查看系统的时区
ll /etc/localtime
```

## 自动
### 自动化脚本 [flash.sh](flash.sh)
    用法：bash flash.sh hostname [ip-suffix]
    示例：bash flash.sh rpi1 101

### 修改您要写入的设备名。
``` bash
lsblk
```
    修改flash.sh文件中的DEV变量为要写入的设备名。

### 修改Raspbian系统文件路径。
    修改flash.sh文件中的IMAGE变量。

### 修改无线路由器信息。
    修改wpa_supplicant.conf文件设置您的无线路由器的用户名和密码。

### 配置静态IP的网段。
``` txt
修改dhcpcd.conf文件中的网段。

static ip_address=xxx.xxx.xxx.255/24
static routers=xxx.xxx.xxx.1
static domain_name_servers=xxx.xxx.xxx.1 8.8.8.8
```

### 修改您的公匙路径。
    修改flash.sh文件中的YOUR_PUBLIC_KEY变量。

## 参考资料
* [Setting timezone non-interactively](https://raspberrypi.stackexchange.com/questions/87164/setting-timezone-non-interactively)