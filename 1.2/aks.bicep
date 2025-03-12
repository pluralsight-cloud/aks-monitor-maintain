param location string = resourceGroup().location
param osDiskSizeGB int = 128
param agentCount int = 1
param agentVMSize string = 'Standard_D2s_v3'
param osTypeLinux string = 'Linux'
param kubernetesVersion string
param enableMaintenanceConfigurations bool = false

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
    kubernetesVersion: kubernetesVersion
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

resource aksManagedAutoUpgradeSchedule 'Microsoft.ContainerService/managedClusters/maintenanceConfigurations@2024-06-02-preview' =  if (enableMaintenanceConfigurations) {
  parent: aksCluster
  name: 'aksManagedAutoUpgradeSchedule'
  properties: {
    maintenanceWindow: {
      durationHours: 6
      schedule: {
        weekly: {
          dayOfWeek: 'Thursday'
          intervalWeeks: 2
        }
      }
      startTime: '00:00'
      utcOffset: '+10:00'
    }
  }
}

resource aksManagedNodeOSUpgradeSchedule 'Microsoft.ContainerService/managedClusters/maintenanceConfigurations@2024-06-02-preview' = if (enableMaintenanceConfigurations) {
  parent: aksCluster
  name: 'aksManagedNodeOSUpgradeSchedule'
  properties: {
    maintenanceWindow: {
      durationHours: 6
      schedule: {
        weekly: {
          dayOfWeek: 'Tuesday'
          intervalWeeks: 1
        }
      }
      startTime: '00:00'
      utcOffset: '+10:00'
    }
  }
}
