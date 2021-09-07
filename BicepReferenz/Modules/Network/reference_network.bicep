param location string
param vnetAddressPrefix string
param subnetDatastoragePrefix string
param subnetComputePrefix string
param subnetDWHPrefix string
param subnetDbPublicPrefix string
param subnetDbPrivatePrefix string
param subnetSupportPrefix string

var nsgName = 'nsg${uniqueString(resourceGroup().id)}'
var nsgDbName = 'nsgdb${uniqueString(resourceGroup().id)}'
var vnetName = 'vNet${uniqueString(resourceGroup().id)}'

var subNetDataStorageName = 'datastorage'
var subNetComputeName = 'compute'
var subNetDwhName = 'dwh'
var subNetSupportName = 'support'
var subNetdbPublicName = 'databrickspublic'
var subNetdbPrivateName = 'databricksprivate'


resource nsg 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: nsgName
  location: location
}

resource nsgDatabricks 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: nsgDbName
  location: location
}

resource vNet 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
  }
}

resource vNet_SubNetDataStorage 'Microsoft.Network/virtualNetworks/subnets@2020-06-01' = {
  parent: vNet
  name: subNetDataStorageName
  properties: {
    addressPrefix: subnetDatastoragePrefix
    serviceEndpoints: [
      {
        service: 'Microsoft.Storage'
      }
    ]
    networkSecurityGroup: {
      id: nsg.id
    }
  }
  dependsOn: [
    nsg
  ]
}

resource vNet_SubNetCompute 'Microsoft.Network/virtualNetworks/subnets@2020-06-01' = {
  parent: vNet
  name: subNetComputeName
  properties: {
    addressPrefix: subnetComputePrefix
    networkSecurityGroup: {
      id: nsg.id
    }
  }
  dependsOn: [
    vNet_SubNetDataStorage
  ]
}


resource vNet_SubNetDWH 'Microsoft.Network/virtualNetworks/subnets@2020-06-01' = {
  parent: vNet
  name: subNetDwhName
  properties: {
    addressPrefix: subnetDWHPrefix
    networkSecurityGroup: {
      id: nsg.id
    }
  }
  dependsOn: [
    vNet_SubNetCompute
  ]
}

resource vNet_SubNetSupport 'Microsoft.Network/virtualNetworks/subnets@2020-06-01' = {
  parent: vNet
  name: subNetSupportName
  properties: {
    addressPrefix: subnetSupportPrefix
    serviceEndpoints: [
      {
        service: 'Microsoft.KeyVault'
      }
    ]
    networkSecurityGroup: {
      id: nsg.id
    }
  }
  dependsOn: [
    vNet_SubNetDWH
  ]
}

resource vNet_SubNetDbPublic 'Microsoft.Network/virtualNetworks/subnets@2020-06-01' = {
  parent: vNet
  name: subNetdbPublicName
  properties: {
    addressPrefix: subnetDbPublicPrefix
    delegations: [
      {
        name: 'Microsoft.Databricks.workspaces'
        properties: {
          serviceName: 'Microsoft.Databricks/workspaces'
        }
      }
    ]
    networkSecurityGroup: {
      id: nsgDatabricks.id
    }
  }
  dependsOn: [
    vNet_SubNetSupport
  ]
}


resource vNet_SubNetDbPrivate 'Microsoft.Network/virtualNetworks/subnets@2020-06-01' = {
  parent: vNet
  name: subNetdbPrivateName
  properties: {
    addressPrefix: subnetDbPrivatePrefix
    delegations: [
      {
        name: 'Microsoft.Databricks.workspaces'
        properties: {
          serviceName: 'Microsoft.Databricks/workspaces'
        }
      }
    ]
    networkSecurityGroup: {
      id: nsgDatabricks.id
    }
  }
  dependsOn: [
    vNet_SubNetDbPublic
  ]
}



var subnetId = [
  resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, subNetDataStorageName)
  resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, subNetComputeName)
  resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, subNetDwhName)
  resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, subNetSupportName)
]

output nsgname string = nsgName
output vNetName string = vnetName 
output vNetId string = vNet.id
output subnetIdDataStorage string = subnetId[0]
output subnetIdCompute string = subnetId[1]
output subnetIdDwh string = subnetId[2]
output subnetIdSupport string = subnetId[3]
output nsgId string = nsg.id
