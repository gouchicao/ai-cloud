# 狗吃草 Cloud
![](logo.jpg)

## [硬件](hardware)

## [系统](system)

## [运维](operation)

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
