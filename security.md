# Security

How secrets are stored, encrypted and recovered across the desktop and the
Bytenaut server — what each tool does, why it exists, and how they fit
together.

## The services at a glance

| Service | Role | Where | Encrypts |
|---------|------|-------|----------|
| [[security/age|age]] | File encryption primitive | Everywhere | Any file, via SSH keys |
| [[security/sops|SOPS]] | Secrets-at-rest inside git repos | Desktop + server repos | `infra/nomad/secrets/`, chezmoi secrets |
| [[security/pass|pass + passage]] | Local password store | Desktop | Service credentials, rclone passphrase |
| [[security/rclone|rclone]] | Cloud storage sync + backup | Desktop | Cloud credentials (encrypted config) + a `crypt` overlay |
| [[security/proton-pass|Proton Pass + pass-cli]] | Cloud credential vault | Cloud (via CLI) | Age key backups, PATs, API tokens |
| [[security/chezmoi|chezmoi]] | Dotfiles with secrets | Desktop | Decrypts secrets into shell profiles at use time |

## How it all hangs together

Secrets form a **chain of keys** — one root key unwraps the next layer:

```
                    ┌─────────────────────────────┐
                    │  Proton Pass (cloud vault)  │
                    │  backup of age keys, PATs,  │
                    │  API tokens                 │
                    └──────────────┬──────────────┘
                                   │ bootstrap / restore
                    ┌──────────────▼──────────────┐
                    │  SSH key (id_ed25519_personal)│
                    │  GitHub auth + passage store │
                    └──────────────┬──────────────┘
                                   │
        ┌──────────────┬───────────┴───────────┬──────────────────┐
        │              │                       │                  │
┌───────▼───────┐ ┌────▼───────┐ ┌─────────────▼────────┐ ┌───────▼────────┐
│ age (desktop) │ │ age (sops) │ │ rclone config        │ │ age keys       │
│ passage store │ │ josh_key   │ │ (encrypted, password │ │ josh/bytenaut/ │
│ *.age files   │ │ bytenaut   │ │ in passage)          │ │ 3dviz          │
└───────┬───────┘ │ 3dviz keys │ │ onedrive_crypt       │ └───────┬────────┘
        │         └────┬───────┘ └──────────────────────┘         │
        │              │                                          │
        │              │ (re)encrypt / decrypt repo secrets        │
        │       ┌──────▼──────┐                                    │
        │       │ SOPS        │◄───────────────────────────────────┘
        │       │ .sops.yaml  │  server key decrypts
        │       │ infra/...   │  infra/nomad/secrets/ on bs01
        │       └─────────────┘
```

### The mental model

- **age is the primitive.** Every tool here wraps age (or an SSH key that age
  can use directly). One auditable, simple crypto layer — no GPG web-of-trust.
- **SOPS keeps secrets in git as ciphertext.** The repo is the source of
  truth; plaintext only ever materialises at the runtime path that needs it
  (Nomad templates, shell profiles). Two age keys split personal vs server
  secrets.
- **pass/passage is the local keychain.** It stores the handful of things
  that decrypt or authenticate other services (the rclone config passphrase,
  OneDrive IDs, Proton PAT). It is a git repo, encrypted with the SSH key.
- **rclone's config is itself encrypted**, and its `crypt` overlay adds
  client-side encryption on top of cloud storage (OneDrive) so the provider
  never sees plaintext files.
- **Proton Pass is the recoverability net.** If a machine is lost, the age
  keys and PATs stored there let you rebuild the whole chain from a fresh
  box.

### Why each layer exists

| Problem | Solution |
|---------|----------|
| "I need to commit secrets to git without leaking them" | SOPS + age |
| "I need a local store for credentials that gate other tools" | pass/passage |
| "My cloud backup must not be readable by the cloud provider" | rclone crypt overlay |
| "My rclone config contains tokens, I don't want them in plaintext" | `RCLONE_ENCRYPT_V0` (obscured config) |
| "I lose my laptop — how do I get everything back?" | Proton Pass key backups + pass-cli |
| "My dotfiles contain API keys" | chezmoi decrypts at use time, never stores plaintext |

## Key trust boundaries

- **Josh personal key** (`josh_key.txt`, recipient
  `age182mt80pd0ljx5vy5z72n8mf7w8tekc5waxfdzz0qu5sl7d6ehgss54xyqr`) —
  desktop/personal configs only.
- **Bytenaut server key** (`bytenaut_key.txt`, recipient
  `age1sjzh5g3hschxzsmcy9qecljlezsqh59m92g5p3dd64ymh40gc42sa43t9z`) —
  infrastructure secrets only; the private key lives **only** on the server
  (desktop holds a copy for infra ops).
- **3dviz key** (`3dviz_key.txt`) — the 3dviz project.
- **SSH key** (`~/.ssh/id_ed25519_personal`) — the passage store + age file
  encryption on the desktop.

Never commit a private key or a plaintext secret. Private keys are 0600 and
backed up in Proton Pass.

## Related

- [[security/sops|SOPS]]
- [[security/pass|pass + passage]]
- [[security/rclone|rclone]]
- [[security/age|age]]
- [[security/proton-pass|Proton Pass + pass-cli]]
- [[security/chezmoi|chezmoi]]
- [[backup|Backup]] — the rclone sync jobs that use these remotes