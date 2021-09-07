param pricingTier string
param clusterNodeType string
param clusterVersion string
param vnetAddressPrefix  string
param subnetDatastoragePrefix  string
param subnetComputePrefix  string
param subnetDWHPrefix  string
param subnetSupportPrefix  string
param subnetDbPublicPrefix  string
param subnetDbPrivatePrefix  string
param sqlAdminPwd  string
param location  string
param currenttenant  string
param skuSqlPool string
param deploySynapse bool 
param deploysFTP bool 
param deployAdfLinkedServices bool
param deployStandardWorkloadsAdf bool
param allowedIPs array
param container array
param deployMatillion bool
param matillionIp string
//param admingroup string



// Deployments nach Modulen
// NETWORK
module network 'Modules/Network/reference_network.bicep' = {
  name: 'Network'
  params: {
    location: location
    vnetAddressPrefix: vnetAddressPrefix
    subnetDatastoragePrefix: subnetDatastoragePrefix
    subnetComputePrefix: subnetComputePrefix
    subnetDWHPrefix: subnetDWHPrefix
    subnetDbPublicPrefix: subnetDbPublicPrefix
    subnetDbPrivatePrefix : subnetDbPrivatePrefix
    subnetSupportPrefix: subnetSupportPrefix
  }
}

// STORAGE
module datalake 'Modules/Storage/reference_datalake.bicep' = {
  name: 'Datalake'
  dependsOn: [
    network
  ]
  params: {
    location: location
    currenttenant: currenttenant
    subnetIdDataStorage: network.outputs.subnetIdDataStorage
    allowedIPs: allowedIPs
    container: container
  }
}

// SUPPORT: KEYVAULT, DATABRICKS
module support 'Modules/SupportServices/reference_support.bicep' = {
  name: 'Support'
  dependsOn: [
    network
    datalake
  ]
  params: {
    location: location
    currenttenant: currenttenant
    pricingTier: pricingTier
    vNetId: network.outputs.vNetId
    subnetIdSupport: network.outputs.subnetIdSupport
  }
}

// DATAFACTORY
module adf 'Modules/DataFactory/reference_adf.bicep' = {
  name: 'ADF'
  dependsOn: [
    network
    datalake
    support
  ]
  params: {
    location: location
    storageName: datalake.outputs.storageName
    storageId: datalake.outputs.storageId
    storageApiVersion: datalake.outputs.storageApiVersion
    databricksName: support.outputs.databricksName
    databricksWorkspaceId: support.outputs.databricksWorkspaceId
    databricksWorkspaceUrl: support.outputs.databricksWorkspaceUrl
    clusterNodeType: clusterNodeType
    clusterVersion: clusterVersion
    keyVaultName: support.outputs.keyvaultname
    keyVaultBaseUrl: support.outputs.keyvaultbaseurl
    keyVaultId: support.outputs.keyVaultId
    deployAdfLinkedServices: deployAdfLinkedServices
    deployStandardWorkloadsAdf: deployStandardWorkloadsAdf
  }
}


// sFTP aufsetzen
module ftp 'Modules/SupportServices/reference_sftp.bicep' = if(deploysFTP == true) {
  name: 'sFTP'
  dependsOn: [
    network
    datalake
  ]
  params: {
    location: location
  }
}



// DWH SYNAPSE
module synapse 'Modules/DWH/Synapse/reference_synapse.bicep' = if(deploySynapse == true) {
  name: 'Synapse'
  dependsOn: [
    datalake
  ]
  params: {
    location: location
    storageName: datalake.outputs.storageName
    accountUrl: datalake.outputs.accountUrl
    sqlAdminPwd: sqlAdminPwd
    skuSqlPool: skuSqlPool
    allowedIPs: allowedIPs
  }
}


// DWH MATILLION
module matillion 'Modules/DWH/Matillion/reference_matillion.bicep' = if(deployMatillion == true) {
  name: 'Matillion'
  dependsOn: [
    synapse
  ]
  params: {
    location: location
    matillionIp: matillionIp
    vNetId: network.outputs.vNetId
    nsgId: network.outputs.nsgId
  }
}


// Output mit den Resourcenames für den User
output nsgname string = network.outputs.nsgname
output vnetname string = network.outputs.vNetName
output lakename string = datalake.outputs.storageName
output adfname string = adf.outputs.adfname
output keyvaultname string = support.outputs.keyvaultname
output databricksname string = support.outputs.databricksName

output synapseName string = synapse.outputs.synapseName
output synapseSqlAdminPwd string = synapse.outputs.adminpwd
