## Run 

```
ansible-playbook  roles_apply.yml
```

## Change config
* Если нужно поменяять конфиг иди в роль и меняй defaults


### Info ansible
```
ansible 2.9.10
  config file = /home/fixnoobi/gist/ansible-seaweeds/ansible.cfg
  configured module search path = ['/home/fixnoobi/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3.8/site-packages/ansible
  executable location = /usr/bin/ansible
  python version = 3.8.3 (default, May 17 2020, 18:15:42) [GCC 10.1.0]
```

## Checks
### ETCD
```
ETCDCTL_API=2 etcdctl member list
```

### S3
http://srv-stage01:9000

### Filer
http://srv-stage01:8888

### Volume
http://srv-stage01:8080

### Masters
http://srv-stage01:8993

## Prune
### ETCD [on master etcd]
```
ETCDCTL_API=3 etcdctl del "" --from-key=true
```

## Testing

### Bench
```
export AWS_ACCESS_KEY_ID=TestAccessKey && export AWS_SECRET_ACCESS_KEY=ASFJKHAJKNFskfhkshdjfhs32JKLFH && /tmp/s3-benchmark -bucket-name selfreg -endpoint http://srv-stage01:9000 -payloads-max 8 -samples 5000
```

### Setup & run

```
vagrant plugin install vagrant-disksize
```

**Install** https://www.virtualbox.org/wiki/Downloads 
* vagrant
* Oracle VM VirtualBox 
* * Extension Pack

### Stage run
```
vagrant up
```


## Edit host in file hosts/servers

* Uncomment `srv`, comment srv-stage* and add `ip`

### Simple
```
[srv]
#srv-stage01 ansible_ssh_host=192.168.100.101 ansible_user=root
#srv-stage02 ansible_ssh_host=192.168.100.102 ansible_user=root
```

## Edit configs if need rename user or etc

* Edit in 
```
roles/*/defaults/main.yml
```
