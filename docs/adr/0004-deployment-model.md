# ADR 0004: Deployment Model and Scope Boundaries

## Status
Accepted

---

## Context

This project demonstrates a production-like infrastructure stack
running on a single Ubuntu VPS.

The goals are:

- Reverse proxy architecture
- Automated TLS
- Observability integration
- Deployment automation
- Secure server baseline

The project intentionally avoids unnecessary architectural complexity
in order to focus on core DevOps principles.

---

## Decision

The deployment model is:

- SSH-based deployment
- Single-node architecture
- Docker Compose orchestration
- No CI/CD pipeline (yet)
- No container orchestration platform (e.g. Kubernetes)

---

## Rationale

### 1. SSH-Based Deployment

Deployment is performed via:

``` bash
bash ./scripts/deploy.sh
```

Reasons:

- Full transparency of deployment steps
- Explicit operational control
- Suitable for single-node infrastructure
- Demonstrates idempotent deployment logic

For this scope, adding CI/CD would introduce complexity
without increasing architectural clarity.

---

### 2. Single-Node Architecture

The stack runs on one VPS.

Reasons:

- Controlled scope
- Focus on infrastructure correctness
- Avoid premature distributed system complexity
- Demonstrate proper service isolation within a node

Scaling concerns are intentionally out of scope for this stage.

---

### 3. Why Not Kubernetes?

Kubernetes was intentionally excluded.

Reasons:

- The project goal is infrastructure maturity, not orchestration scale.
- Kubernetes would increase operational overhead.
- For a single-node environment, Docker Compose is sufficient.
- Demonstrates understanding of right-sizing architecture to context.

Kubernetes may be introduced in a future iteration if horizontal scaling becomes a requirement.

---

## Consequences

### Positive

- Reduced operational complexity
- Clear deployment model
- Easy reproducibility
- Full control over runtime state

### Trade-offs

- No horizontal scaling
- No automated CI/CD pipeline
- Manual deployment step required

These trade-offs are accepted within current scope.

---

## Future Evolution

Potential next steps:

- GitHub Actions for validation
- Image scanning (Trivy)
- Infrastructure provisioning (Ansible)
- Migration to container orchestration if scaling is required