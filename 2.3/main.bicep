
var location  = resourceGroup().location
var osDiskSizeGB  = 128
var agentCount = 1
var agentVMSize = 'Standard_D2s_v3'
var osTypeLinux = 'Linux'
var uniqueSuffix = uniqueString(resourceGroup().id)

resource aksCluster 'Microsoft.ContainerService/managedClusters@2024-06-02-preview' = {
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

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-10-01' = {
  name: 'law-default'
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
  }
}
