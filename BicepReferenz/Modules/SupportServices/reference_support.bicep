// Übergebene Parameter
param location string
param currenttenant string
param pricingTier string
param vNetId string
param subnetIdSupport string



// Variablen erzeugen
var keyvaultName = 'keyvault${uniqueString('123')}'
var databricksName = 'databricks${uniqueString(resourceGroup().id)}'
var managedResourceGroupName = 'databricks-rg-${databricksName}-${uniqueString(databricksName, resourceGroup().id)}'

var allowedIps  = [
  '84.128.153.105'
  '62.96.137.98'
]

// KeyVault
resource keyvault 'Microsoft.KeyVault/vaults@2021-06-01-preview' = {
  name: keyvaultName
  location: location
properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: currenttenant
    accessPolicies: []
    enabledForDeployment: false
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: false
    enableSoftDelete: true
    softDeleteRetentionInDays: 90
    enableRbacAuthorization: true 
    publicNetworkAccess: 'enabled'
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: [
        {
          id: subnetIdSupport
        }
      ]
      ipRules: [
        { 
          value: allowedIps[0]
        }
        { 
          value: allowedIps[1]
        }
      ]
      defaultAction: 'Deny'
    }
  }
}


// Databricks Workspace
resource databricks 'Microsoft.Databricks/workspaces@2018-04-01' = {
  name: databricksName
  location: location
  sku: {
    name: pricingTier
  }
  properties: {
    managedResourceGroupId: subscriptionResourceId('Microsoft.Resources/resourceGroups', managedResourceGroupName)
    parameters: {
      enableNoPublicIp: {
        value: false
      }
      customPrivateSubnetName: {
        value: 'databricksprivate'
      }
      customPublicSubnetName: {
        value: 'databrickspublic'
      }
      customVirtualNetworkId: {
        value: vNetId
      }
    }
  }
}


output keyvaultname string = keyvaultName
output keyvaultbaseurl string = keyvault.properties.vaultUri
output keyVaultId string = keyvault.id
output databricksName string = databricks.name
output databricksWorkspaceId string = databricks.properties.workspaceId
output databricksWorkspaceUrl string = databricks.properties.workspaceUrl
