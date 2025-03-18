var location = resourceGroup().location
var osDiskSizeGB = 128
var agentCount = 1
var agentVMSize = 'Standard_D2s_v3'
var osTypeLinux = 'Linux'
var uniqueSuffix = uniqueString(resourceGroup().id)

var roleDefinitionId = {
  AcrPull: {
    id: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')
  }
  Contributor: {
    id: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  }
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-10-01' = {
  name: 'law-default'
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
  }
}

resource azureMonitorWorkspace 'Microsoft.Monitor/accounts@2023-04-03' = {
  name: 'amw-default'
  location: location
}

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-11-01-preview' = {
  name: 'cr${uniqueSuffix}'
  location: resourceGroup().location
  sku: {
    name: 'Standard'
  }
  properties: {
    anonymousPullEnabled: true
  }
}

resource aksCluster 'Microsoft.ContainerService/managedClusters@2024-09-01' = {
  location: location
  name: 'aks-${uniqueSuffix}'
  tags: {
    displayname: 'AKS Cluster'
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    enableRBAC: true
    dnsPrefix: 'aks-${uniqueSuffix}'
    agentPoolProfiles: [
      {
        name: 'syspool'
        osDiskSizeGB: osDiskSizeGB
        count: agentCount
        vmSize: agentVMSize
        osType: osTypeLinux
        type: 'VirtualMachineScaleSets'
        mode: 'System'
      }
    ]
  }
}

resource deploymentScriptIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: 'DeploymentScriptIdentity'
  location: location
}

resource deploymentScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'ds-deploymentscript'
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${deploymentScriptIdentity.id}': {}
    }
  }
  dependsOn: [
    containerRegistry
    aksCluster
  ]
  kind: 'AzureCLI'
  properties: {
    forceUpdateTag: '1'
    azCliVersion: '2.9.1'
    environmentVariables: [
      {
        name: 'RG'
        value: resourceGroup().name
      }
    ]
    scriptContent: '''
    # Install kubectl
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    mv kubectl /usr/local/bin/
    AKS=$(az aks list --resource-group $RG --query [].name --output tsv)
    ACR=$(az acr list --resource-group $RG --query [].name --output tsv)
    ACR_LOGIN_SERVER=$(az acr show --name $ACR --query loginServer --output tsv)
    # Build the Container Images
    git clone https://github.com/WayneHoggett-ACG/GlobalmanticsBooks
    cd GlobalmanticsBooks
    cd api
    az acr build --registry $ACR --image api:v1 .
    cd ../web
    az acr build --registry $ACR --image web:v1 .
    # Connect to the AKS cluster
    az aks get-credentials --resource-group $RG --name $AKS
    # Create the Namespace and Application
    kubectl create namespace globalmanticsbooks --save-config
    kubectl create deployment web --image=$ACR_LOGIN_SERVER/web:v1 --namespace globalmanticsbooks --replicas=1 --port=80
    kubectl create deployment api --image=$ACR_LOGIN_SERVER/api:v1 --namespace globalmanticsbooks --replicas=1 --port=5000
    # Monitoring Configuration
    LAW_ID=$(az monitor log-analytics workspace list --resource-group $RG --output tsv --query [].id)
    AMW_ID=$(az monitor account list --resource-group $RG --output tsv --query [].id)
    until [ "$(az aks show -g $RG -n $AKS --query provisioningState -o tsv)" == "Succeeded" ]; do sleep 10; done
    az aks enable-addons --addon monitoring --name $AKS --resource-group $RG --workspace-resource-id $LAW_ID
    until [ "$(az aks show -g $RG -n $AKS --query provisioningState -o tsv)" == "Succeeded" ]; do sleep 10; done
    az aks update --enable-azure-monitor-metrics --name $AKS --resource-group $RG --azure-monitor-workspace-resource-id $AMW_ID
    '''
    supportingScriptUris: []
    timeout: 'PT30M'
    cleanupPreference: 'OnSuccess'
    retentionInterval: 'PT1H'
  }
}
