# Proton Pass + pass-cli

Proton Pass is the **cloud credential vault**. It is the recoverability net
for the whole secrets chain: age key backups, Proton PATs, and API tokens all
live here so a fresh machine can be rebuilt.

## Why

- Local stores (pass/passage, SOPS keys) are useless if the machine is lost.
- Proton Pass stores the **age private-key backups** and the **PATs/tokens**
  that let you re-establish every other tool.
- `pass-cli` is the official CLI — the whole vault is scriptable/agent-
  accessible, with session isolation and reason-gated reads.

## Vaults

| Vault | Contents |
|-------|----------|
| `Bytenaut` | Bytenaut infra secrets (R2 keys, Proton PAT, zed API key) |
| `PFU` | pfu project tokens (e.g. the Cloudflare API token) |
| `3dviz` | 3dviz project |

## The chain from a fresh machine

```
Proton Pass (cloud)
   │  pass-cli (PAT) → age key backups, tokens
   ▼
SSH key / age keys  →  passage store + SOPS keys
   ▼
rclone passphrase, cloud creds, dotfile secrets
```

If a laptop dies: log into Proton Pass, pull the age keys, re-init passage,
restore the SOPS keys — everything else unwraps from there.

## pass-cli usage

```sh
# session (isolated dir so agents don't collide)
export PROTON_PASS_SESSION_DIR="/tmp/pass-agent-<name>"
PROTON_PASS_PERSONAL_ACCESS_TOKEN="pst_..." pass-cli login

pass-cli info                       # verify session
pass-cli vault list --output json   # accessible vaults
pass-cli item list --vault-name "PFU" --output json
pass-cli item view --vault-name "PFU" --item-title "X" --field note
```

Reads (and writes) are **reason-gated**: set `PROTON_PASS_AGENT_REASON` before
`item view` / `item create` / `item update`.

## Related

- [[security/age|age]] — the keys Proton Pass backs up
- [[security/pass|pass + passage]] — the local store (PAT lives here too)
- [[security/sops|SOPS]] — age keys backed up to Proton Pass
- [[security|Security overview]]