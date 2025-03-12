
@description('The tenant ID for the Service Principal (Application), use the default value for the Sandbox')
param tenantId string = '84f1e4ea-8554-43e1-8709-f0b8589ea118'
@description('The Client ID for the Service Principal (Application). Retrieve this value from the details of your Sandbox instance.')
param applicationClientId string
@secure()
@description('The Client Secret for the Service Principal (Application). Retrieve this value from the details of your Sandbox instance.')
param applicationClientSecret string

metadata name = 'Demo: Automatically Upgrade AKS'
metadata description = 'Deploy this template to follow-along with the demonstration.'

var location  = resourceGroup().location

resource CreateAKSCluster 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'CreateAKSCluster'
  location: location
  kind: 'AzurePowerShell'
  properties: {
    environmentVariables: [
      {
        name: 'APP_ID'
        value: applicationClientId
      }
      {
        name: 'CLIENT_SECRET'
        value: applicationClientSecret
      }
      {
        name: 'TENANT_ID'
        value: tenantId
      }
    ]
    forceUpdateTag: '1'
    azPowerShellVersion: '10.1'
    scriptContent: '''
    $SecurePassword = ConvertTo-SecureString "${env:CLIENT_SECRET}" -AsPlainText -Force
    $TenantId = "${env:TENANT_ID}"
    $ApplicationId = "${env:APP_ID}"
    $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $ApplicationId, $SecurePassword
    Connect-AzAccount -ServicePrincipal -TenantId $TenantId -Credential $Credential
    $ResourceGroup = Get-AzResourceGroup
    $ResourceGroupName = $ResourceGroup.ResourceGroupName
    $Location = $ResourceGroup.Location
    $Version = Get-AzAksVersion -Location $Location | Sort-Object OrchestratorVersion | Select-Object -ExpandProperty OrchestratorVersion -First 1
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/WayneHoggett-ACG/aks-maintain-draft/refs/heads/main/1.2/aks.json" -OutFile "aks.json"
    New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName -TemplateFile 'aks.json' -kubernetesVersion $Version
    '''
    supportingScriptUris: []
    timeout: 'PT30M'
    cleanupPreference: 'OnSuccess'
    retentionInterval: 'PT1H'
  }
}
