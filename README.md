# Kubeit examples

Demonstrate to deploy applications as tenant's example repo with many applicatations used by KubeIT for internal testing.

This repository is for KubeIT team only.

**NOTE:**

If you want to use it on your dev cluster:

* create new logical environment in `bootstrap/values.yaml` pointing to your dev cluster
* create User Managed Ideentity (MI) at [dev-shared-services resource group](https://portal.azure.com/#@dnv.onmicrosoft.com/resource/subscriptions/e5948a9c-7103-4629-98f8-798fa9a0d9aa/resourceGroups/KubeITSharedSVC-DEV-RG-WE/overview), name must ends with `-dev-tenant2`.
* grand access `get,list` on secrects on [dev KV](https://portal.azure.com/#@dnv.onmicrosoft.com/resource/subscriptions/e5948a9c-7103-4629-98f8-798fa9a0d9aa/resourceGroups/KubeITSharedSVC-DEV-RG-WE/providers/Microsoft.KeyVault/vaults/KubeIT-DEV-KV-SH-WE/overview) for this MI
* asssign role `Managed Identity Contributor` for security group `Az_KubeIT_AcrReader_Env_Dev` at created MI
* update files `dev/<your logical env name>/global.yaml` with `serviceAccount.annotations.azure.workload.identity/client-id: <your MI clientId>`

For session manager testing, please use [Wiki procedure](https://github.com/dnv-gssit/wiki/blob/main/kubeit/procedures/test-session-manager.md).

# Repository structure

```
.
├── README.md
├── bootstrap                                      # Bootstrap helm chart for all logical environments to be deployed on KubeIT
│   ├── Chart.yaml                                 # Defines `dependencies` chart for kubeit-logical-envs
│   └── values.yaml                                # Defines all logical environments and their mapping to KubeIT clusters
│                                                  # Optionally, defines which helm chart to use to deploy apps in logical environment `appLogicalEnvChart`
├── dev                                            # Logical environments for `dev` KubeIT clusters
│   ├── dev-eus2-blue                              # Folder as name of logical environment
│   │   ├── _apps.yaml                             # List of applications within logical env `dev-eus2-blue`
│   │   ├── global.yaml                            # Global values re-used for all applications within logical env
│   │   ├── onegateway-redis.yaml                  # Values for onegateway-redis application
│   │   ├── onegateway-reverseproxy-workload.yaml  # Values for onegateway-reverseproxy-workload application
│   │   ├── onegateway-secrets.yaml                # Values for onegateway-sessionmanager application
│   │   ├── onegateway-sessionmanager.yaml         # Values for onegateway-sessionmanager application
│   │   ├── onegateway-workload.yaml               # Values for onegateway-workload application
│   │   ├── standard-workload.yaml                 # Values for standard-workload application
│   │   ├── win-api-workload.yaml                  # Values for win-api-workload application
│   │   └── win-standard-workload.yaml             # Values for win-standard-workload application
│   ├── dev-eus2-green                             # Folder as name of logical environment
│   │   ├── _apps.yaml                             # List of applications within logical env `dev-eus2-green`
│   │   ├── global.yaml                            # Global values re-used for all applications within logical env
│   │   ├── <app1 name>.yaml
│   │   ├── <app2 name>.yaml
│   │   └── <app3 name>.yaml
│   ├── <logical env name>                         # Folder as name of logical environment
│   │   ├── _apps.yaml
│   │   └── global.yaml
├── nonprod                                        # Logical environments for `nonprod` KubeIT clusters
├── prod                                           # Logical environments for `prod` KubeIT clusters
```

Details can be found at [KubeIT docs](https://docs.kubeit-int.dnv.com/documentation/components/gitops/#helm-recommended).

# Development environment

1. IDE for coding: Eclipse or Visual Studio Code

2. git

3. [pre-commit](https://pre-commit.com/)

# Testing helm charts

1. Test logical envs chart

```bash
helm repo add kubeit-charts https://dnv-gssit.github.io/kubeit-charts
helm repo update
cd <this_repository>/chart
helm dependency update
# update test-logical-envs.yaml
helm tempate -f ../tests/test-logical-envs.yaml . --debug
```

2. Test apps in logical env chart

```bash
helm repo add kubeit-charts https://dnv-gssit.github.io/kubeit-charts
helm repo update
cd <this_repository>/tests
# version should match `global.appLogicalEnvChart.targetRevision` in `chart/values.yaml`
helm fetch --untar kubeit-charts/kubeit-apps-in-env --version 0.0.12
# test exact logical env
# update _apps.yaml
helm template -f test-apps-in-env.yaml -f ../nonprod/dev-we-blue/_apps.yaml kubeit-apps-in-env
```

3. Test service chart

```bash
helm repo add kubeit-charts https://dnv-gssit.github.io/kubeit-charts
helm repo add service-mesh https://dnvgl.github.io/service-mesh-chart
helm repo update
cd <this_repository>/tests

# fetch helm chart used to deploy application, set chart or version as expected
helm fetch --untar kubeit-charts/kubeit-deployment-chart --version 1.2.0
# or platform-service chart
helm fetch --untar service-mesh/platform-service --version 1.4.2

# test exact service helm chart
# update test-service.yaml
# add values by -f <file> as produced by `apps in logical` env chart above
helm template -f test-service.yaml -f ../nonprod/dev-we-blue/global.yaml -f ../nonprod/dev-we-blue/example.yaml <untar_chart_path>
```

# References:

1. [KubeIT docs](https://docs.kubeit-int.dnv.com)
