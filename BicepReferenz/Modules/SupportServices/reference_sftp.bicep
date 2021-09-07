param location string

var sftpContainerGroupName = 'sftpcontainergroup'
var sftpContainerName = 'sftpcontainer'
var containerGroupDNSLabel = uniqueString(resourceGroup().id, deployment().name)
var sftpUser = 'sftp-Admin'
var sftpPassword = 'sftp-Pwd'
var sftpContainerImage = 'atmoz/sftp:debian'
var sftpEnvVariable = '${sftpUser}:${sftpPassword}:1001'

var storageNamesFTP = 'sftpstorage${uniqueString(resourceGroup().id)}'


resource sFtpStorage 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageNamesFTP
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
  }
} 

// FileShare für sFTP einrichten
resource fsFTP 'Microsoft.Storage/storageAccounts/fileServices/shares@2021-04-01' = {
  name: '${storageNamesFTP}/default/sftp'
  dependsOn: [
    sFtpStorage
  ]
}

// Container für sFTP einrichten
resource containergroup 'Microsoft.ContainerInstance/containerGroups@2019-12-01' = {
  name: sftpContainerGroupName
  location: location
  properties: {
    containers: [
      {
        name: sftpContainerName
        properties: {
          image: sftpContainerImage
          environmentVariables: [
            {
              name: 'SFTP_USERS'
              secureValue: sftpEnvVariable
            }
          ]
          resources: {
            requests: {
              cpu: 1
              memoryInGB: 1
            }
          }
          ports:[
            {
              port: 22
              protocol: 'TCP'
            }
          ]
          volumeMounts: [
            {
              mountPath: '/home/${sftpUser}/upload'
              name: 'sftpvolume'
              readOnly: false
            }
          ]
        }
      }
    ]

    osType:'Linux'
    ipAddress: {
      type: 'Public'
      ports:[
        {
          port: 22
          protocol:'TCP'
        }
      ]
      dnsNameLabel: containerGroupDNSLabel
    }
    restartPolicy: 'OnFailure'
    volumes: [
      {
        name: 'sftpvolume'
        azureFile:{
          readOnly: false
          shareName: 'sftp'
          storageAccountName: storageNamesFTP
          storageAccountKey: listKeys(sFtpStorage.id, '2019-06-01').keys[0].value
        }
      }
    ]
  }
  dependsOn: [
    fsFTP 
  ]
}



output containerDNSLabel string = '${containergroup.properties.ipAddress.dnsNameLabel}.${containergroup.location}.azurecontainer.io'
