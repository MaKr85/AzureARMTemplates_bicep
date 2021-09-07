// Übergebene Parameter
param location string
param subnetIdDataStorage string
param currenttenant string
param allowedIPs array
param container array


// Variablen erzeugen
var storageAccountName = 'lakestorage${uniqueString(resourceGroup().id)}'


// Storage Account einrichten
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageAccountName
  location: location
    sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: true
    allowSharedKeyAccess: true
    isHnsEnabled: true
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: [
        {
          id: subnetIdDataStorage
          action: 'Allow'
        }
      ]
      resourceAccessRules: [
        {
          tenantId: currenttenant
          resourceId: resourceId('Microsoft.DataFactory/factories','*')
        }
        {
          tenantId: currenttenant
          resourceId: resourceId('Microsoft.ContainerInstance/containerGroups','*')
        }
        {
          tenantId: currenttenant
          resourceId: resourceId('Microsoft.Synapse/workspaces','*')
        }
        {
          tenantId: currenttenant
          resourceId: resourceId('Microsoft.Databricks/workspaces','*')
        }
      ]
      ipRules: [
        { 
          value: allowedIPs[0]
          action: 'Allow'
        }
        { 
          value: allowedIPs[1]
          action: 'Allow'
        }
      ]
      defaultAction: 'Deny'
    }
  }
}


// Container einrichten (Referenz)
resource contDataLake 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-04-01' = [for cont in container: {
  name: '${storageAccount.name}/default/${cont}'
  dependsOn: [
    storageAccount
  ]
}]

output accountUrl string = reference(storageAccountName).primaryEndpoints.dfs
output storageName string = storageAccountName
output storageId string = storageAccount.id
output storageApiVersion string = storageAccount.apiVersion


