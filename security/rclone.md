# rclone

rclone manages file sync to cloud storage. On this system it is used for
**encrypted backups** (OneDrive + Cloudflare R2), and both its config file and
its cloud payloads are encrypted.

## Why rclone (vs raw cloud clients)

- One tool, one config, for every storage backend (OneDrive, S3/R2, etc.).
- Client-side `crypt` overlay: files are encrypted **before** upload, so the
  cloud provider sees only ciphertext.
- The config file itself can be obscured, so stored tokens aren't plaintext.

## The three remotes

| Remote | Type | Purpose |
|--------|------|---------|
| `onedrive` | Microsoft OneDrive | Raw backing store (token, `drive_id`) |
| `onedrive_crypt` | `crypt` over `onedrive` | Encrypted overlay used by backup jobs |
| `bytenaut_cloudflare_r2` | S3-compatible (Cloudflare R2) | Bytenaut backup storage |

The `crypt` remote encrypts **filenames and directory names** (`filename_encryption` /
`directory_name_encryption`), with a password + salt (`password`, `password2`).

## The encrypted config file

`~/.config/rclone/rclone.conf` is not plaintext — it is `RCLONE_ENCRYPT_V0`
obscured, which means rclone needs the passphrase to use it:

```sh
RCLONE_CONFIG_PASS="$(passage show josh/rclone-config-passphrase)" \
  rclone <command>
```

The passphrase lives in the **passage** store
(`josh/rclone-config-passphrase.age`). So:

```
SSH key → passage → rclone passphrase → rclone.conf → cloud credentials
```

A backup of the config was kept as `rclone.conf.bak-20260924` when it was
regenerated.

## Usage

```sh
# List remotes (needs the passphrase in env)
RCLONE_CONFIG_PASS="$(passage show josh/rclone-config-passphrase)" rclone listremotes

# Sync pictures to the encrypted OneDrive overlay
rclone sync -P /media/josh/STUFF/docs onedrive_crypt:Documents

# Backup archive
rclone sync -P /media/josh/STUFF/archive onedrive_crypt:archive
```

## Backup jobs

See [[backup|Backup]] for the full set of sync commands:

```sh
rclone sync -P /media/josh/STUFF/docs one_drive_encrypt:Documents
rclone copy -P --ignore-existing /mnt/black_box/media/personal onedrive_crypt:pictures
rclone sync -P /media/josh/STUFF/archive one_drive_encrypt:archive
```

## Why the crypt overlay matters

OneDrive (and any cloud provider) can read the files you upload. The `crypt`
overlay means the backup content — including anything sensitive on the disk —
is unreadable to the provider, and is only decryptable with the passphrase in
the passage store.

## Related

- [[security/pass|pass + passage]] — where the config passphrase is stored
- [[backup|Backup]] — the sync jobs
- [[security|Security overview]]