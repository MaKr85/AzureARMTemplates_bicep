param location string
param adfName string
param lakeStorageLS string



resource source_csvCleansing_directories 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  name: '${adfName}/source_csvCleansing_directories'
  properties: {
    linkedServiceName: {
      referenceName: lakeStorageLS
      type: 'LinkedServiceReference'
    }
    folder: {
      name: 'CSV Cleansing'
    }
    annotations: []
    type: 'Binary'
    typeProperties: {
      location: {
        type: 'AzureBlobFSLocation'
        fileSystem: '01-raw'
      }
    }
  }
}

resource DoCSVCleansing 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = {
  name: '${adfName}/DoCSVCleansing'
  properties: {
    activities: [
      {
        name: 'CSVCleaning'
        type: 'DatabricksNotebook'
        dependsOn: []
        userProperties: []
        typeProperties: {
          notebookPath: '/Shared/CSVCleanser'
          baseParameters: {
            source: {
              value: '@pipeline().parameters.source'
              type: 'Expression'
            }
          }
          libraries: [
            {
              pypi: {
                package: 'datatable==0.11.1'
              }
            }
            {
              pypi: {
                package: 'azure-storage-file-datalake'
              }
            }
          ]
        }
      }
    ]
    parameters: {
      source: {
        type: 'String'
        defaultValue: 'external-sql'
      }
    }
    folder: {
      name: '02-cleansed'
    }
    annotations: []
  }
}


resource Iterate_CSV_Cleansing 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = {
  name: '${adfName}/Iterate CSV Cleansing'
  properties: {
    activities: [
      {
        name: 'Get Directories'
        type: 'GetMetadata'
        dependsOn: []
        userProperties: []
        typeProperties: {
          dataset: {
            referenceName: 'source_csvCleansing_directories'
            type: 'DatasetReference'
            parameters: {}
          }
          fieldList: [
            'childItems'
          ]
          storeSettings: {
            type: 'AzureBlobFSReadSettings'
            recursive: true
            enablePartitionDiscovery: false
          }
          formatSettings: {
            type: 'BinaryReadSettings'
          }
        }
      }
      {
        name: 'DoCleansing ForEach Directory'
        type: 'ForEach'
        dependsOn: [
          {
            activity: 'Get Directories'
            dependencyConditions: [
              'Succeeded'
            ]
          }
        ]
        userProperties: []
        typeProperties: {
          items: {
            value: '@activity(\'Get Directories\').output.childItems'
            type: 'Expression'
          }
          isSequential: false
          activities: [
            {
              name: 'Execute DoCSVCleansing'
              type: 'ExecutePipeline'
              dependsOn: []
              userProperties: []
              typeProperties: {
                pipeline: {
                  referenceName: 'DoCSVCleansing'
                  type: 'PipelineReference'
                }
                waitOnCompletion: true
                parameters: {
                  source: {
                    value: '@item().name'
                    type: 'Expression'
                  }
                }
              }
            }
          ]
        }
      }
    ]
    folder: {
      name: '02-cleansed'
    }
    annotations: []
  }
  dependsOn: [
    source_csvCleansing_directories
    DoCSVCleansing
  ]
}
