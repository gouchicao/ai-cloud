# Harbor

## 安装Harbor

### 安装Docker-Compose
```bash
sudo apt install docker-compose
```

### 下载最新的Harbar Release
```bash
wget -c https://github.com/goharbor/harbor/releases/download/v2.1.0-rc1/harbor-offline-installer-v2.1.0-rc1.tgz
tar -zxvf harbor-offline-installer-v2.1.0-rc1.tgz 
```

### 修改配置文件
> 在harbor.yml文件中配置参数 ```hostname```, ```harbor_admin_password```, ```data_volume```，注释掉```https```相关配置项。
```bash
cp harbor.yml.tmpl harbor.yml
nano harbor.yml
```

### 运行prepare脚本
```bash
sudo ./prepare 
```

### 运行install脚本
```bash
sudo ./install.sh 
```

### 修改Docker配置
> 因为没有配置HTTPS，所以要修改Docker的配置文件
```bash
nano /etc/docker/daemon.json 
{
    "insecure-registries":["172.16.33.157"]
}
```

### 重启Docker
```bash
sudo systemctl reload docker
```

### 重启Harbor
```bash
sudo docker-compose up -d
```

## 配置HTTPS访问Harbor
> 在生产环境中，请始终使用HTTPS，您应该从CA获得证书。 在测试或开发环境中，您可以生成自己的CA。

### 生成CA证书
1. 生成CA证书私钥
```bash
openssl genrsa -out ca.key 4096
Generating RSA private key, 4096 bit long modulus (2 primes)
..................................................................................++++
.............................................................++++
e is 65537 (0x010001)
```

2. 生成CA证书
> 调整-subj选项中的值以反映您的组织。 如果使用FQDN连接Harbor主机，则必须将其指定为公用名（CN）属性。
```
openssl req -x509 -new -nodes -sha512 -days 3650 \
 -subj "/C=CN/ST=Shandong/L=Jinan/O=GouChiCao/OU=AI/CN=gouchicao.com" \
 -key ca.key \
 -out ca.crt
```

### 生成服务器证书
> 证书通常包含一个.crt文件和一个.key文件，例如gouchicao.com.crt和gouchicao.com.key。

1. 生成私钥
```bash
openssl genrsa -out gouchicao.com.key 4096
```

2. 生成证书签名请求（CSR）
> 调整-subj选项中的值以反映您的组织。 如果使用FQDN连接Harbor主机，则必须将其指定为公用名（CN）属性，并在密钥和CSR文件名中使用它。
```bash
openssl req -sha512 -new \
    -subj "/C=CN/ST=Shandong/L=Jinan/O=GouChiCao/OU=AI/CN=gouchicao.com" \
    -key gouchicao.com.key \
    -out gouchicao.com.csr
```

3. 生成一个x509 v3扩展文件
```bash
cat > v3.ext <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1=gouchicao.com
DNS.2=gouchicao
DNS.3=hostname
EOF
```

4. 使用v3.ext文件为您的Harbor主机生成证书
> 将CRS和CRT文件名中的yourdomain.com替换为Harbor主机名。
```bash
openssl x509 -req -sha512 -days 3650 \
    -extfile v3.ext \
    -CA ca.crt -CAkey ca.key -CAcreateserial \
    -in gouchicao.com.csr \
    -out gouchicao.com.crt
```

### 提供证书给Harbor和Docker
> 生成ca.crt，yourdomain.com.crt和yourdomain.com.key文件后，必须将它们提供给Harbor和Docker，然后重新配置Harbor以使用它们。

1. 将服务器证书和密钥复制到Harbor主机上的certficates文件夹中。
```bash
sudo mkdir -p /data/harbor/cert
sudo cp gouchicao.com.crt /data/harbor/cert/
sudo cp gouchicao.com.key /data/harbor/cert/
```
2. 将yourdomain.com.crt转换为yourdomain.com.cert，以供Docker使用。
> Docker守护程序将.crt文件解释为CA证书，并将.cert文件解释为客户端证书。
```bash
openssl x509 -inform PEM -in gouchicao.com.crt -out gouchicao.com.cert
```

3. 将服务器证书，密钥和CA文件复制到Harbor主机上的Docker证书文件夹中。
> 如果将默认的nginx端口443映射到其他端口，请创建文件夹/etc/docker/certs.d/yourdomain.com:port或/etc/docker/certs.d/harbor_IP:port。
```bash
sudo mkdir -p /etc/docker/certs.d/gouchicao.com
sudo cp gouchicao.com.cert /etc/docker/certs.d/gouchicao.com/
sudo cp gouchicao.com.key /etc/docker/certs.d/gouchicao.com/
sudo cp ca.crt /etc/docker/certs.d/gouchicao.com/
```

4. 重新启动Docker Engine
```bash
sudo systemctl restart docker
```

```bash
/etc/docker/certs.d/
    └── yourdomain.com:port
       ├── yourdomain.com.cert  <-- Server certificate signed by CA
       ├── yourdomain.com.key   <-- Server key signed by CA
       └── ca.crt               <-- Certificate authority that signed the registry certificate
```

### 部署或重新配置Harbor
0. 修改配置文件
> 在harbor.yml文件中配置参数 ```hostname```, ```https```, ```harbor_admin_password```, ```data_volume```
```bash
nano harbor.yml
# Configuration file of Harbor

# The IP address or hostname to access admin UI and registry service.
# DO NOT use localhost or 127.0.0.1, because Harbor needs to be accessed by external clients.
hostname: gouchicao.com

# http related config
http:
  # port for http, default is 80. If https enabled, this port will redirect to https port
  port: 80

# https related config
https:
  # https port for harbor, default is 443
  port: 443
  # The path of cert and key files for nginx
  certificate: /data/harbor/cert/gouchicao.com.crt
  private_key: /data/harbor/cert/gouchicao.com.key

# # Uncomment following will enable tls communication between all harbor components
# internal_tls:
#   # set enabled to true means internal tls is enabled
#   enabled: true
#   # put your cert and key files on dir
#   dir: /etc/harbor/tls/internal

# Uncomment external_url if you want to enable external proxy
# And when it enabled the hostname will no longer used
# external_url: https://reg.mydomain.com:8433

# The initial password of Harbor admin
# It only works in first time to install harbor
# Remember Change the admin password from UI after launching Harbor.
harbor_admin_password: Harbor12345

# Harbor DB configuration
database:
  # The password for the root user of Harbor DB. Change this before any production use.
  password: root123
  # The maximum number of connections in the idle connection pool. If it <=0, no idle connections are retained.
  max_idle_conns: 50
  # The maximum number of open connections to the database. If it <= 0, then there is no limit on the number of open connections.
  # Note: the default number of connections is 1024 for postgres of harbor.
  max_open_conns: 1000

# The default data volume
data_volume: /data/harbor
```
1. 运行prepare脚本以启用HTTPS
```bash
sudo ./prepare
```

2. 如果Harbor正在运行，请停止并删除现有实例。
```bash
sudo docker-compose down -v
```

3. 重启Harbor
```bash
sudo docker-compose up -d
```

### 验证HTTPS连接
1.　配置DNS
```bash
sudo nano /etc/hosts
172.16.33.157 gouchicao.com
```

2. 打开浏览器，输入gouchicao.com

3. 从Docker客户端登录Harbor
```bash
docker login gouchicao.com
```

4. 上传容器镜像
```bash
docker tag face:v1 gouchicao.com/face/face:v1
docker push gouchicao.com/face/face:v1
```

### 在其它机器上拉取Harbor的容器镜像
1.　配置DNS
```bash
sudo nano /etc/hosts
172.16.33.157 gouchicao.com
```

2. 拷贝Harbor服务器上的CA证书
```bash
sudo scp /etc/docker/certs.d/gouchicao.com/ca.crt username@hostname:/etc/docker/certs.d/gouchicao.com/ca.crt
```

3. 拉取容器镜像
```bash
docker pull gouchicao.com/face/face:v1
```
