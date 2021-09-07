param location string
param storageName string
param accountUrl string
param sqlAdminPwd string
param skuSqlPool string
param allowedIPs array

var synapseWorkspaceName = 'synapse${uniqueString(resourceGroup().id)}'



// Container für Synapse erstellen
resource contSynapse 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-04-01' = {
  name: '${storageName}/default/synapse'
  properties: {
    publicAccess: 'None'
  }
}

resource synapseWorkspace 'Microsoft.Synapse/workspaces@2021-06-01-preview' = {
  name: synapseWorkspaceName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    defaultDataLakeStorage: {
      accountUrl: accountUrl
      filesystem: 'synapse'
    }
    sqlAdministratorLogin: 'synapse-admin'
    sqlAdministratorLoginPassword: sqlAdminPwd
    managedVirtualNetwork: 'default' 
  }
  dependsOn: [
    contSynapse
  ]
}


resource synapseWorkspace_AllowAllWindowsAzureIps 'Microsoft.Synapse/workspaces/firewallRules@2021-06-01-preview' = {
  parent: synapseWorkspace
  name: 'AllowAllWindowsAzureIps'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}


resource synapseWorkspace_AllowAretoIp 'Microsoft.Synapse/workspaces/firewallRules@2021-06-01-preview' = [for IP in allowedIPs: {
  parent: synapseWorkspace
  name: 'AllowIP_${IP}'
  properties: {
    startIpAddress: IP
    endIpAddress: IP
  }
}]


resource workspaceName_sqlPoolName 'Microsoft.Synapse/workspaces/sqlPools@2019-06-01-preview' = {
  parent: synapseWorkspace
  name: 'sqlpool${synapseWorkspaceName}'
  location: location
  sku: {
    name: skuSqlPool
  }
  properties: {
    createMode: 'Default'
    collation: 'SQL_Latin1_General_CP1_CI_AS'
  }
}


output synapseName string = synapseWorkspaceName
output adminpwd string = sqlAdminPwd
