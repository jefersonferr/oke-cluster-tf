# Contributing to OKE Cluster Terraform

Thank you for your interest in contributing to this project. This guide explains how to get involved.

## Reporting Issues

Open a GitHub Issue with the following information:

- A clear description of the problem or suggestion
- Steps to reproduce the issue (if applicable)
- The Terraform and OCI provider versions you are using
- The CNI plugin and API endpoint configuration (which of the 4 scenarios)

## Submitting Pull Requests

1. Fork the repository and create a feature branch from `main`.
2. Make your changes following the code standards described below.
3. Run validation before submitting:
```bash
terraform fmt -recursive
terraform init -backend=false
terraform validate
```

4. Open a pull request with a clear description of the changes and the motivation behind them.

## Code Standards

- All variables must have `type` and `description` defined in expanded format.
- All comments must be written in English.
- Use `terraform fmt` canonical formatting — the CI pipeline enforces this.
- Avoid hardcoded values — use variables with sensible defaults.
- Module naming convention: `snake_case` for directories, `kebab-case` for module references in `main.tf`.

## Testing Changes

If your change affects networking or cluster provisioning logic, please test against at least one of the four reference scenarios:

| Scenario | `cni_type` | `is_api_endpoint_public` |
|----------|-----------|--------------------------|
| Example 1 | `FLANNEL` | `true` |
| Example 2 | `FLANNEL` | `false` |
| Example 3 | `OCI_VCN_IP_NATIVE` | `true` |
| Example 4 | `OCI_VCN_IP_NATIVE` | `false` |

Use the `.tfvars.example` files in the `examples/` directory as a starting point.

## License

By contributing, you agree that your contributions will be licensed under the Apache License 2.0.