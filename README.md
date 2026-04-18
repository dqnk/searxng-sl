# searxng-sl

SearXNG overlay image adding Slovenian (`sl`, `sl-SI`) to the search language dropdown.

Upstream `searx/sxng_locales.py` is auto-generated via engine-count threshold. Slovenian sits below the cutoff (19 engines / threshold 22 for language, 14 / threshold 18 for region), so it never lands in the dropdown despite engine + translation support existing.

This repo ships a patched `sxng_locales.py` layered on top of the official image.

## Files

- `Dockerfile` — `FROM searxng/searxng:latest`, copies patched locale file
- `sxng_locales.py` — regenerated upstream file with `sl` + `sl-SI`
- `docker-compose.yaml` — core + redis, builds from local Dockerfile

## Run

```sh
docker compose up -d --build
```

First start creates `./searxng/` dir for SearXNG config (`settings.yml`, `limiter.toml`, etc).

## Coolify deploy

- Deploy Coolify's built-in SearXNG one-click app
- Edit its compose, swap `image: searxng/searxng:latest` → `image: ghcr.io/<owner>/searxng-sl:latest`
- Paste your `settings.yml` into the config volume via Coolify's file editor
- Private GHCR: SSH the Coolify host and run `docker login ghcr.io -u <user> --password-stdin` (classic PAT with `read:packages`; fine-grained PATs don't work with GHCR)

## Update upstream locales

Upstream `sxng_locales.py` bumps occasionally. To regen with Slovenian forced in:

1. In a checkout of `searxng/searxng`, patch `searxng_extra/update/update_engine_traits.py` around line 139 to add `sxng_tag_list.update(['sl', 'sl-SI'])` before the return.
2. `./manage pyenv.install && ./manage data.traits`
3. Copy `searx/sxng_locales.py` into this repo.
4. `docker compose build --pull && docker compose up -d`
