# 远程执行Shell命令
> 可以远程操作多台计算机

## 安装fabric
```bash
pip3 install fabric
```

## 打开 [fab.py](fab.py) 文件，修改您要远程操作的计算机信息，username@ip。

## 执行要操作的命令

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

## 参考资料
* [Welcome to Fabric!](https://www.fabfile.org/)
