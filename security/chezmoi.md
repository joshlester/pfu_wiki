# chezmoi

chezmoi manages dotfiles. It matters to the secrets story because it is how
**personal secrets reach the desktop at use time**: the chezmoi repo holds
**ciphertext**, and profiles decrypt it on the way into a shell/app.

## Why

- Dotfiles live in a git repo and must not contain plaintext API keys.
- The "runtime" on the desktop is interactive (a shell / an editor), so the
  flow is inverted compared to the server: decrypt **at use**, keep the repo
  encrypted.
- A single `chezmoi apply` re-creates the whole `~` from the repo.

## Setup

`~/.config/chezmoi/chezmoi.toml`:

```toml
[pass]
    command = "passage"
```

so `{{ pass "path" }}` templates call `passage show` transparently.

## The secrets flow

- Ciphertext lives in `~/.local/share/chezmoi/secrets/*.txt` — raw-encrypted
  with the **josh** personal age key, and `.chezmoiignore`'d so it is never
  applied to `~`.
- `~/.zshrc` exports `SOPS_AGE_KEY_FILE="$HOME/.config/sops/age/josh_key.txt"`
  so sops can decrypt them.
- Profile launchers pass keys **inline**, never exported, e.g.:

  ```sh
  OPENCODE_API_KEY="$(sops --decrypt --output-type raw \
    ~/.local/share/chezmoi/secrets/zed-<profile>-api-key.txt)" zed
  ```

## Pitfalls

- **Don't `export` the key in a function** — it persists in the calling shell
  after the app exits. Pass it inline.
- **`auth.json` stays empty** (`{}`) — a session must be started through a
  profile wrapper that injects the key. Plain `opencode` failing to
  authenticate is intended (forces explicit key choice).
- **Stale cached keys**: zed caches the credential in
  `~/.local/share/opencode/auth.json`. After rotating a key, fully quit zed
  and relaunch, or it keeps the old env/auth.

## Related

- [[security/sops|SOPS]] — the encryption used for these secrets
- [[security/pass|pass + passage]] — the pass backend chezmoi calls
- [[security|Security overview]]