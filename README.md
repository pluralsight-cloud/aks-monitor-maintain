# Monitor and Maintain Azure Kubernetes Service (AKS)

Created with ❤️ by [Wayne Hoggett](https://github.com/WayneHoggett-ACG/)

## References

- [Azure Kubernetes Service Roadmap (Public)](https://aka.ms/aks/roadmap)
- [Azure Monitor Baseline Alerts(AMBA)](https://aka.ms/amba)

## Table of Contents

1. [Module 1](#module-1)
    1. [Clip 1 - Maintaining Azure Kubernetes Service (AKS)](#clip-1---maintaining-azure-kubernetes-service-aks)
    1. [Clip 2 - Demo: Automatically Upgrade Azure Kubernetes Service (AKS)](#clip-2---demo-automatically-upgrade-azure-kubernetes-service-aks)
1. [Module 2](#module-2)
    1. [Clip 1 - Monitoring Azure Kubernetes Service (AKS)](#clip-1---monitoring-azure-kubernetes-service-aks)
    1. [Clip 2 - Demo: Configure Diagnostic Settings](#clip-2---demo-configure-diagnostic-settings)
    1. [Clip 3 - Demo: Enable Container Insights](#clip-3---demo-enable-container-insights)
    1. [Clip 4 - Demo: Configure Prometheus Monitoring](#clip-4---demo-configure-prometheus-monitoring)
    1. [Clip 5 - Demo: Configure Recommended Alerts](#clip-5---demo-configure-recommended-alerts)
    1. [Clip 6 - Demo: Configure Application Insights](#clip-6---demo-configure-application-insights)

## Module 1

### Clip 1 - Maintaining Azure Kubernetes Service (AKS)

- [Kubernetes Release Versioning](https://github.com/kubernetes/sig-release/blob/master/release-engineering/versioning.md)
- [AKS Upgrade Best Practices](https://learn.microsoft.com/azure/architecture/operator-guides/aks/aks-upgrade-practices)
- [Azure Kubernetes Service patch and upgrade guidance](https://learn.microsoft.com/azure/architecture/operator-guides/aks/aks-upgrade-practices)
- [Upgrading Azure Kubernetes Service clusters and node pools](https://learn.microsoft.com/azure/aks/upgrade)
- [Supported Kubernetes versions in Azure Kubernetes Service (AKS)](https://learn.microsoft.com/azure/aks/supported-kubernetes-versions)
- [Specifying a Disruption Budget for your Application](https://kubernetes.io/docs/tasks/run-application/configure-pdb/)
- [Pod Disruptions](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/ )

### Clip 2 - Demo: Automatically Upgrade Azure Kubernetes Service (AKS)

To follow along in this demo using the Cloud Playground Sandbox, follow these steps:

1. Start an Azure Sandbox.
1. Log in to the Azure Sandbox using the provided credentials.
1. Click the **Deploy to Azure** button. Make sure the link opens in the Sandbox browser tab.

    [![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fpluralsight-cloud%2Faks-monitor-maintain%2Frefs%2Fheads%2Fmain%2F1.2%2Fmain.json)

1. Select the existing **Subscription** and **Resource Group**.
1. Provide the `Application Client ID` and `Secret` from the Sandbox details.
1. Deploy the template.
1. Follow-along with the demo.

#### Additional Learning Material

**Note**: To implement some of the functionality in these additional links, you might require your own Azure subscription.

- [Automatically upgrade an Azure Kubernetes Service (AKS) cluster](https://learn.microsoft.com/azure/aks/auto-upgrade-cluster)
- [Auto-upgrade node OS images](https://learn.microsoft.com/azure/aks/auto-upgrade-node-os-image?tabs=azure-cli)

## Module 2

### Clip 1 - Monitoring Azure Kubernetes Service (AKS)

- [Monitor Azure Kubernetes Service (AKS)](https://learn.microsoft.com/azure/aks/monitor-aks)

### Clip 2 - Demo: Configure Diagnostic Settings

To follow along in this demo using the Cloud Playground Sandbox, follow these steps:

1. Start an Azure Sandbox.
1. Log in to the Azure Sandbox using the provided credentials.
1. Click the **Deploy to Azure** button. Make sure the link opens in the Sandbox browser tab.

    [![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fpluralsight-cloud%2Faks-monitor-maintain%2Frefs%2Fheads%2Fmain%2F2.2%2Fmain.json)

1. Select the existing **Subscription** and **Resource Group**.
1. Deploy the template.
1. Follow-along with the demo.

### Clip 3 - Demo: Enable Container Insights

To follow along in this demo using the Cloud Playground Sandbox, follow these steps:

1. Start an Azure Sandbox.
1. Log in to the Azure Sandbox using the provided credentials.
1. Click the **Deploy to Azure** button. Make sure the link opens in the Sandbox browser tab.

    [![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fpluralsight-cloud%2Faks-monitor-maintain%2Frefs%2Fheads%2Fmain%2F2.3%2Fmain.json)

1. Select the existing **Subscription** and **Resource Group**.
1. Deploy the template.
1. Follow-along with the demo.

### Clip 4 - Demo: Configure Prometheus Monitoring

1. To follow along with this demonstration you will need your own subscription.
1. Log in to the Azure Portal.
1. Open **Cloud Shell** using **Bash** and set the subscription you'd like to use:

    ```bash
    az account set --subscription "<Subscription ID>"
    ```

    >**Note**: Replace the value of `<Subscription ID>` with the ID of the subscription you'd like to use.

1. Create a resource group for the demonstration.

    > **Note**: You can change the name of the resource group and location as required. But you must use a region where App Gateway for Containers is available.

    ```bash
    RG=$(az group create --location <location> --resource-group <resource group name> --query name --output tsv)
    ```

1. Click the **Deploy to Azure** button. Make sure the link opens in the same browser tab as the Azure Portal.

    [![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fpluralsight-cloud%2Faks-monitor-maintain%2Frefs%2Fheads%2Fmain%2F2.4%2Fmain.json)

1. Select your preferred **Subscription** and **Resource Group**.
1. Deploy the template.
1. Follow-along with the demo.

### Clip 5 - Demo: Configure Recommended Alerts

1. To follow along with this demonstration you will need your own subscription.
1. Log in to the Azure Portal.
1. Open **Cloud Shell** using **Bash** and set the subscription you'd like to use:

    ```bash
    az account set --subscription "<Subscription ID>"
    ```

    >**Note**: Replace the value of `<Subscription ID>` with the ID of the subscription you'd like to use.

1. Create a resource group for the demonstration.

    > **Note**: You can change the name of the resource group and location as required. But you must use a region where App Gateway for Containers is available.

    ```bash
    RG=$(az group create --location <location> --resource-group <resource group name> --query name --output tsv)
    ```

1. Click the **Deploy to Azure** button. Make sure the link opens in the same browser tab as the Azure Portal.

    [![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fpluralsight-cloud%2Faks-monitor-maintain%2Frefs%2Fheads%2Fmain%2F2.5%2Fmain.json)

1. Select your preferred **Subscription** and **Resource Group**.
1. Deploy the template.
1. Follow-along with the demo.

### Clip 6 - Demo: Configure Application Insights

To follow along in this demo using the Cloud Playground Sandbox, follow these steps:

1. Start an Azure Sandbox.
1. Log in to the Azure Sandbox using the provided credentials.
1. Click the **Deploy to Azure** button. Make sure the link opens in the Sandbox browser tab.

    [![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fpluralsight-cloud%2Faks-monitor-maintain%2Frefs%2Fheads%2Fmain%2F2.6%2Fmain.json)

1. Select the existing **Subscription** and **Resource Group**.
1. Provide the `Application Client ID` and `Secret` from the Sandbox details.
1. Deploy the template.
1. Follow-along with the demo.
