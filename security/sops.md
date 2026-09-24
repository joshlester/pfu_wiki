# SOPS

**SOPS** (Secrets OPerationS, Mozilla) encrypts secrets **at rest inside a git
repo** using **age** recipients. The repo holds ciphertext; plaintext only
appears at the runtime path that actually needs it.

## Why

- Secrets must be versioned with the code/infra they belong to.
- Committing them in plaintext leaks them to anyone with repo access.
- The `.sops.yaml` rules select which age key encrypts which path, so the
  same repo can hold personal and server secrets under different keys.

## The rule that makes it safe

> **Plaintext only where a runtime needs it.** Never encrypt a file in place
> where a runtime reads it — Nomad templates, podman `auth.json`, and shell
> profiles all fail to parse ciphertext.

So the pattern is always:

- **Plaintext** at the runtime path on the server (e.g.
  `/opt/hashicorp/secret/app-env/*.env`).
- **SOPS-encrypted copy** in the repo under `infra/nomad/secrets/` as the
  versioned source of truth.
- A **restore script** that decrypts the repo copy back to the runtime path.

## The age keys

| Key | Recipient | Used for |
|-----|-----------|----------|
| `josh_key.txt` (desktop) | `age182mt80pd0ljx5vy5z72n8mf7w8tekc5waxfdzz0qu5sl7d6ehgss54xyqr` | All personal config files (chezmoi zed keys, etc.) |
| `bytenaut_key.txt` (server + desktop copy) | `age1sjzh5g3hschxzsmcy9qecljlezsqh59m92g5p3dd64ymh40gc42sa43t9z` | Infrastructure secrets only |
| `3dviz_key.txt` | — | The 3dviz project |

sops 3.13 does **not** auto-discover keys — set `SOPS_AGE_KEY_FILE` (done in
`~/.zshrc`). Key files must be `0600`.

## Repo layout

```
.sops.yaml                                # creation rules (recipient per path)
infra/nomad/secrets/
├── ghcr-auth.json                        # podman ghcr credential
├── app-env/*.env                         # Nomad app env files
├── consul-acl-bootstrap.json
├── consul-acl-token
├── consul-nomad-token
├── nomad-acl-bootstrap.txt
infra/nomad/scripts/decrypt_server_secrets.sh
```

`.sops.yaml`:

```yaml
creation_rules:
  - path_regex: ^infra/nomad/secrets/.*$
    age: age1sjzh5g3hschxzsmcy9qecljlezsqh59m92g5p3dd64ymh40gc42sa43t9z
```

## Encrypting a secret

Encrypt on the server (sops + the age key live there). Match `--input-type`
to the file: `dotenv`, `json`, or `raw`. Output to a file — never print
plaintext.

```sh
# dotenv (app env files)
sops --encrypt --age <PUBLIC_KEY> --input-type dotenv file.env > out.env

# json (auth.json, ACL bootstrap)
sops --encrypt --age <PUBLIC_KEY> --input-type json auth.json > out.json

# raw (ACL tokens)
sops --encrypt --age <PUBLIC_KEY> --input-type raw token.txt > out.txt
```

Note: with `dotenv`, **key names stay plaintext** — only values are encrypted
(`KEY=ENC[AES256_GCM,...]`). This is expected, not a leak.

## Restoring / re-establishing a server

Run the restore script **on the server** from a repo clone. It needs the age
private key present:

```sh
ssh bsvr1 'cd <repo> && bash infra/nomad/scripts/decrypt_server_secrets.sh'
```

This decrypts `infra/nomad/secrets/` back to the runtime paths:
`ghcr-auth.json` → `~/.config/containers/auth.json`, `app-env/*.env` →
`/opt/hashicorp/secret/app-env/`, ACL tokens → `/opt/hashicorp/secret/`.

## Round-trip verification

```sh
SOPS_AGE_KEY_FILE=/root/.config/sops/age/key.txt \
  sops --decrypt --output-type dotenv file.env        # dotenv
# ...or --output-type json / raw for the other types
```

Always match `--output-type` to the input type, or sops may default to binary
and fail with "no binary data found in tree". Verify a round-trip by comparing
a hash of a value, never by printing the secret.

## Desktop (chezmoi) — inverted flow

On the desktop the rule inverts: the "runtime" is interactive (a shell), so
**ciphertext lives in the chezmoi repo** and is decrypted **at use time**:

- Ciphertext: `~/.local/share/chezmoi/secrets/*.txt` (raw-encrypted,
  `.chezmoiignore`'d so it never lands in `~`). Encrypted with the **josh**
  personal key.
- `~/.zshrc` sets `SOPS_AGE_KEY_FILE` to `josh_key.txt`.
- Profile launchers pass API keys inline, never exported:
  `OPENCODE_API_KEY="$(sops --decrypt --output-type raw ...)" zed`

## Gotchas

- Encrypting a runtime file in place breaks the runtime — keep plaintext at
  the runtime path, ciphertext in the repo.
- sops 3.13 refuses to encrypt when no `.sops.yaml` rule matches (even with
  explicit `-a`). The chezmoi repo uses a catch-all `path_regex: .*` for this.
- After a key rotation, fully quit the app (zed) that cached the old secret —
  a new launch in "existing window" mode keeps the old env/auth.

## Related

- [[security/age|age]]
- [[security/pass|pass + passage]] — where the age key backups live
- [[security|Security overview]]