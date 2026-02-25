# Contributing

This repository represents a personal DevOps portfolio project.
External contributions are welcome but not required.

## Development Workflow

- Main branch: `main`
- Deployment is performed from VPS using:
  
```bash
 bash ./scripts/deploy.sh
 ```

---

## Commit Convention

Commits follow Conventional Commits style:

- **feat:** new feature
- **fix:** bug fix
- **docs:** documentation update
- **refactor:** code improvement without behavior change
- **chore:** maintenance tasks
- **ci:** pipeline validation tasks/fixes

Example:

```bash
git commit -m "feat: add FastAPI health and readiness endpoints"
 ```

---

## Local Validation

Before pushing changes:

```bash
docker compose config
 ```

 Ensure:

 - No secrets committed
 - No hardcoded credentials
 - Compose config validates
