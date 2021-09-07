// Übergebene Parameter
param location string
param storageName string
param storageId string
param storageApiVersion string
param databricksName string
param databricksWorkspaceId string
param databricksWorkspaceUrl string
param clusterNodeType string
param clusterVersion string
param keyVaultName string
param keyVaultBaseUrl string
param keyVaultId string
param deployAdfLinkedServices bool
param deployStandardWorkloadsAdf bool

// Variablen erzeugen
var adfName = 'adf${uniqueString(resourceGroup().id)}'

// ADF einrichten
resource adf 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: adfName
  location: location
  properties: {
    publicNetworkAccess: 'Disabled'
  }
}


// LINKED SERVICES ADF
module linkedservicesadf 'reference_linkedservices_adf.bicep' = if(deployAdfLinkedServices == true) {
  name: 'LinkedServices_ADF'
  dependsOn: [
    adf
  ]
  params: {
    adfName: adfName
    storageName: storageName
    storageId: storageId
    storageApiVersion: storageApiVersion
    databricksName: databricksName
    databricksWorkspaceId: databricksWorkspaceId
    databricksWorkspaceUrl: databricksWorkspaceUrl
    clusterNodeType: clusterNodeType
    clusterVersion: clusterVersion
    keyVaultName: keyVaultName
    keyVaultBaseUrl: keyVaultBaseUrl
    keyVaultId: keyVaultId
  }
}


// STANDARD WORKLOADS ADF
module standardWorkloadsAdf 'reference_standardworkloads_adf.bicep' = if(deployStandardWorkloadsAdf == true) {
  name: 'standardWorkloads_Adf'
  dependsOn: [
    linkedservicesadf
  ]
  params: {
    location: location
    adfName: adfName
    lakeStorageLS: linkedservicesadf.outputs.adfLinkedServiceStorageName
  }
}

output adfname string = adfName
