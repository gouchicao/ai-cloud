# Flash

## Flash OS
* [Raspbian](raspbian)
* [Jetson Nano Developer Kit](jetpack)

## Flash OS 工具
### [Etcher](https://www.balena.io/etcher/)
* 添加安装源
```bash
echo "deb https://deb.etcher.io stable etcher" | sudo tee /etc/apt/sources.list.d/balena-etcher.list
sudo apt-key adv --keyserver hkps://keyserver.ubuntu.com:443 --recv-keys 379CE192D401AB61
```

* 安装
```bash
sudo apt-get update
sudo apt-get install balena-etcher-electron
```

* 运行
    > 应用程序中单击程序 balenaEtcher。

* 卸载
```bash
sudo apt-get remove etcher-electron
sudo rm /etc/apt/sources.list.d/etcher.list
```
