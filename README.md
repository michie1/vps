# Kubernetes Infrastructure

This repository contains Kubernetes manifests for a personal infrastructure setup including documentation (Outline), database (PostgreSQL), and static sites.

## Services

### Core Applications
- **Outline** (`outline/`) - Documentation wiki at `docs.msvos.nl`
- **PostgreSQL** (`postgres/`) - Database backend for Outline
- **Redis** (`redis/`) - Caching layer

### Static Sites
- **FastFox** (`fastfox/`) - Static site at `fastfox.nl`
- **Elm Lang** (`elm-lang/`) - Elm language demo site
- **Plus Finance** - Finance application at `plusfinance.nl`
- **MSVOS** - Main site at `msvos.nl`

### Infrastructure
- **Container Registry** (`cr/`) - Private Docker registry
- **Grocy** (`grocy/`) - Inventory management
- **Let's Encrypt** (`clusterissuer.yml`) - TLS certificate management

## Prerequisites
- Kubernetes cluster with ingress-nginx controller
- cert-manager for TLS certificates
- Storage class for persistent volumes

## Deployment

1. **Deploy core infrastructure:**
   ```bash
   kubectl apply -f clusterissuer.yml
   kubectl apply -f bindings.yml
   ```

2. **Deploy database:**
   ```bash
   # Create secrets first (copy from example files)
   cp postgres/postgres-secrets.example.yml postgres/postgres-secrets.yml
   # Edit postgres-secrets.yml with real values
   kubectl apply -f postgres/postgres-secrets.yml
   kubectl apply -f postgres/postgres.yml
   kubectl apply -f redis/redis.yml
   ```

3. **Deploy Outline documentation:**
   ```bash
   # Create secrets first
   cp outline/outline-secrets.example.yml outline/outline-secrets.yml
   # Edit outline-secrets.yml with real values
   kubectl apply -f outline/outline-secrets.yml
   kubectl apply -f outline/outline.yml
   ```

4. **Deploy static sites:**
   ```bash
   kubectl apply -f fastfox/fastfox.yml
   kubectl apply -f elm-lang/elm-lang.yml
   kubectl apply -f plusfinance.yml
   kubectl apply -f msvos.yml
   ```

5. **Deploy additional services:**
   ```bash
   kubectl apply -f grocy/grocy.yml
   kubectl apply -f cr/cr.yml
   ```

## Secrets Management

**⚠️ Security Note:** Before deployment, you must create actual secret files from the example templates:

- `postgres/postgres-secrets.yml` - Database credentials
- `outline/outline-secrets.yml` - Application secrets and OAuth keys

Example templates are provided as `*-secrets.example.yml` files. **Never commit real secrets to git.**

## Backup

Use the backup script to create backups:
```bash
./backup-pvcs.sh
```

Backups are stored in the `backups/` directory with timestamp folders.

## Domains

The following domains are configured:
- `docs.msvos.nl` - Outline documentation
- `fastfox.nl` - FastFox site
- `plusfinance.nl` - Plus Finance app
- `msvos.nl` - Main MSVOS site

## Container Images

Custom images are built and pushed using the `build.sh` and `push.sh` scripts in each service directory.
