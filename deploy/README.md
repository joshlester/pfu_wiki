# pfu wiki

The pfu wiki — an OtterWiki instance served at `wiki.pfu.gg`, hosted on the
Bytenaut server (bs01) as a Nomad job.

## Contents

The repo root is the OtterWiki content repository. Every `.md` file is a page
(its path relative to the repo root is the page name, e.g. `development/db.md`
serves at `/development/db`). Non-`.md` files next to a page are its
attachments (e.g. `containers/docker-compose.yml` is an attachment of the
`containers` page). Internal links use OtterWiki wiki-link syntax:
`[[path/to/page|label]]`.

This repo was migrated from `josh_wiki_storage` (Wiki.js). The old YAML
frontmatter was stripped and `[label](/path)` links were converted to
`[[path|label]]` wiki-links.

## Deploy

The deployment files live in `deploy/`:

- `pfu-wiki.nomad` — the Nomad job (OtterWiki on port `9010`, host network).
- `entrypoint.sh` — wrapper entrypoint that generates the nginx site binding
  `9010` only (the stock entrypoint hardcodes an extra `listen 8080`, which
  conflicts with `signal-cli` on this host). Mounted read-only into the
  container at `/entrypoint.sh`.

### Steps

1. Create the volume and seed it with this repo's content:
   ```sh
   ssh bsvr1 '
     podman volume create pfu_wiki_otterwiki_data
     mkdir -p /var/lib/containers/storage/volumes/pfu_wiki_otterwiki_data/_data
   '
   ```
2. Copy the job and entrypoint to the server:
   ```sh
   scp deploy/pfu-wiki.nomad bsvr1:/opt/hashicorp/nomad/jobs/pfu-wiki.nomad
   scp deploy/entrypoint.sh bsvr1:/opt/hashicorp/nomad/jobs/pfu-wiki/entrypoint.sh
   ssh bsvr1 'chmod +x /opt/hashicorp/nomad/jobs/pfu-wiki/entrypoint.sh'
   ```
3. Seed the repository volume:
   ```sh
   ssh bsvr1 '
     cd /var/lib/containers/storage/volumes/pfu_wiki_otterwiki_data/_data
     git clone git@github.com:joshlester/pfu_wiki.git repository
   '
   ```
4. Run the job:
   ```sh
   ssh bsvr1 'nomad-cli job validate pfu-wiki.nomad && nomad-cli job run -detach pfu-wiki.nomad'
   ```
5. Caddy: `wiki.pfu.gg` should `reverse_proxy 127.0.0.1:9010`, then point the
   Cloudflare DNS record for `wiki.pfu.gg` at bs01.

### First admin user

Registration is disabled (`DISABLE_REGISTRATION = True` in `settings.cfg`, set
on first boot). Create the first admin via OtterWiki's CLI inside the
container:

```sh
ssh bsvr1 'nomad-cli alloc exec <alloc-id> /bin/bash -c \
  "flask --app otterwiki.server user create you@example.com \"Your Name\" --flags=email_confirmed,approved --permissions=read,write,upload --password 'CHANGE_ME'"'
```

Then use `flask --app otterwiki.server user password you@example.com` if you
need to reset it later.

### Runtime settings (on the volume, not in git)

The wiki's `settings.cfg` lives on the volume at
`_data/settings.cfg` (generated on first boot, not versioned). Current custom
values beyond the entrypoint defaults:

```ini
READ_ACCESS = "REGISTERED"
WRITE_ACCESS = "REGISTERED"
ATTACHMENT_ACCESS = "REGISTERED"
DISABLE_REGISTRATION = True
SITE_NAME = "pfu"
WIKILINK_STYLE = "LINKTITLE"   # pages use [[path/to/page|Label]] wiki-links
```

`WIKILINK_STYLE = "LINKTITLE"` matters: the wiki content (imported from
`josh_wiki_storage`) uses `[[path|label]]` syntax, which is the LINKTITLE
format. The OtterWiki default would render those as `[[label|path]]`, turning
every internal link into a broken `/Label` href. If you ever rebuild the wiki
fresh, re-add these lines after first boot.