# kubeit-app-of-apps
Internal example repository demonstrating app-of-apps deployments in ArgoCD.
kubeit-app-of-apps and kubeit-charts repos are complementary and cannot function without each other (both repositories must have feature branches and require modifications to run examples for tenant2).

How to use it in kubeit development cluster:
1. Create working branch of kubeit-app-of-apps.
2. Update reference in voa-platform-apps/argocd/env-config/values-minimal-dev.yaml (or values-dev.yaml depending on situation) to point to this branch instead of main.
3. Add your dev cluster in appropriate section in chart/values.yaml depending on which app you intend to deploy.
4. Open [kubeit-charts](https://github.com/dnv-gssit/kubeit-charts) repo, and follow the README instructions.

## Session manager
To use examples with session manager follow procedure:
https://github.com/dnv-gssit/wiki/blob/main/kubeit/procedures/test-session-manager.md

## Workload identity
To disable workload identity, go to kubeit-charts/charts/kubeit-app-of-apps/templates/applications.yaml and switch workloadIdentity to "false".