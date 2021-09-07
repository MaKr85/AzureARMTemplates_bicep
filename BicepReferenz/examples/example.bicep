param virtualMachines_dp_matillion_ref_name string = 'dp-matillion-ref'
param publicIPAddresses_dp_matillion_ref_ip_name string = 'dp-matillion-ref-ip'
param networkInterfaces_dp_matillion_ref_nic_public_name string = 'dp-matillion-ref-nic-public'
param virtualNetworks_dp_mainvnet_ref_externalid string = '/subscriptions/147eb7a5-1550-417c-aad5-c39c3e264d4d/resourceGroups/Referenz_Core/providers/Microsoft.Network/virtualNetworks/dp-mainvnet-ref'
param networkSecurityGroups_dp_mainnsg_ref_externalid string = '/subscriptions/147eb7a5-1550-417c-aad5-c39c3e264d4d/resourceGroups/Referenz_Core/providers/Microsoft.Network/networkSecurityGroups/dp-mainnsg-ref'

resource publicIPAddresses_dp_matillion_ref_ip_name_resource 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: publicIPAddresses_dp_matillion_ref_ip_name
  location: 'westeurope'
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
  properties: {
    ipAddress: '13.95.4.32'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    dnsSettings: {
      domainNameLabel: 'dp-matillion-areto-ref'
      fqdn: 'dp-matillion-areto-ref.westeurope.cloudapp.azure.com'
    }
    ipTags: []
  }
}

resource virtualMachines_dp_matillion_ref_name_resource 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: virtualMachines_dp_matillion_ref_name
  location: 'westeurope'
  tags: {
    'app-owner': 'florian.grell@areto.de'
    'env-type': 'ref'
    Owner: 'florian.grell@areto.de'
    Umgebung: 'ref'
  }
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
        name: '${virtualMachines_dp_matillion_ref_name}_OsDisk_1_da757096cd5d469fa3fc16531c145fec'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          id: resourceId('Microsoft.Compute/disks', '${virtualMachines_dp_matillion_ref_name}_OsDisk_1_da757096cd5d469fa3fc16531c145fec')
        }
      }
      dataDisks: []
    }
    osProfile: {
      computerName: virtualMachines_dp_matillion_ref_name
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
          id: networkInterfaces_dp_matillion_ref_nic_public_name_resource.id
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

resource networkInterfaces_dp_matillion_ref_nic_public_name_resource 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: networkInterfaces_dp_matillion_ref_nic_public_name
  location: 'westeurope'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAddress: '10.2.3.4'
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_dp_matillion_ref_ip_name_resource.id
          }
          subnet: {
            id: '${virtualNetworks_dp_mainvnet_ref_externalid}/subnets/dwh'
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
      id: networkSecurityGroups_dp_mainnsg_ref_externalid
    }
  }
}