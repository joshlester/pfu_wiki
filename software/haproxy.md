
# HAProxy
<br>

## ACLs
https://www.haproxy.com/blog/introduction-to-haproxy-acls/
<br>

## HAProxy logging
https://www.digitalocean.com/community/tutorials/how-to-troubleshoot-common-haproxy-errors

Log location
```
/var/log/haproxy.log
```

To inspect the systemd logs for HAProxy, you can use the journalctl command. The systemd logs for HAProxy will usually indicate whether there is a problem with starting or managing the HAProxy process.

These logs are separate from HAProxy’s request and error logs. journalctl displays logs from systemd that describe the HAProxy service itself, from startup to shutdown, along with any process errors that may be encountered along the way.
```
sudo journalctl -u haproxy.service --since today --no-pager
```