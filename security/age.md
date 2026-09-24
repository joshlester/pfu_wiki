# age

**age** (Actually Good Encryption) is the file-encryption primitive this
system is built on. It replaces GPG for everything local, and it is the
encryption backend for SOPS, the passage store, and the rclone passphrase.

## Why age over GPG

| Concern | GPG | age |
|---------|-----|-----|
| Key management | Web of trust, keyrings, key servers | Just an SSH key file |
| SSH key support | No native support | Yes — encrypt/decrypt directly with an SSH key |
| Passphrase prompts | GPG-agent dance every operation | Uses `ssh-agent` — zero prompts |
| Usage | Verbose flags | `age -e -R recipient.pub` |
| Auditability | Huge codebase | Tiny, auditable codebase |

## What it's used for here

- **Passage store** — every `*.age` file in `~/.password-store` is encrypted
  to `~/.ssh/id_ed25519_personal`.
- **SOPS** — SOPS uses age recipients to encrypt secrets in git repos
  ([[security/sops|SOPS]]).
- **Generic file encryption** — encrypt anything to yourself with the same
  SSH key.

The same SSH key authenticates to GitHub **and** decrypts your passwords — one
key, loaded into `ssh-agent` at login by the Ghostty profile, so nothing ever
prompts.

## Usage

```sh
# Encrypt a file to an SSH public key
age -e -R ~/.ssh/id_ed25519_personal.pub -o secret.age secret.txt

# Decrypt with the SSH private key (via ssh-agent — no prompt)
age -d -i ~/.ssh/id_ed25519_personal -o secret.txt secret.age

# Encrypt to multiple recipients
age -e -R personal.pub -R colleague.pub -o shared.age doc.txt
```

`-R` takes a **recipients** file (the public key); `-i` takes an **identity**
(the private key). age natively understands SSH keys — no conversion.

## Where the age keys live (for SOPS)

Separate from the SSH key, three dedicated age keys exist at
`~/.config/sops/age/` for SOPS-encrypted repos:

- `josh_key.txt` — personal configs
- `bytenaut_key.txt` — infrastructure (private key also on the server only)
- `3dviz_key.txt` — 3dviz project

All are `0600`, with backups in Proton Pass.

## Related

- [[security/pass|pass + passage]] — the store age protects
- [[security/sops|SOPS]] — age recipients for repo secrets
- [[security/rclone|rclone]] — the config passphrase protected by age
- [[security|Security overview]]