
# Rclone
https://rclone.org/

Rclone is a command line program to manage files on cloud storage. It is a feature rich alternative to cloud vendors' web storage interfaces. Over 40 cloud storage products support rclone including S3 object stores, business & consumer file storage services, as well as standard transfer protocols.

## Commands
```
# List remotes.
rclone listremotes

# Mount remote.
# Ensure you create the remote mount point on the local file system.
rclone mount --daemon --vfs-cache-mode full eltirus: /home/josh/one_drive_eltirus

```

## Resources
How to Mount a Google Drive Locally with Rclone
https://www.youtube.com/watch?v=f8K-V3HHDA0