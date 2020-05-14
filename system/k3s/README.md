# [K3S 轻量级Kubernetes](https://k3s.io)
经过认证的Kubernetes发行版专为IoT和Edge计算而构建

## 安装
k3s默认使用containerd容器，可以通过增加--docker来使用docker容器。
```bash
# 使用默认的containerd容器
curl -sfL https://get.k3s.io | sh -

# 指定使用docker容器
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--docker" sh -
```

## 集群搭建
我这里使用一台Jetson Nano作为Master，三台Raspberry Pi4作为Worker。
```bash
# 在Jetson Nano中使用docker容器
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--docker" sh -

# 在Raspberry Pi4中使用默认的containerd容器
curl -sfL https://get.k3s.io | K3S_URL=https://myserver:6443 K3S_TOKEN=mynodetoken sh -
```
设置```K3S_URL```参数会使K3在工作模式下运行。 k3s代理将在K3s服务器上注册，侦听提供的URL。 用于```K3S_TOKEN```的值存储在服务器节点上的```/var/lib/rancher/k3s/server/node-token```中。

## 查看集群
* 配置检测
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

* 查看设备节点
```bash
sudo kubectl get nodes

NAME    STATUS   ROLES    AGE   VERSION
nano1   Ready    master   39h   v1.17.4+k3s1
rpi3    Ready    <none>   38h   v1.17.4+k3s1
rpi2    Ready    <none>   38h   v1.17.4+k3s1
rpi1    Ready    <none>   38h   v1.17.4+k3s1
```

## Dashboard(Web UI)
### 安装
```bash
sudo kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml
```

### RBAC配置
为了保护您的集群数据，默认情况下，Dashboard 会使用最少的 RBAC 配置进行部署。 当前，Dashboard 仅支持使用 Bearer 令牌登录。 
* 编辑文件：dashboard.admin-user.yml
```bash
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
```

* 编辑文件：dashboard.admin-user-role.yml
```bash
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
```

* 创建RBAC
```bash
sudo kubectl apply -f dashboard.admin-user.yml -f dashboard.admin-user-role.yml
```

* 获得Token
```bash
sudo kubectl -n kubernetes-dashboard describe secret admin-user-token | grep ^token
```

* 访问Dashboard
```bash
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
```

* 远程访问Dashboard
```bash
ssh -L 8001:127.0.0.1:8001 -N -f -l <username> <k8s master hostname or ip> 
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
* [K3s - Lightweight Kubernetes](https://rancher.com/docs/k3s/latest/en/)
* [K3s - Quick-Start Guide](https://rancher.com/docs/k3s/latest/en/quick-start/)
