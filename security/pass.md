# pass + passage

Two password stores live side-by-side in `~/.password-store`:

- **pass** — the classic GPG-based store (`*.gpg` entries).
- **passage** — a pass-compatible store using **age** with an **SSH key**
  (`*.age` entries). This is the actively used one.

## Why

- A local, encrypted store for the handful of credentials that **gate other
  tools**: the rclone config passphrase, OneDrive IDs/passwords, Proton PAT,
  Cloudflare R2 keys, API keys.
- It is a **git repo**, so history + sync across machines are built in.
- **passage** removes the GPG web-of-trust complexity: it encrypts with the
  SSH key already in `ssh-agent`, so there is **zero prompt** on use.

## Layout

```
~/.password-store/          # git repo
├── .gpg-id                 # "josh@pfu.gg"
├── buzz/nostr-key
├── bytenaut/
│   ├── cloudflare_r2_access_key_id
│   ├── cloudflare_r2_secret_access_key
│   ├── proton_pass_pat
│   └── zed_anthropic_api_key
├── josh/
│   ├── one_drive_id
│   ├── one_drive_encrypt_password
│   ├── one_drive_encrypt_password2
│   └── rclone-config-passphrase.age
└── rendivo/admin_password
```

`.age` entries are **passage** (SSH key); `.gpg`/plain entries are the older
pass format. Migration from GPG: `pass show <name> | passage insert <name>`.

## Keying

| Store | Key | Mechanism |
|-------|-----|-----------|
| passage (`*.age`) | `~/.ssh/id_ed25519_personal` | age + ssh-agent, no prompt |
| pass (`*.gpg`) | GPG key `josh <josh@pfu.gg>` (ed25519, created 2025-04-11) | gpg-agent |

The SSH key does double duty: GitHub auth **and** file encryption. The Ghostty
profile loads it into `ssh-agent` at login.

## Usage

```sh
passage show <name>       # decrypt + show (alias: passage <name>)
passage insert <name>     # add/update (supports piped input)
passage list              # list entries

pass show <name>          # classic GPG store
pass git push / pull      # sync the store
```

## Chezmoi integration

`~/.config/chezmoi/chezmoi.toml`:

```toml
[pass]
    command = "passage"
```

so dotfile templates can call `{{ pass "path" }}` and chezmoi transparently
uses `passage show "path"`.

## Why rclone's passphrase lives here

`josh/rclone-config-passphrase.age` holds the passphrase that decrypts
`~/.config/rclone/rclone.conf` (which is `RCLONE_ENCRYPT_V0`-obscured). So the
chain is: SSH key → passage → rclone passphrase → rclone config → cloud
credentials. See [[security/rclone|rclone]].

## Related

- [[security/age|age]]
- [[security/rclone|rclone]]
- [[security/sops|SOPS]] — where the age-key backups (not the same key) are used
- [[security|Security overview]]