# OpenFaaS

## 安装
* 安装faas-cli
```bash
curl -sL https://cli.openfaas.com | sudo sh
```

* 安装arkade
```bash
curl -SLsf https://dl.get-arkade.dev/ | sudo sh
```

* 安装OpenFaaS
```bash
sudo arkade install openfaas
```

* Kubernetes上启用OpenFaas
    * [faas-netes](https://github.com/openfaas/faas-netes/blob/master/chart/openfaas/README.md)
```bash
git clone https://github.com/openfaas/faas-netes && cd faas-netes
sudo kubectl apply -f ./namespaces.yml
sudo kubectl apply -f ./yaml_armhf
```


## port-forward
```bash
sudo kubectl port-forward svc/gateway -n openfaas 31112:8080
```
浏览器访问：http://localhost:8080/


## 卸载
```bash
sudo helm delete openfaas --namespace openfaas
```
