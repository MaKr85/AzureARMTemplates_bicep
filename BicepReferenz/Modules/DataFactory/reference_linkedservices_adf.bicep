// Übergebene Parameter
param adfName string
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

// Variablen erzeugen
var adfLinkedServiceStorageName = '${storageName}_LS'
var adfLinkedServiceDatabricksName = '${databricksName}_LS'
var adfLinkedServiceKeyVaultName = '${keyVaultName}_LS'


resource dataFactoryManagedVirtualNetwork 'Microsoft.DataFactory/factories/managedVirtualNetworks@2018-06-01' = {
  name: '${adfName}/default'
  properties: {}
  dependsOn: []
}

resource dataFactoryAutoResolveIntegrationRuntime 'Microsoft.DataFactory/factories/integrationRuntimes@2018-06-01' = {
  name: '${adfName}/AutoResolveIntegrationRuntime'
  properties: {
    type: 'Managed'
    typeProperties: {
      computeProperties: {
        location: 'AutoResolve'
        dataFlowProperties: {
          computeType: 'General'
          coreCount: 8
          timeToLive: 0
        }
      }
    }
    managedVirtualNetwork: {
      type: 'ManagedVirtualNetworkReference'
      referenceName: 'default'
    }
  }
  dependsOn: [
    dataFactoryManagedVirtualNetwork
  ]
}

resource dataFactoryPrivateEndpointStorage 'Microsoft.DataFactory/factories/managedVirtualNetworks/managedPrivateEndpoints@2018-06-01' = {
  parent: dataFactoryManagedVirtualNetwork
  name: '${storageName}_ep'
  properties: {
    privateLinkResourceId: storageId
    groupId: 'dfs'
  }
  dependsOn: [
    dataFactoryManagedVirtualNetwork
  ]
}


resource dataFactoryLinkedServiceStorage 'Microsoft.DataFactory/factories/linkedservices@2018-06-01' = {
  name: '${adfName}/${adfLinkedServiceStorageName}'
  properties: {
    annotations: []
    type: 'AzureBlobFS'
    typeProperties: {
      url: 'https://${storageName}.dfs.core.windows.net'
      accountKey: {
        type: 'SecureString'
        value: '${listKeys(storageId, storageApiVersion).keys[0].value}'
      }
    }
    connectVia: {
      referenceName: 'AutoResolveIntegrationRuntime'
      type: 'IntegrationRuntimeReference'
    }
  }
  dependsOn: [
    dataFactoryAutoResolveIntegrationRuntime
    dataFactoryPrivateEndpointStorage
  ]
}

resource dataFactoryLinkedServiceKeyVault 'Microsoft.DataFactory/factories/linkedservices@2018-06-01' = {
  name: '${adfName}/${adfLinkedServiceKeyVaultName}'
  properties: {
    type: 'AzureKeyVault'
    typeProperties: {
      baseUrl: keyVaultBaseUrl
    }
  }
}

resource dataFactoryLinkedServiceDatabricks 'Microsoft.DataFactory/factories/linkedservices@2018-06-01' = {
  name: '${adfName}/${adfLinkedServiceDatabricksName}'
  properties: {
    type: 'AzureDatabricks'
    typeProperties: {
      domain: 'https://${databricksWorkspaceUrl}'
      authentication: 'MSI'
      workspaceResourceId: databricksWorkspaceId
      newClusterNodeType: clusterNodeType
      newClusterNumOfWorker: '1:4'
      newClusterSparkEnvVars: {
        PYSPARK_PYTHON: '/databricks/python3/bin/python3'
      }
      newClusterVersion: clusterVersion
    }
    connectVia: {
      referenceName: 'AutoResolveIntegrationRuntime'
      type: 'IntegrationRuntimeReference'
    }
  }
  dependsOn: [
    dataFactoryAutoResolveIntegrationRuntime
  ]
}


output adfLinkedServiceStorageName string = adfLinkedServiceStorageName
output adfLinkedServiceDatabricksName string = adfLinkedServiceDatabricksName
output adfLinkedServiceKeyVaultName string = adfLinkedServiceKeyVaultName
