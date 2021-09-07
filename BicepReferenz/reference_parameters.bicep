// ACHTUNG: ToDo
// Steuerung welche (optionalen) Resourcen zu deployen sind
param deploySynapse bool = true
param deploysFTP bool = true
param deployAdfLinkedServices bool = true 
param deployStandardWorkloadsAdf bool = true
param deployMatillion bool = true


// welche IPs haben Zugriff auf die Resourcen?
param allowedIPs array = [
  '84.128.153.105'
  '62.96.137.98'
]

// zu erstellende Container im DataLake
param container array = [
  '01-raw'
  '02-cleansed'
  '02a-processed'
  '03a-application-out'
  '03b-sandbox'
  '98-temporary'
  '99-metadata'
]

// Setzen der globalen Parameter
// MANUELL ZU DEFINIEREN
param admingroup string = '329cb32e-a6c5-412a-8c53-63dfd57d463e'

// Pricing Tier Databricks
@description('Select the pricing Tier of the Databricks Workspace.')
@allowed([
  'standard'
  'premium'
])
param pricingTier string = 'standard'

// VM & Version für Databricks
param clusterNodeType string = 'Standard_DS3_v2'
param clusterVersion string = '7.3.x-scala2.12'

// Vnet & Subnet Konfiguration
param vnetAddressPrefix string = '10.0.0.0/16'
param subnetDatastoragePrefix string = '10.0.0.0/24'
param subnetComputePrefix string = '10.0.1.0/24'
param subnetDWHPrefix string = '10.0.2.0/24'
param subnetSupportPrefix string = '10.0.3.0/24'
param subnetDbPublicPrefix string = '10.0.4.0/24'
param subnetDbPrivatePrefix string = '10.0.5.0/24'

// MatillionIp (muss innerhalb des DWH Subnet liegen)
param matillionIp string = '10.0.2.4'

param sqlAdminPwd string = 'bx6427%fQ!V@nMm9TFw%9G'

@description('Select the SKU of the SQL pool.')
@allowed([
  'DW100c'
  'DW200c'
  'DW300c'
  'DW400c'
  'DW500c'
  'DW1000c'
  'DW1500c'
  'DW2000c'
  'DW2500c'
  'DW3000c'
])
param skuSqlPool string = 'DW100c'


// AUTOMATISCH DEFINIERT
param location string = resourceGroup().location
param currenttenant string = subscription().tenantId


//Outputs setzen
output location string = location
output currenttenant string = currenttenant
output pricingTier string = pricingTier
output clusterNodeType string = clusterNodeType
output clusterVersion string = clusterVersion
output vnetAddressPrefix string = vnetAddressPrefix
output subnetDatastoragePrefix string = subnetDatastoragePrefix
output subnetComputePrefix string = subnetComputePrefix
output subnetDWHPrefix string = subnetDWHPrefix
output subnetSupportPrefix string = subnetSupportPrefix
output subnetDbPublicPrefix string = subnetDbPublicPrefix
output subnetDbPrivatePrefix string = subnetDbPrivatePrefix
output sqlAdminPwd string = sqlAdminPwd
output skuSqlPool string = skuSqlPool
output admingroup string = admingroup
output deploySynapse bool = deploySynapse
output deploysFTP bool = deploysFTP
output deployAdfLinkedServices bool = deployAdfLinkedServices 
output deployStandardWorkloadsAdf bool = deployStandardWorkloadsAdf
output deployMatillion bool = deployMatillion
output matillionIp string = matillionIp
output allowedIPs array = allowedIPs
output container array = container
