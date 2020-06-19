# 关闭交换区

## 相关命令
* 查看交换区信息
```bash
swapon --show

NAME      TYPE SIZE USED PRIO
/swapfile file   2G   0B   -2
```

* 启用 /etc/fstab 中的所有交换区
```bash
swapon -a
```

* 禁用 /proc/swaps 中的所有交换区（重启系统后失效）
```bash
swapoff -a
```

* 查看内存信息
```
free -h

              总计         已用        空闲      共享    缓冲/缓存    可用
内存：        7.7G        338M        6.9G         66M        498M        7.1G
交换：        1.9G          0B        1.9G
```

## 小主机 x86(Ubuntu 18.04.4)

* 查看交换区信息
```bash
swapon --show

NAME      TYPE SIZE USED PRIO
/swapfile file   2G   0B   -2
```

* 查看内存信息
```
free -h

              总计         已用        空闲      共享    缓冲/缓存    可用
内存：        7.7G        338M        6.9G         66M        498M        7.1G
交换：        1.9G          0B        1.9G
```

* ```注释 /etc/fstab 文件中的 /swapfile 一行```
```bash
sudo nano /etc/fstab

# /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a
# device; this may be used with UUID= as a more robust way to name devices
# that works even if disks are added and removed. See fstab(5).
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
# / was on /dev/sda2 during installation
UUID=6f99d2a2-5d88-4627-bff2-f1d1dec38603 /               ext4    errors=remount-ro 0       1
# /boot/efi was on /dev/sda1 during installation
UUID=9C28-932D  /boot/efi       vfat    umask=0077      0       1
#/swapfile                                 none            swap    sw              0       0
```

* 重启
```bash
sudo reboot
```

## Jetson Nano(Jetson Nano Developer Kit Ubuntu 18.04.4)

* 查看交换区信息
```bash
swapon --show

NAME       TYPE        SIZE USED PRIO
/dev/zram0 partition 495.5M   0B    5
/dev/zram1 partition 495.5M   0B    5
/dev/zram2 partition 495.5M   0B    5
/dev/zram3 partition 495.5M   0B    5
```

* 查看内存信息
```bash
free -h

              total        used        free      shared  buff/cache   available
Mem:           3.9G        505M        2.8G         27M        636M        3.2G
Swap:          1.9G          0B        1.9G
```

* ```禁用 nvzramconfig 服务```
```bash
sudo systemctl disable nvzramconfig
Removed /etc/systemd/system/multi-user.target.wants/nvzramconfig.service.
```

* 重启
```bash
sudo reboot
```

## Raspberry PI4(Raspbian Buster Lite)

* 查看交换区信息
```bash
swapon --show

NAME      TYPE SIZE USED PRIO
/var/swap file 100M   0B   -2
```

* 查看内存信息
```bash
free -h

              total        used        free      shared  buff/cache   available
Mem:          3.8Gi       185Mi       3.0Gi        73Mi       608Mi       3.5Gi
Swap:          99Mi          0B        99Mi
```

* ```修改 /etc/dphys-swapfile 文件 CONF_SWAPSIZE=0```
```bash
sudo nano /etc/dphys-swapfile

# /etc/dphys-swapfile - user settings for dphys-swapfile package
# author Neil Franklin, last modification 2010.05.05
# copyright ETH Zuerich Physics Departement
#   use under either modified/non-advertising BSD or GPL license

# this file is sourced with . so full normal sh syntax applies

# the default settings are added as commented out CONF_*=* lines


# where we want the swapfile to be, this is the default
#CONF_SWAPFILE=/var/swap

# set size to absolute value, leaving empty (default) then uses computed value
#   you most likely don't want this, unless you have an special disk situation
CONF_SWAPSIZE=0

# set size to computed value, this times RAM size, dynamically adapts,
#   guarantees that there is enough swap without wasting disk space on excess
#CONF_SWAPFACTOR=2

# restrict size (computed and absolute!) to maximally this limit
#   can be set to empty for no limit, but beware of filled partitions!
#   this is/was a (outdated?) 32bit kernel limit (in MBytes), do not overrun it
#   but is also sensible on 64bit to prevent filling /var or even / partition
#CONF_MAXSWAP=2048
```

* 重启
```bash
sudo reboot
```

## 参考资料
* [How can I check if swap is active from the command line?](https://unix.stackexchange.com/questions/23072/how-can-i-check-if-swap-is-active-from-the-command-line)
* [Permanently disable swap on Raspbian Buster](https://www.raspberrypi.org/forums/viewtopic.php?t=244130)
* [Linux sed 命令](https://www.runoob.com/linux/linux-comm-sed.html)
