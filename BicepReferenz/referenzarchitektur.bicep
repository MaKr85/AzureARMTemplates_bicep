// // ACHTUNG: ToDo
// // Steuerung welche (optionalen) Resourcen zu deployen sind
// param deploySynapse bool = false
// param deploysFTP bool = false
// param deployAdfLinkedServices bool = false 
// param deployStandardWorkloadsAdf bool = false

// Parameter holen
module getParameter 'reference_parameters.bicep' = {
  name: 'Parameter'
}

// Parameter setzen
var pricingTier = getParameter.outputs.pricingTier
var clusterNodeType  = getParameter.outputs.clusterNodeType
var clusterVersion  = getParameter.outputs.clusterVersion
var vnetAddressPrefix  = getParameter.outputs.vnetAddressPrefix
var subnetDatastoragePrefix  = getParameter.outputs.subnetDatastoragePrefix
var subnetComputePrefix  = getParameter.outputs.subnetComputePrefix
var subnetDWHPrefix  = getParameter.outputs.subnetDWHPrefix
var subnetSupportPrefix  = getParameter.outputs.subnetSupportPrefix
var subnetDbPublicPrefix  = getParameter.outputs.subnetDbPublicPrefix
var subnetDbPrivatePrefix  = getParameter.outputs.subnetDbPrivatePrefix
var sqlAdminPwd  = getParameter.outputs.sqlAdminPwd
var location  = getParameter.outputs.location
var currenttenant  = getParameter.outputs.currenttenant
var skuSqlPool  = getParameter.outputs.skuSqlPool
var allowedIPs = getParameter.outputs.allowedIPs
var container = getParameter.outputs.container
var matillionIp = getParameter.outputs.matillionIp
//var admingroup  = getParameter.outputs.admingroup

var deploySynapse = getParameter.outputs.deploySynapse
var deploysFTP = getParameter.outputs.deploysFTP
var deployAdfLinkedServices = getParameter.outputs.deployAdfLinkedServices
var deployStandardWorkloadsAdf = getParameter.outputs.deployStandardWorkloadsAdf
var deployMatillion = getParameter.outputs.deployMatillion


// Deplyo,ent aufrufen
module doModuleDeploy 'reference_moduledeployment.bicep' = {
  name: 'ModuleDeplyoment'
  params: {
    pricingTier: pricingTier
    clusterNodeType: clusterNodeType
    clusterVersion: clusterVersion
    vnetAddressPrefix: vnetAddressPrefix
    subnetDatastoragePrefix: subnetDatastoragePrefix
    subnetComputePrefix: subnetComputePrefix
    subnetDWHPrefix: subnetDWHPrefix
    subnetSupportPrefix: subnetSupportPrefix
    subnetDbPublicPrefix: subnetDbPublicPrefix
    subnetDbPrivatePrefix: subnetDbPrivatePrefix
    sqlAdminPwd: sqlAdminPwd
    location: location
    currenttenant: currenttenant
    skuSqlPool: skuSqlPool
    deploySynapse: deploySynapse
    deploysFTP: deploysFTP
    deployAdfLinkedServices: deployAdfLinkedServices
    deployStandardWorkloadsAdf: deployStandardWorkloadsAdf
    allowedIPs: allowedIPs
    container: container
    deployMatillion: deployMatillion
    matillionIp: matillionIp
  }
}
