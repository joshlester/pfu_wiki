
# Ssh

## SSH Policy
<br />
<hr />

 - Razor 15" Changed ssh policy to Fedora 40 when currently on Fedora 41 to resolve error:
```ssh_dispatch_run_fatal: Connection to x.x.x.x port xxxx: error in libcrypto```
Run command:
```sh
sudo update-crypto-policies --set FEDORA40
```
See: https://discussion.fedoraproject.org/t/fedora-41-ssh-to-rhel6-error-in-libcrypto/135999/9

<br />
<hr />


1. Creating the Key Pair
Note:
By default recent versions of ssh-keygen will create a 3072-bit RSA key pair, which is secure enough for most use cases (you may optionally pass in the -b 4096 flag to create a larger 4096-bit key).

> After running the command below you'll be prompted to specify the keys location.
```
ssh-keygen -t rsa -b 4096 -C "rendivo_server_app2"

```

2. Copy the Public Key to Server  

```
ssh-copy-id -i {path_to_public_key} username@remote_host
```
Copy public SSH key to Rendivo app server 2 (ssh using port 22054)
```
ssh-copy-id -p 22054  -i /home/josh/.ssh/rendivo/rendivo_server_app2.pub _3dviz@202.174.103.84
```

Note if you receive the following error when running ssh-copy-id use the *-f* flag
>ERROR: failed to open ID file '/home/.../{pub.key'}: No such file or directory
	(to install the contents of '.../{pub.key}' anyway, look at the -f option)

## Configure what key to use for a given provider e.g. gitlab
https://proinsias.github.io/til/Git-Specify-the-ssh-key-to-use/
Edit file
~/.ssh/config
```
Host github.com
  User josh.lester
  Hostname gitlab.com
  IdentityFile ~/.ssh/gitlab/gitlab_josh
```