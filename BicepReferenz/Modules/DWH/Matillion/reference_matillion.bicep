param location string
param matillionIp string
param vNetId string
param nsgId string


var virtualMachineMatillionName = 'matillionvm${uniqueString(resourceGroup().id)}'
var publicIPAddressMatillionName = 'matillionip${uniqueString(resourceGroup().id)}'
var networkInterfaceMatillionName = 'matillionnic${uniqueString(resourceGroup().id)}'

resource publicIPAddressMatillion 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: publicIPAddressMatillionName
  location: location
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    dnsSettings: {
      domainNameLabel: publicIPAddressMatillionName
      fqdn: '${publicIPAddressMatillionName}.${location}.cloudapp.azure.com'
    }
    ipTags: []
  }
}

resource virtualMachineMatillion 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: virtualMachineMatillionName
  location: location
  plan: {
    name: 'matillion-etl-for-synapse'
    product: 'matillion'
    publisher: 'matillion'
  }
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2s'
    }
    storageProfile: {
      imageReference: {
        publisher: 'matillion'
        offer: 'matillion'
        sku: 'matillion-etl-for-synapse'
        version: 'latest'
      }
      osDisk: {
        osType: 'Linux'
        name: '${virtualMachineMatillionName}_OsDisk_1_da757096cd5d469fa3fc16531c145fec'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          id: resourceId('Microsoft.Compute/disks', '${virtualMachineMatillionName}_OsDisk_1_da757096cd5d469fa3fc16531c145fec')
        }
      }
      dataDisks: []
    }
    osProfile: {
      computerName: virtualMachineMatillionName
      adminUsername: 'areto-matillion-admin'
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              path: '/home/areto-matillion-admin/.ssh/authorized_keys'
              keyData: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCtT189BnN0/8CPfY1CoqcSV0IxwaYZfa73iCc/32JhfGq38kQcR9nf+knwL0u1fX6rTpFR4yGJggq1va6zSyI70OjuT4CbYchsOdQ2Phq6YLSgc/ZHJYh5Xyywm5JzJqkFio5CADJM64wMqCG9gHo3h2bi4OFedxh1X/r9WEm7P7Bz1Xs6EsTG9rw0D4rB0WjfffrAue2A7Yd2l7Nl8nirbDHzPX26NyEPlwnKYGBB+20wnq9n8w2OARrQ3cdz99awhVEvt1B2Q3hAqhC+2RkddVnWMDMNkzMODUEzY5YBSgL5eCqi26t9tPvO0gBUGG24gipE7fi1yVsgEbcGtAcZ rsa-key-20210729-matillion-azure'
            }
          ]
        }
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'ImageDefault'
          assessmentMode: 'ImageDefault'
        }
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfacesMatillion.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: false
      }
    }
  }
}

resource networkInterfacesMatillion 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: networkInterfaceMatillionName
  location: 'westeurope'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAddress: matillionIp
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddressMatillion.id
          }
          subnet: {
            id: '${vNetId}/subnets/dwh'
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    networkSecurityGroup: {
      id: nsgId
    }
  }
}


output virtualMachineMatillionName string = virtualMachineMatillionName
output publicIPAddressMatillionName string = publicIPAddressMatillionName
output networkInterfaceMatillionName string = networkInterfaceMatillionName
