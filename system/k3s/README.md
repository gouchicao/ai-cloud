# K3S 轻量级Kubernetes
经过认证的Kubernetes发行版专为IoT和Edge计算而构建

## K3S如何工作
![](https://k3s.io/images/how-it-works-k3s.svg)

## 安装K3S
> k3s默认使用containerd容器，可以通过增加--docker来使用docker容器。

* 使用默认的containerd容器
```bash
curl -sfL https://get.k3s.io | sh -
```

* 指定使用docker容器
```bash
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--docker" sh -
```

## 卸载K3S
* 卸载Server节点
```bash
/usr/local/bin/k3s-uninstall.sh
```

* 卸载Agent节点
```bash
/usr/local/bin/k3s-agent-uninstall.sh
```

## 安装Docker
```bash
curl -sfL https://get.docker.com | sh -
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

## 集群搭建
> 我这里使用一台 ```小主机``` 作为 **Server**，三台 ```Raspberry Pi4``` 和一台 ```Jetson Nano``` 作为 **Agent**。

### **Server节点**
```bash
# 使用docker容器
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--docker" sh -

# 查看集群信息
sudo kubectl cluster-info
Kubernetes master is running at https://127.0.0.1:6443
CoreDNS is running at https://127.0.0.1:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
Metrics-server is running at https://127.0.0.1:6443/api/v1/namespaces/kube-system/services/https:metrics-server:/proxy

# 查看token
sudo cat /var/lib/rancher/k3s/server/node-token
K100eafa2c79d548460322584a02c4b62708cf16bad0a4b33254b4c37a88e33d29d::server:972070ca134501f3afc130f3182cb213
```

### **Agent节点**
安装k3s代理。设置```K3S_URL```参数会使K3在Worker模式下运行，k3s代理将在k3s服务器上注册，侦听提供的URL。 用于```K3S_TOKEN```的值存储在服务器节点上的```/var/lib/rancher/k3s/server/node-token```中，参考上面。

```bash
# 在Jetson Nano中使用Docker容器
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--docker" K3S_URL=https://myserver:6443 K3S_TOKEN=mynodetoken sh -

# 在Raspberry Pi4中使用默认的containerd容器
curl -sfL https://get.k3s.io | K3S_URL=https://myserver:6443 K3S_TOKEN=mynodetoken sh -

# 验证k3s代理服务状态
sudo systemctl status k3s-agent
```


## 查看节点信息
* 节点信息
```bash
sudo kubectl get nodes

NAME    STATUS   ROLES    AGE    VERSION
aiot    Ready    master   8m4s   v1.18.3+k3s1
nano1   Ready    <none>   15s    v1.18.3+k3s1
rpi2    Ready    <none>   27s    v1.18.3+k3s1
rpi3    Ready    <none>   25s    v1.18.3+k3s1
rpi1    Ready    <none>   27s    v1.18.3+k3s1
```

* 节点详细信息
```bash
sudo kubectl get nodes -o wide

NAME    STATUS   ROLES    AGE     VERSION        INTERNAL-IP     EXTERNAL-IP   OS-IMAGE                         KERNEL-VERSION     CONTAINER-RUNTIME
aiot    Ready    master   8m51s   v1.18.3+k3s1   192.168.3.110   <none>        Ubuntu 20.04 LTS                 5.4.0-37-generic   docker://19.3.11
nano1   Ready    <none>   62s     v1.18.3+k3s1   192.168.3.100   <none>        Ubuntu 18.04.4 LTS               4.9.140-tegra      docker://19.3.8
rpi2    Ready    <none>   74s     v1.18.3+k3s1   192.168.3.102   <none>        Raspbian GNU/Linux 10 (buster)   4.19.97-v7l+       containerd://1.3.3-k3s2
rpi3    Ready    <none>   72s     v1.18.3+k3s1   192.168.3.103   <none>        Raspbian GNU/Linux 10 (buster)   4.19.97-v7l+       containerd://1.3.3-k3s2
rpi1    Ready    <none>   74s     v1.18.3+k3s1   192.168.3.101   <none>        Raspbian GNU/Linux 10 (buster)   4.19.97-v7l+       containerd://1.3.3-k3s2
```


## 远程连接到集群
如果不想每次操作集群时都通过 **SSH** 连接到节点，则可以在本地计算机安装 ```kubectl(Kubernetes命令行工具)``` 进行远程控制集群。
1. 在本地计算机[安装kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) ，下面是我在macOS下安装的步骤。
    * 下载最新的版本。
    ```bash
    curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/darwin/amd64/kubectl"
    ```
    * 增加 kubectl 可执行权限。
    ```bash
    chmod +x ./kubectl
    ```
    * 移动 kubectl 到您的PATH下。
    ```bash
    sudo mv kubectl /usr/local/bin/kubectl
    ```
    * 验证您安装的版本。
    ```bash
    kubectl version --client
    ```

2. 将 ```k3s Master 节点```的配置文件复制到本地计算机。
    * 复制配置文件
    ```bash
    sudo scp wjj@aiot:/etc/rancher/k3s/k3s.yaml ~/.kube/config
    ```
    * 修改配置文件的 ```Master IP```
    ```bash
    sudo sed -ie s/127.0.0.1/192.168.3.110/g ~/.kube/config
    ```

3. 现在试试在本地计算机的命令行下使用 ```kubectl```
    ```bash
    sudo kubectl get node -o wide

    NAME    STATUS   ROLES    AGE     VERSION        INTERNAL-IP     EXTERNAL-IP   OS-IMAGE                         KERNEL-VERSION     CONTAINER-RUNTIME
    aiot    Ready    master   17m     v1.18.3+k3s1   192.168.3.110   <none>        Ubuntu 20.04 LTS                 5.4.0-37-generic   docker://19.3.11
    rpi1    Ready    <none>   9m33s   v1.18.3+k3s1   192.168.3.101   <none>        Raspbian GNU/Linux 10 (buster)   4.19.97-v7l+       containerd://1.3.3-k3s2
    rpi2    Ready    <none>   9m33s   v1.18.3+k3s1   192.168.3.102   <none>        Raspbian GNU/Linux 10 (buster)   4.19.97-v7l+       containerd://1.3.3-k3s2
    rpi3    Ready    <none>   9m31s   v1.18.3+k3s1   192.168.3.103   <none>        Raspbian GNU/Linux 10 (buster)   4.19.97-v7l+       containerd://1.3.3-k3s2
    nano1   Ready    <none>   9m21s   v1.18.3+k3s1   192.168.3.100   <none>        Ubuntu 18.04.4 LTS               4.9.140-tegra      docker://19.3.8
    ```

4. 不用管理员权限一样操作
    ```bash
    sudo chmod 644 ~/.kube/config

    #试试不带sudo操作一下吧。
    ```

## 集群配置检测
```bash
sudo k3s check-config

Verifying binaries in /var/lib/rancher/k3s/data/4045c71e845badc259ce3efe3d23951869a3ba42d6506af150c924850076c651/bin:
- sha256sum: good
- links: good

System:
- /sbin iptables v1.6.1: older than v1.8
- swap: should be disabled
- routes: default CIDRs 10.42.0.0/16 or 10.43.0.0/16 already routed

Limits:
- /proc/sys/kernel/keys/root_maxkeys: 1000000

info: reading kernel config from /proc/config.gz ...

Generally Necessary:
- cgroup hierarchy: properly mounted [/sys/fs/cgroup]
- CONFIG_NAMESPACES: enabled
- CONFIG_NET_NS: enabled
- CONFIG_PID_NS: enabled
- CONFIG_IPC_NS: enabled
- CONFIG_UTS_NS: enabled
- CONFIG_CGROUPS: enabled
- CONFIG_CGROUP_CPUACCT: enabled
- CONFIG_CGROUP_DEVICE: enabled
- CONFIG_CGROUP_FREEZER: enabled
- CONFIG_CGROUP_SCHED: enabled
- CONFIG_CPUSETS: enabled
- CONFIG_MEMCG: enabled
- CONFIG_KEYS: enabled
- CONFIG_VETH: enabled (as module)
- CONFIG_BRIDGE: enabled
- CONFIG_BRIDGE_NETFILTER: enabled (as module)
- CONFIG_NF_NAT_IPV4: enabled (as module)
- CONFIG_IP_NF_FILTER: enabled (as module)
- CONFIG_IP_NF_TARGET_MASQUERADE: enabled (as module)
- CONFIG_NETFILTER_XT_MATCH_ADDRTYPE: enabled (as module)
- CONFIG_NETFILTER_XT_MATCH_CONNTRACK: enabled (as module)
- CONFIG_NETFILTER_XT_MATCH_IPVS: enabled (as module)
- CONFIG_IP_NF_NAT: enabled (as module)
- CONFIG_NF_NAT: enabled (as module)
- CONFIG_NF_NAT_NEEDED: enabled
- CONFIG_POSIX_MQUEUE: enabled

Optional Features:
- CONFIG_USER_NS: enabled
- CONFIG_SECCOMP: enabled
- CONFIG_CGROUP_PIDS: enabled
- CONFIG_BLK_CGROUP: enabled
- CONFIG_BLK_DEV_THROTTLING: enabled
- CONFIG_CGROUP_PERF: enabled
- CONFIG_CGROUP_HUGETLB: enabled
- CONFIG_NET_CLS_CGROUP: enabled
- CONFIG_CGROUP_NET_PRIO: enabled
- CONFIG_CFS_BANDWIDTH: enabled
- CONFIG_FAIR_GROUP_SCHED: enabled
- CONFIG_RT_GROUP_SCHED: missing
- CONFIG_IP_NF_TARGET_REDIRECT: enabled (as module)
- CONFIG_IP_SET: missing
- CONFIG_IP_VS: enabled (as module)
- CONFIG_IP_VS_NFCT: enabled
- CONFIG_IP_VS_PROTO_TCP: enabled
- CONFIG_IP_VS_PROTO_UDP: enabled
- CONFIG_IP_VS_RR: enabled (as module)
- CONFIG_EXT4_FS: enabled
- CONFIG_EXT4_FS_POSIX_ACL: enabled
- CONFIG_EXT4_FS_SECURITY: enabled
- Network Drivers:
  - "overlay":
    - CONFIG_VXLAN: enabled
      Optional (for encrypted networks):
      - CONFIG_CRYPTO: enabled
      - CONFIG_CRYPTO_AEAD: enabled
      - CONFIG_CRYPTO_GCM: enabled
      - CONFIG_CRYPTO_SEQIV: enabled
      - CONFIG_CRYPTO_GHASH: enabled
      - CONFIG_XFRM: enabled
      - CONFIG_XFRM_USER: enabled
      - CONFIG_XFRM_ALGO: enabled
      - CONFIG_INET_ESP: enabled (as module)
      - CONFIG_INET_XFRM_MODE_TRANSPORT: enabled
- Storage Drivers:
  - "overlay":
    - CONFIG_OVERLAY_FS: enabled (as module)

STATUS: pass
```


## 安装[helm](https://github.com/openfaas/faas-netes/blob/master/HELM.md)
```bash
curl -sSLf https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
```


## 在Raspbian Buster上启用旧版iptables
Raspbian Buster默认使用nftables而不是iptables。 K3S网络功能需要iptables，不能与nftables一起使用。 请按照以下步骤将“配置Buster”配置为使用旧iptables：
```bash
sudo iptables -F
sudo update-alternatives --set iptables /usr/sbin/iptables-legacy
sudo update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
sudo reboot
```


## 参考资料
* [K3S](https://k3s.io)
* [K3s - Lightweight Kubernetes](https://rancher.com/docs/k3s/latest/en/)
* [K3s - Quick-Start Guide](https://rancher.com/docs/k3s/latest/en/quick-start/)
* [Install and Set Up kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [How to configure static IP address on Ubuntu 18.10 Cosmic Cuttlefish Linux](https://linuxconfig.org/how-to-configure-static-ip-address-on-ubuntu-18-10-cosmic-cuttlefish-linux)
* [Ubuntu安装程序报错：无法获得锁 /var/lib/dpkg/lock-frontend - open (11: 资源暂时不可用)](https://www.cnblogs.com/python-wen/p/11023944.html)
* [Mount USB in Ubuntu Server](http://azaleasays.com/2012/05/22/mount-usb-in-ubuntu-server/)