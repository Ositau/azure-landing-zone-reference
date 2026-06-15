# Azure Landing Zone — Terraform Reference

A production-shaped **Azure hub landing zone**, delivered entirely as code: reusable
Terraform modules, multi-environment composition (dev/prod), governance guardrails,
secure-by-default networking, and CI/CD for both **GitHub Actions** and **Azure DevOps**.

Built to demonstrate how I deliver Azure infrastructure on real engagements —
automation-first, CAF-aligned, and drift-free across environments.

> Reference/portfolio repository. It plans cleanly and is structured exactly as I run
> client estates; storage/state and subscription IDs are placeholders.

---

## Architecture

```mermaid
graph TB
    TF["Terraform / CI - provisions everything as code"]
    subgraph SUB["Azure Subscription - one per environment"]
        subgraph RG["Resource Group: rg-org-platform-env-uks-001"]
            POL["Azure Policy<br/>deny resources missing required tags"]
            LAW["Log Analytics<br/>diagnostics and retention"]
            subgraph VNET["Hub VNet 10.x.0.0/16"]
                AFW["AzureFirewallSubnet (no NSG)"]
                GW["GatewaySubnet (no NSG)"]
                SH["snet-shared<br/>service endpoints"]
                PL["snet-privatelink<br/>private endpoints"]
            end
            NSG["NSG<br/>allow intra-VNet, deny Internet"]
        end
    end
    TF --> RG
    NSG -. associated .-> SH
    NSG -. associated .-> PL
    SH -- logs --> LAW
    PL -- logs --> LAW

    classDef policy fill:#3b2f5e,stroke:#8b5cf6,color:#fff;
    classDef net fill:#0d3b4f,stroke:#22d3ee,color:#fff;
    class POL,NSG policy;
    class AFW,GW,SH,PL net;
```

## Delivery pipeline

```mermaid
flowchart LR
    PUSH["git push / PR"] --> FMT["fmt"] --> VAL["validate"] --> LINT["tflint"] --> SEC["Checkov scan"] --> PLAN["plan"]
    PLAN --> GATE{"manual approval"}
    GATE -- approved --> APPLY["terraform apply"] --> AZ["Azure landing zone"]
```

## Module composition

```mermaid
graph LR
    ROOT["environments/dev and prod<br/>thin root + tfvars + backend"]
    ROOT --> NAMING["module: naming<br/>CAF-aligned names"]
    ROOT --> GOV["module: governance<br/>RG, Log Analytics, tag policy"]
    ROOT --> NET["module: networking<br/>VNet, subnets, NSG"]
    NAMING -. names .-> GOV
    NAMING -. names .-> NET
    GOV -. workspace id .-> NET
```

---

## What it demonstrates

- **Infrastructure as Code** — Terraform 1.6+, azurerm v4, reusable modules with
  validated inputs, typed `optional()` object variables, and clean outputs.
- **CAF-aligned governance** — standardised resource naming, Log Analytics, and an
  **Azure Policy that denies resources missing mandatory tags** (policy-as-code).
- **Secure-by-default networking** — hub VNet, correctly-named platform subnets
  (Gateway/Firewall excluded from the workload NSG), and an NSG that allows intra-VNet
  traffic while denying inbound Internet. Private Endpoint subnet ready.
- **Multi-environment without drift** — one thin root per environment; only the
  `*.tfvars` and backend key change, so dev and prod are guaranteed the same shape.
- **CI/CD two ways** — GitHub Actions (fmt → validate → tflint → Checkov, matrixed
  per env) and an Azure DevOps multi-stage pipeline (Validate → Plan → Apply with a
  manual approval gate, OIDC auth, remote-state init).
- **No secrets in the repo** — remote state config and cloud auth supplied at runtime.

## Repository layout

```
modules/
  naming/        CAF-aligned, deterministic resource names (one source of truth)
  governance/    resource group, Log Analytics, required-tags Azure Policy
  networking/    hub VNet, subnets, secure-default NSG, NSG diagnostics
environments/
  dev/           thin root: composes the modules + dev tfvars/backend
  prod/          same composition, prod-scaled values
.github/workflows/terraform.yml   GitHub Actions CI
azure-pipelines.yml               Azure DevOps multi-stage pipeline
docs/architecture.md              diagram + design decisions
```

## Usage

```bash
cd environments/dev

# Remote state lives in Azure Storage; values are passed at init (not committed).
terraform init -backend-config=backend.hcl

terraform plan   -var-file=terraform.tfvars
terraform apply  -var-file=terraform.tfvars
```

Promote to production by running the same commands in `environments/prod` — identical
module composition, different scale and state key.

## Tooling

| Area | Tools |
|---|---|
| IaC | Terraform, azurerm v4 |
| Quality | `terraform fmt`, `validate`, tflint |
| Security | Checkov |
| CI/CD | GitHub Actions, Azure DevOps |
| Cloud | Azure — VNet/NSG, Policy, Log Analytics, RBAC-ready |

## About

Built by a Senior Azure Cloud & Security Engineer (Azure Solutions Architect Expert
AZ-305, Terraform Associate) — see [architecture.md](docs/architecture.md) for design
rationale.
