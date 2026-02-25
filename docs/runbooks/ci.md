# Runbook: CI Pipeline

## Purpose

Define automated validation and security controls executed on every push and pull request.

The CI pipeline enforces configuration correctness, image build integrity,
and vulnerability scanning before changes reach the VPS.

---

## Execution Environment

CI runs in GitHub Actions:

Repository → Actions tab

Triggered on:
- Push to `main`
- Pull requests

---

## What the Pipeline Validates

### 1. Docker Compose Validation

Ensures production configuration is syntactically valid:

``` bash
docker compose -f infra/compose/prod/compose.yml config
```

Prevents runtime failures caused by malformed YAML or invalid schema.

---

### 2. Backend Image Build

Builds the FastAPI container image:

``` bash
docker build ./app/backend
```

Ensures Dockerfile and dependencies are consistent.

---

### 3. YAML Linting

Validated via `yamllint`.

Purpose:
- Enforce formatting consistency
- Prevent configuration drift
- Avoid subtle YAML parsing issues

---

### 4. Shell Script Linting

Validated via `ShellCheck`.

Ensures:
- Safer Bash scripting
- No unused variables
- Proper error handling

---

### 5. Container Vulnerability Scanning (Trivy)

The backend image is scanned using Trivy.

Configuration:
- Severity: `CRITICAL`, `HIGH`
- `ignore-unfixed` enabled
- Fails pipeline on detected vulnerabilities
- Report uploaded as CI artifact

Security Model:
- HIGH/CRITICAL vulnerabilities block merge/deployment
- Exceptions must be explicitly declared in `.trivyignore`

---

## Interpreting Failures

### Compose validation failed
Likely YAML syntax error or invalid service definition.

### Backend build failed
Dockerfile or dependency issue.

### Lint failed
Formatting or script quality issue.

### Trivy failed
A new HIGH or CRITICAL vulnerability was introduced.

Recommended workflow:
1. Identify affected dependency
2. Update package or base image
3. Rebuild locally
4. Push and re-run CI

If no fix is available:
- Add explicit CVE to `.trivyignore`
- Document justification in commit message

---

## Deployment Model

CI validates only.

Deployment remains SSH-based by design:

Local → GitHub → VPS

On VPS:

``` bash
cd /srv/erp/repo
bash ./scripts/deploy.sh
```

There is intentionally no automatic production deployment.