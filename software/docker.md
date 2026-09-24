
# Docker

## Build one docker stage from another
https://www.youtube.com/watch?v=Cl9jRuX1eL0&ab_channel=HarrisonMilbradt

## Commands



* Push local folder to server
`Sync app_server_test to App Server 1 using SSH auth.`
`Exclude folders (note: the exclude path is relative to the source folder i.e. ./app_server_test)`
```
rsync -avz --exclude ".git" --exclude "docker/data" -e "ssh -p 22053 -i ~/.ssh/ren_app_server1" ./app_server_test _3dviz@202.174.103.84:/srv/www
```

* Push local folder App Server 2
```
rsync -avz -e "ssh -p 22054 -i ~/.ssh/ren_app_server1" ./container _3dviz@202.174.103.84:/srv/www/cdn_server
```

* Pull remote file to current folder
`Pull file from Rendivo App Server 1 using SSH auth.`
```
rsync -avz -e "ssh -p 22053 -i ~/.ssh/ren_app_server1" _3dviz@202.174.103.84:/etc/keepalived/keepalived.conf .
```

* Pull file from GPU 1
```
rsync -avz -e "ssh -p 22051" 3dviz@202.174.103.84:/home/3dviz/vmware-1329602.log .
```

* Pull file from GPU1 to GPU2
```
rsync -avz -e "ssh -p 22" 3dviz@192.168.2.20:/home/3dviz/VirtualMachines/kvm/RendivoAppSrv-disk01.qcow2 .
```