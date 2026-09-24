
# Rendivo Commands

Rendivo App Server 2
```
rsync -avzP -e "ssh -p 22054 -i /home/josh/.ssh/rendivo/rendivo_server_app2" _3dviz@202.174.103.84:~/docker/rendivo_web_server/container ~/projects/rendivo/rendivo_web_server
```

Rsync
```
rsync -avzP -e "ssh -p 2223 -i /home/josh/.ssh/rendivo/rendivo_app_server_vm.prv.key" ~/Downloads/rendivo_gwt_client_virtualbox_ova.7z rendivo-admin@202.174.105.137:/mnt/large/VirtualMachines/VirtualBox/
```