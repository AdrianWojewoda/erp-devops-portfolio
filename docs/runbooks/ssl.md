# Runbook: TLS / Let's Encrypt (ACME)

## Goal

Provide HTTPS for services using Traefik with automatic certificate issuance and renewal via Let's Encrypt.

## How it works

- DNS `A` records for subdomains point to the VPS public IP.
- Traefik handles ACME HTTP-01 challenge on entrypoint `web` (:80).
- Certificates are stored in `acme.json` bind-mounted into the Traefik container.

## Files / locations

- VPS runtime directory: `/srv/erp/app`
- ACME storage file: `/srv/erp/app/acme.json`
  - permissions: `600`
  - contains private key material (do not commit to git)

## Traefik configuration (high level)

- entrypoints:
  - `web` :80
  - `websecure` :443
- ACME resolver:
  - httpChallenge enabled
  - challenge uses entrypoint `web`

---

## Verification

### Check DNS

From your machine:

```bash
nslookup erp.adiwoj.pl
nslookup grafana.adiwoj.pl
```

Both should resolve to the VPS IP.

### Check HTTPS:

```bash
curl -I https://erp.adiwoj.pl
curl -I https://grafana.adiwoj.pl
```

Expected: HTTP 200/30x and a valid TLS handshake in browser.

### Check redirects

```bash
curl -I http://erp.adiwoj.pl
```

Expected: 301/307/308 redirect to https.

---

## Renewal

Traefik renews certificates automatically.
No cron job required.

## Verify Renewal Configuration

Check Traefik logs for ACME activity:

```bash
docker compose logs traefik | grep acme
```

## Let's Encrypt Rate Limits

Be aware of Let's Encrypt rate limits when repeatedly recreating certificates.

See:
https://letsencrypt.org/docs/rate-limits/

Avoid deleting acme.json unless necessary.

### Common failure modes

Port 80 blocked by firewall/security group → HTTP-01 challenge fails.
DNS not pointing to VPS → challenge fails.
Wrong Host rules → router not matching, causing 404 (ACME still needs port 80 reachable).

### Security notes

acme.json contains sensitive data. Keep file permissions strict and never publish it.
Prefer redirecting all HTTP to HTTPS after validating ACME works.