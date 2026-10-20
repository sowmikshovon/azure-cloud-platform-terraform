# Azure Cloud Platform Infrastructure as Code (Terraform & GitHub Actions)

![Terraform Azure Governance CI](https://github.com/sowmikshovon/azure-cloud-platform-terraform/actions/workflows/ci.yml/badge.svg)

Standardized Infrastructure as Code (IaC) blueprint provisioning a compliant **Microsoft Azure** container platform using **Terraform** and automated **GitHub Actions** governance checks.

## Architecture & Governance Features
- **Azure Resource Group (`northeurope`)**: Standardized resource tagging (`Environment`, `ManagedBy`, `Owner`, `Compliance`).
- **Azure Container Registry (Premium SKU)**: Admin account disabled to enforce identity-based access control.
- **Azure Kubernetes Service (AKS)**: Configured with SystemAssigned Managed Identity, OIDC workload identity, Calico network policies, and automated patch upgrades.
- **Automated CI/CD Governance**: GitHub Actions pipeline executes `terraform fmt`, `terraform init -backend=false`, `terraform validate`, and **Trivy IaC security scanning** on every commit.
