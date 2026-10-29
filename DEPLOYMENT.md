# Papersign production deployment

Papersign deploys to the k3s VPS through [`alvaropaco/k8s-infra`](https://github.com/alvaropaco/k8s-infra). That repository is ArgoCD GitOps, not Terraform: `argocd/apps/papersign.yaml` syncs `apps/papersign/` as a Helm chart.

## Public URL

`https://papersign.io` is Cloudflare-proxied to VPS `157.173.121.7`. The origin uses a self-signed certificate managed by the chart. Before DNS is available, use:

```text
https://papersign.io.157.173.121.7.nip.io
```

## CI image flow

A push to `main` runs `.github/workflows/deploy.yml`:

1. Builds `docker/Dockerfile` for `linux/amd64`.
2. Publishes `ghcr.io/alvaropaco/papersign:<full-sha>`, `sha-<short-sha>`, and `latest`.
3. Updates `image.tag` in k8s-infra to the full SHA.
4. ArgoCD syncs the updated chart.

The cross-repository update requires the Papersign repository secret `K8S_INFRA_PAT` with Contents write access to `alvaropaco/k8s-infra`. If it is absent, image publishing still succeeds but the automatic bump is skipped.

## Infisical secrets

The k8s-infra chart reads project `3e29d88f-0254-472b-a399-036630e60ff1`, environment `prod`, path `/papersign`, and renders `papersign-secrets`.

Required Infisical keys:

- `NEXTAUTH_SECRET`
- `NEXT_PRIVATE_ENCRYPTION_KEY`
- `NEXT_PRIVATE_ENCRYPTION_SECONDARY_KEY`
- `POSTGRES_PASSWORD`
- `NEXT_PRIVATE_DATABASE_URL`
- `NEXT_PRIVATE_DIRECT_DATABASE_URL`
- `NEXT_PRIVATE_SMTP_PASSWORD`
- `NEXT_PRIVATE_SIGNING_PASSPHRASE`
- `SIGNING_CERT_P12_BASE64`

The database URLs point to the dedicated in-cluster database:

```text
postgresql://papersign:<POSTGRES_PASSWORD>@papersign-postgres.papersign.svc.cluster.local:5432/papersign
```

The signing certificate key is optional for first boot. Without it, `/api/health` reports a warning and document signing is disabled.

## Namespace prerequisites

The chart intentionally does not own these out-of-repo credentials. Run these once after the namespace is created:

```bash
kubectl create namespace papersign

kubectl --namespace papersign create secret generic infisical-universal-auth-credentials \
  --from-literal=clientId='<PAPERSIGN_MACHINE_IDENTITY_CLIENT_ID>' \
  --from-literal=clientSecret='<PAPERSIGN_MACHINE_IDENTITY_CLIENT_SECRET>'

kubectl --namespace laweragent get secret ghcr-pull \
  --output yaml |
  sed 's/namespace: laweragent/namespace: papersign/' |
  kubectl apply --filename -
```

Do not commit the identity credentials. The dedicated Papersign machine identity must have read access to project `3e29d88f-0254-472b-a399-036630e60ff1`, environment `prod`, path `/papersign`.

## DNS and email

Create in Cloudflare:

```text
papersign.io A 157.173.121.7 proxied
```

The Mailcow domain `papersign.io` and mailbox `noreply@papersign.io` are configured. Apply the Cloudflare SPF, DKIM, and DMARC values documented in k8s-infra `dns/papersign.io.md`. Papersign SMTP uses:

```text
host: mail.0xcloud.net
port: 587
transport: smtp-auth
username: noreply@papersign.io
from: Papersign <noreply@papersign.io>
```

## First deployment

1. Set `K8S_INFRA_PAT` and enable GitHub Actions.
2. Push Papersign `main`; wait for the image publish job.
3. Add and push `apps/papersign/` in k8s-infra with `image.tag` pinned to the published full SHA.
4. Wait for ArgoCD to sync, then inspect the application and pod.
5. After Papersign is healthy, remove the old `documenso` ArgoCD app and chart in a separate k8s-infra commit.

The initial deployment completed on 2026-10-28 and the old Documenso app/chart were removed. Its namespace and Postgres PVC remain as a recovery snapshot.

## Verification and rollback

```bash
kubectl --namespace argocd get application papersign
kubectl --namespace papersign get pods
curl --insecure https://papersign.io/api/health
```

To roll back an image, revert `image.tag` in `apps/papersign/values.yaml` to the previous full SHA. To roll back chart changes, revert the k8s-infra commit.
