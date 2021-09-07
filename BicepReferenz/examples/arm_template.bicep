@metadata('Data Factory name')
param factoryName string = 'dp-adfmain-ref'

@metadata('Secure string for \'connectionString\' of \'DWH_Ref\'')
@secure()
param DWH_Ref_connectionString string

@metadata('Secure string for \'connectionString\' of \'FileStorage_external\'')
@secure()
param FileStorage_external_connectionString string

@metadata('Secure string for \'accountKey\' of \'dplakestorageref\'')
@secure()
param dplakestorageref_accountKey string

@metadata('Secure string for \'accountKey\' of \'dpstorageexternalref\'')
@secure()
param dpstorageexternalref_accountKey string

@metadata('Secure string for \'connectionString\' of \'external_SQL_WideWorldImporters\'')
@secure()
param external_SQL_WideWorldImporters_connectionString string
param CurrencyAPI_properties_typeProperties_url string = 'https://www.live-rates.com/rates'
param dp_keyvault_ref_properties_typeProperties_baseUrl string = 'https://dp-keyvault-ref.vault.azure.net/'
param dplakestorageref_properties_typeProperties_url string = 'https://dplakestorageref.dfs.core.windows.net'
param dpstorageexternalref_properties_typeProperties_url string = 'https://dpstorageexternalref.dfs.core.windows.net'
param azureSQLprivateEndpoint_properties_privateLinkResourceId string = '/subscriptions/147eb7a5-1550-417c-aad5-c39c3e264d4d/resourceGroups/Referenz_Core/providers/Microsoft.Sql/servers/dplakesqlserver-ref'
param azureSQLprivateEndpoint_properties_groupId string = 'sqlServer'
param dplakestorageref_ep_properties_privateLinkResourceId string = '/subscriptions/147eb7a5-1550-417c-aad5-c39c3e264d4d/resourceGroups/Referenz_Core/providers/Microsoft.Storage/storageAccounts/dplakestorageref'
param dplakestorageref_ep_properties_groupId string = 'dfs'
param dpstorageexternalref_ep_properties_privateLinkResourceId string = '/subscriptions/147eb7a5-1550-417c-aad5-c39c3e264d4d/resourceGroups/Referenz_External/providers/Microsoft.Storage/storageAccounts/dpstorageexternalref'
param dpstorageexternalref_ep_properties_groupId string = 'dfs'

var factoryId = 'Microsoft.DataFactory/factories/${factoryName}'

resource factoryName_01_Load_DWH_from_02_cleansed 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = {
  name: '${factoryName}/01 Load DWH from 02-cleansed'
  properties: {
    activities: [
      {
        name: 'Get directories2Load'
        type: 'Lookup'
        dependsOn: []
        policy: {
          timeout: '7.00:00:00'
          retry: 0
          retryIntervalInSeconds: 30
          secureOutput: false
          secureInput: false
        }
        userProperties: []
        typeProperties: {
          source: {
            type: 'DelimitedTextSource'
            storeSettings: {
              type: 'AzureBlobFSReadSettings'
              recursive: true
              enablePartitionDiscovery: false
            }
            formatSettings: {
              type: 'DelimitedTextReadSettings'
            }
          }
          dataset: {
            referenceName: 'source_directories02_cleansed_for_DWH'
            type: 'DatasetReference'
            parameters: {}
          }
          firstRowOnly: false
        }
      }
      {
        name: 'ForEach Directory'
        type: 'ForEach'
        dependsOn: [
          {
            activity: 'Get directories2Load'
            dependencyConditions: [
              'Succeeded'
            ]
          }
        ]
        userProperties: []
        typeProperties: {
          items: {
            value: '@activity(\'Get directories2Load\').output.value'
            type: 'Expression'
          }
          isSequential: false
          activities: [
            {
              name: 'Execute Load Files in Directory'
              type: 'ExecutePipeline'
              dependsOn: []
              userProperties: []
              typeProperties: {
                pipeline: {
                  referenceName: '02 Load Files from directory 02-cleansed'
                  type: 'PipelineReference'
                }
                waitOnCompletion: true
                parameters: {
                  directory: {
                    value: '@item().directoryname'
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
      name: '03-DWH/Initial Load/02-cleansed'
    }
    annotations: []
    lastPublishTime: '24.08.2021 06:45:58'
  }
  dependsOn: [
    '${factoryId}/datasets/source_directories02_cleansed_for_DWH'
    '${factoryId}/pipelines/02 Load Files from directory 02-cleansed'
  ]
}

resource factoryName_01_Load_DWH_from_02_cleansed_Inc 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = {
  name: '${factoryName}/01 Load DWH from 02-cleansed_Inc'
  properties: {
    activities: [
      {
        name: 'Get directories2Load'
        type: 'Lookup'
        dependsOn: []
        policy: {
          timeout: '7.00:00:00'
          retry: 0
          retryIntervalInSeconds: 30
          secureOutput: false
          secureInput: false
        }
        userProperties: []
        typeProperties: {
          source: {
            type: 'DelimitedTextSource'
            storeSettings: {
              type: 'AzureBlobFSReadSettings'
              recursive: true
              enablePartitionDiscovery: false
            }
            formatSettings: {
              type: 'DelimitedTextReadSettings'
            }
          }
          dataset: {
            referenceName: 'source_directories02_cleansed_for_DWH'
            type: 'DatasetReference'
            parameters: {}
          }
          firstRowOnly: false
        }
      }
      {
        name: 'ForEach Directory'
        type: 'ForEach'
        dependsOn: [
          {
            activity: 'Get directories2Load'
            dependencyConditions: [
              'Succeeded'
            ]
          }
        ]
        userProperties: []
        typeProperties: {
          items: {
            value: '@activity(\'Get directories2Load\').output.value'
            type: 'Expression'
          }
          isSequential: false
          activities: [
            {
              name: 'Execute Load Files in Directory'
              type: 'ExecutePipeline'
              dependsOn: []
              userProperties: []
              typeProperties: {
                pipeline: {
                  referenceName: '02 Load Files from directory 02-cleansed_Inc'
                  type: 'PipelineReference'
                }
                waitOnCompletion: true
                parameters: {
                  directory: {
                    value: '@item().directoryname'
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
      name: '03-DWH/Incremental Load/02-cleansed'
    }
    annotations: []
    lastPublishTime: '24.08.2021 07:20:13'
  }
  dependsOn: [
    '${factoryId}/datasets/source_directories02_cleansed_for_DWH'
    '${factoryId}/pipelines/02 Load Files from directory 02-cleansed_Inc'
  ]
}

resource factoryName_01_Load_DWH_from_02a_processed_Inc 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = {
  name: '${factoryName}/01 Load DWH from 02a-processed Inc'
  properties: {
    activities: [
      {
        name: 'Get directories2Load'
        type: 'Lookup'
        dependsOn: []
        policy: {
          timeout: '7.00:00:00'
          retry: 0
          retryIntervalInSeconds: 30
          secureOutput: false
          secureInput: false
        }
        userProperties: []
        typeProperties: {
          source: {
            type: 'DelimitedTextSource'
            storeSettings: {
              type: 'AzureBlobFSReadSettings'
              recursive: true
              enablePartitionDiscovery: false
            }
            formatSettings: {
              type: 'DelimitedTextReadSettings'
            }
          }
          dataset: {
            referenceName: 'source_directories02a_processed_for_DWH'
            type: 'DatasetReference'
            parameters: {}
          }
          firstRowOnly: false
        }
      }
      {
        name: 'ForEach Directory'
        type: 'ForEach'
        dependsOn: [
          {
            activity: 'Get directories2Load'
            dependencyConditions: [
              'Succeeded'
            ]
          }
        ]
        userProperties: []
        typeProperties: {
          items: {
            value: '@activity(\'Get directories2Load\').output.value'
            type: 'Expression'
          }
          isSequential: false
          activities: [
            {
              name: 'Execute Load Files in Directory'
              type: 'ExecutePipeline'
              dependsOn: []
              userProperties: []
              typeProperties: {
                pipeline: {
                  referenceName: '02 Load Files from directory 02a-processed Inc'
                  type: 'PipelineReference'
                }
                waitOnCompletion: true
                parameters: {
                  directory: {
                    value: '@item().directoryName'
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
      name: '03-DWH/Incremental Load/02a-processed'
    }
    annotations: []
    lastPublishTime: '24.08.2021 06:45:58'
  }
  dependsOn: [
    '${factoryId}/datasets/source_directories02a_processed_for_DWH'
    '${factoryId}/pipelines/02 Load Files from directory 02a-processed Inc'
  ]
}

resource factoryName_01_Load_DWH_from_02a_processed 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = {
  name: '${factoryName}/01 Load DWH from 02a-processed'
  properties: {
    activities: [
      {
        name: 'Get directories2Load'
        type: 'Lookup'
        dependsOn: []
        policy: {
          timeout: '7.00:00:00'
          retry: 0
          retryIntervalInSeconds: 30
          secureOutput: false
          secureInput: false
        }
        userProperties: []
        typeProperties: {
          source: {
            type: 'DelimitedTextSource'
            storeSettings: {
              type: 'AzureBlobFSReadSettings'
              recursive: true
              enablePartitionDiscovery: false
            }
            formatSettings: {
              type: 'DelimitedTextReadSettings'
            }
          }
          dataset: {
            referenceName: 'source_directories02a_processed_for_DWH'
            type: 'DatasetReference'
            parameters: {}
          }
          firstRowOnly: false
        }
      }
      {
        name: 'ForEach Directory'
        type: 'ForEach'
        dependsOn: [
          {
            activity: 'Get directories2Load'
            dependencyConditions: [
              'Succeeded'
            ]
          }
        ]
        userProperties: []
        typeProperties: {
          items: {
            value: '@activity(\'Get directories2Load\').output.value'
            type: 'Expression'
          }
          isSequential: false
          activities: [
            {
              name: 'Execute Load Files in Directory'
              type: 'ExecutePipeline'
              dependsOn: []
              userProperties: []
              typeProperties: {
                pipeline: {
                  referenceName: '02 Load Files from directory 02a-processed'
                  type: 'PipelineReference'
                }
                waitOnCompletion: true
                parameters: {
                  directory: {
                    value: '@item().directoryName'
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
      name: '03-DWH/Initial Load/02a-processed'
    }
    annotations: []
    lastPublishTime: '24.08.2021 06:45:58'
  }
  dependsOn: [
    '${factoryId}/datasets/source_directories02a_processed_for_DWH'
    '${factoryId}/pipelines/02 Load Files from directory 02a-processed'
  ]
}

resource factoryName_02_Load_Files_from_directory_02_cleansed 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = {
  name: '${factoryName}/02 Load Files from directory 02-cleansed'
  properties: {
    activities: [
      {
        name: 'Get Files in 02-cleansed'
        type: 'GetMetadata'
        dependsOn: []
        policy: {
          timeout: '7.00:00:00'
          retry: 0
          retryIntervalInSeconds: 30
          secureOutput: false
          secureInput: false
        }
        userProperties: []
        typeProperties: {
          dataset: {
            referenceName: 'source_getFiles02_cleansed'
            type: 'DatasetReference'
            parameters: {
              directory: {
                value: '@pipeline().parameters.directory'
                type: 'Expression'
              }
            }
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
        name: 'ForEach File'
        type: 'ForEach'
        dependsOn: [
          {
            activity: 'Get Files in 02-cleansed'
            dependencyConditions: [
              'Succeeded'
            ]
          }
        ]
        userProperties: []
        typeProperties: {
          items: {
            value: '@activity(\'Get Files in 02-cleansed\').output.childItems'
            type: 'Expression'
          }
          activities: [
            {
              name: 'Copy2DWH_STAGE'
              type: 'Copy'
              dependsOn: [
                {
                  activity: 'CREATE TABLE'
                  dependencyConditions: [
                    'Succeeded'
                  ]
                }
              ]
              policy: {
                timeout: '7.00:00:00'
                retry: 0
                retryIntervalInSeconds: 30
                secureOutput: false
                secureInput: false
              }
              userProperties: []
              typeProperties: {
                source: {
                  type: 'DelimitedTextSource'
                  storeSettings: {
                    type: 'AzureBlobFSReadSettings'
                    recursive: true
                    enablePartitionDiscovery: false
                  }
                  formatSettings: {
                    type: 'DelimitedTextReadSettings'
                  }
                }
                sink: {
                  type: 'AzureSqlSink'
                  disableMetricsCollection: false
                }
                enableStaging: false
                translator: {
                  type: 'TabularTranslator'
                  typeConversion: true
                  typeConversionSettings: {
                    allowDataTruncation: true
                    treatBooleanAsNumber: false
                  }
                }
              }
              inputs: [
                {
                  referenceName: 'source_02cleansed'
                  type: 'DatasetReference'
                  parameters: {
                    directory: {
                      value: '@pipeline().parameters.directory'
                      type: 'Expression'
                    }
                    fileName: {
                      value: '@item().name'
                      type: 'Expression'
                    }
                  }
                }
              ]
              outputs: [
                {
                  referenceName: 'sink_DWH_Stage'
                  type: 'DatasetReference'
                  parameters: {
                    TableName: {
                      value: '@replace(item().name,\'_cleansed.csv\',\'\')'
                      type: 'Expression'
                    }
                  }
                }
              ]
            }
            {
              name: 'Get PreSQLScript'
              type: 'Lookup'
              dependsOn: []
              policy: {
                timeout: '7.00:00:00'
                retry: 0
                retryIntervalInSeconds: 30
                secureOutput: false
                secureInput: false
              }
              userProperties: []
              typeProperties: {
                source: {
                  type: 'DelimitedTextSource'
                  storeSettings: {
                    type: 'AzureBlobFSReadSettings'
                    recursive: true
                    enablePartitionDiscovery: false
                  }
                  formatSettings: {
                    type: 'DelimitedTextReadSettings'
                  }
                }
                dataset: {
                  referenceName: 'source_PreSQLScript'
                  type: 'DatasetReference'
                  parameters: {
                    directory: {
                      value: '@pipeline().parameters.directory'
                      type: 'Expression'
                    }
                    FileName: {
                      value: '@replace(item().name,\'_cleansed.csv\',\'_SQL.txt\')'
                      type: 'Expression'
                    }
                  }
                }
                firstRowOnly: false
              }
            }
            {
              name: 'CREATE TABLE'
              type: 'SqlServerStoredProcedure'
              dependsOn: [
                {
                  activity: 'Get PreSQLScript'
                  dependencyConditions: [
                    'Succeeded'
                  ]
                }
              ]
              policy: {
                timeout: '7.00:00:00'
                retry: 0
                retryIntervalInSeconds: 30
                secureOutput: false
                secureInput: false
              }
              userProperties: []
              typeProperties: {
                storedProcedureName: '[stage].[spExecuteSQLCmd]'
                storedProcedureParameters: {
                  SqlJSON: {
                    value: {
                      value: '@{activity(\'Get PreSQLScript\').output.value}'
                      type: 'Expression'
                    }
                    type: 'String'
                  }
                }
              }
              linkedServiceName: {
                referenceName: 'DWH_Ref'
                type: 'LinkedServiceReference'
              }
            }
          ]
        }
      }
    ]
    parameters: {
      directory: {
        type: 'String'
      }
    }
    folder: {
      name: '03-DWH/Initial Load/02-cleansed'
    }
    annotations: []
    lastPublishTime: '24.08.2021 07:20:12'
  }
  dependsOn: [
    '${factoryId}/datasets/source_getFiles02_cleansed'
    '${factoryId}/datasets/source_02cleansed'
    '${factoryId}/datasets/sink_DWH_Stage'
    '${factoryId}/datasets/source_PreSQLScript'
    '${factoryId}/linkedServices/DWH_Ref'
  ]
}

resource factoryName_02_Load_Files_from_directory_02_cleansed_Inc 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = {
  name: '${factoryName}/02 Load Files from directory 02-cleansed_Inc'
  properties: {
    activities: [
      {
        name: 'Get Files in 02-cleansed'
        type: 'GetMetadata'
        dependsOn: []
        policy: {
          timeout: '7.00:00:00'
          retry: 0
          retryIntervalInSeconds: 30
          secureOutput: false
          secureInput: false
        }
        userProperties: []
        typeProperties: {
          dataset: {
            referenceName: 'source_getFiles02_cleansed'
            type: 'DatasetReference'
            parameters: {
              directory: {
                value: '@pipeline().parameters.directory'
                type: 'Expression'
              }
            }
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
        name: 'ForEach File'
        type: 'ForEach'
        dependsOn: [
          {
            activity: 'Get Files in 02-cleansed'
            dependencyConditions: [
              'Succeeded'
            ]
          }
        ]
        userProperties: []
        typeProperties: {
          items: {
            value: '@activity(\'Get Files in 02-cleansed\').output.childItems'
            type: 'Expression'
          }
          activities: [
            {
              name: 'Check if Table exists'
              type: 'Lookup'
              dependsOn: []
              policy: {
                timeout: '7.00:00:00'
                retry: 0
                retryIntervalInSeconds: 30
                secureOutput: false
                secureInput: false
              }
              userProperties: []
              typeProperties: {
                source: {
                  type: 'AzureSqlSource'
                  sqlReaderStoredProcedureName: '[stage].[spCheckTableExistence]'
                  storedProcedureParameters: {
                    SchemaName: {
                      type: 'String'
                      value: 'stage'
                    }
                    TableName: {
                      type: 'String'
                      value: {
                        value: '@replace(item().name,\'_cleansed.csv\',\'\')'
                        type: 'Expression'
                      }
                    }
                  }
                  queryTimeout: '02:00:00'
                  partitionOption: 'None'
                }
                dataset: {
                  referenceName: 'spTableExists'
                  type: 'DatasetReference'
                  parameters: {}
                }
                firstRowOnly: false
              }
            }
            {
              name: 'If Table Exists'
              type: 'IfCondition'
              dependsOn: [
                {
                  activity: 'Check if Table exists'
                  dependencyConditions: [
                    'Succeeded'
                  ]
                }
              ]
              userProperties: []
              typeProperties: {
                expression: {
                  value: '@activity(\'Check if Table exists\').output.value > 0'
                  type: 'Expression'
                }
                ifFalseActivities: [
                  {
                    name: 'Get PreSQLScript'
                    type: 'Lookup'
                    dependsOn: []
                    policy: {
                      timeout: '7.00:00:00'
                      retry: 0
                      retryIntervalInSeconds: 30
                      secureOutput: false
                      secureInput: false
                    }
                    userProperties: []
                    typeProperties: {
                      source: {
                        type: 'DelimitedTextSource'
                        storeSettings: {
                          type: 'AzureBlobFSReadSettings'
                          recursive: true
                          enablePartitionDiscovery: false
                        }
                        formatSettings: {
                          type: 'DelimitedTextReadSettings'
                        }
                      }
                      dataset: {
                        referenceName: 'source_PreSQLScript'
                        type: 'DatasetReference'
                        parameters: {
                          directory: {
                            value: '@pipeline().parameters.directory'
                            type: 'Expression'
                          }
                          FileName: {
                            value: '@replace(item().name,\'_cleansed.csv\',\'_SQL.txt\')'
                            type: 'Expression'
                          }
                        }
                      }
                      firstRowOnly: false
                    }
                  }
                  {
                    name: 'CREATE TABLE'
                    type: 'SqlServerStoredProcedure'
                    dependsOn: [
                      {
                        activity: 'Get PreSQLScript'
                        dependencyConditions: [
                          'Succeeded'
                        ]
                      }
                    ]
                    policy: {
                      timeout: '7.00:00:00'
                      retry: 0
                      retryIntervalInSeconds: 30
                      secureOutput: false
                      secureInput: false
                    }
                    userProperties: []
                    typeProperties: {
                      storedProcedureName: '[stage].[spExecuteSQLCmd]'
                      storedProcedureParameters: {
                        SqlJSON: {
                          value: {
                            value: '@{activity(\'Get PreSQLScript\').output.value}'
                            type: 'Expression'
                          }
                          type: 'String'
                        }
                      }
                    }
                    linkedServiceName: {
                      referenceName: 'DWH_Ref'
                      type: 'LinkedServiceReference'
                    }
                  }
                  {
                    name: 'Copy2DWH_STAGE'
                    type: 'Copy'
                    dependsOn: [
                      {
                        activity: 'CREATE TABLE'
                        dependencyConditions: [
                          'Succeeded'
                        ]
                      }
                    ]
                    policy: {
                      timeout: '7.00:00:00'
                      retry: 0
                      retryIntervalInSeconds: 30
                      secureOutput: false
                      secureInput: false
                    }
                    userProperties: []
                    typeProperties: {
                      source: {
                        type: 'DelimitedTextSource'
                        storeSettings: {
                          type: 'AzureBlobFSReadSettings'
                          recursive: true
                          enablePartitionDiscovery: false
                        }
                        formatSettings: {
                          type: 'DelimitedTextReadSettings'
                        }
                      }
                      sink: {
                        type: 'AzureSqlSink'
                        disableMetricsCollection: false
                      }
                      enableStaging: false
                      translator: {
                        type: 'TabularTranslator'
                        typeConversion: true
                        typeConversionSettings: {
                          allowDataTruncation: true
                          treatBooleanAsNumber: false
                        }
                      }
                    }
                    inputs: [
                      {
                        referenceName: 'source_02cleansed'
                        type: 'DatasetReference'
                        parameters: {
                          directory: {
                            value: '@pipeline().parameters.directory'
                            type: 'Expression'
                          }
                          fileName: {
                            value: '@item().name'
                            type: 'Expression'
                          }
                        }
                      }
                    ]
                    outputs: [
                      {
                        referenceName: 'sink_DWH_Stage'
                        type: 'DatasetReference'
                        parameters: {
                          TableName: {
                            value: '@replace(item().name,\'_cleansed.csv\',\'\')'
                            type: 'Expression'
                          }
                        }
                      }
                    ]
                  }
                ]
                ifTrueActivities: [
                  {
                    name: 'Copy to tmp'
                    type: 'Copy'
                    dependsOn: []
                    policy: {
                      timeout: '7.00:00:00'
                      retry: 0
                      retryIntervalInSeconds: 30
                      secureOutput: false
                      secureInput: false
                    }
                    userProperties: []
                    typeProperties: {
                      source: {
                        type: 'DelimitedTextSource'
                        storeSettings: {
                          type: 'AzureBlobFSReadSettings'
                          recursive: true
                          enablePartitionDiscovery: false
                        }
                        formatSettings: {
                          type: 'DelimitedTextReadSettings'
                        }
                      }
                      sink: {
                        type: 'AzureSqlSink'
                        tableOption: 'autoCreate'
                        disableMetricsCollection: false
                      }
                      enableStaging: false
                      translator: {
                        type: 'TabularTranslator'
                        typeConversion: true
                        typeConversionSettings: {
                          allowDataTruncation: true
                          treatBooleanAsNumber: false
                        }
                      }
                    }
                    inputs: [
                      {
                        referenceName: 'source_02cleansed'
                        type: 'DatasetReference'
                        parameters: {
                          directory: {
                            value: '@pipeline().parameters.directory'
                            type: 'Expression'
                          }
                          fileName: {
                            value: '@item().name'
                            type: 'Expression'
                          }
                        }
                      }
                    ]
                    outputs: [
                      {
                        referenceName: 'sink_DWH_tmp'
                        type: 'DatasetReference'
                        parameters: {
                          TableName: {
                            value: '@replace(item().name,\'_cleansed.csv\',\'\')'
                            type: 'Expression'
                          }
                        }
                      }
                    ]
                  }
                  {
                    name: 'MERGE DATA'
                    type: 'SqlServerStoredProcedure'
                    dependsOn: [
                      {
                        activity: 'Copy to tmp'
                        dependencyConditions: [
                          'Succeeded'
                        ]
                      }
                    ]
                    policy: {
                      timeout: '7.00:00:00'
                      retry: 0
                      retryIntervalInSeconds: 30
                      secureOutput: false
                      secureInput: false
                    }
                    userProperties: []
                    typeProperties: {
                      storedProcedureName: '[stage].[spMergeData]'
                      storedProcedureParameters: {
                        Debug: {
                          value: null
                          type: 'String'
                        }
                        SrcDatabase: {
                          value: 'DWH'
                          type: 'String'
                        }
                        SrcSchema: {
                          value: 'tmp'
                          type: 'String'
                        }
                        SrcTable: {
                          value: {
                            value: '@replace(item().name,\'_cleansed.csv\',\'\')'
                            type: 'Expression'
                          }
                          type: 'String'
                        }
                        TgtDatabase: {
                          value: 'DWH'
                          type: 'String'
                        }
                        TgtSchema: {
                          value: 'stage'
                          type: 'String'
                        }
                        TgtTable: {
                          value: {
                            value: '@replace(item().name,\'_cleansed.csv\',\'\')'
                            type: 'Expression'
                          }
                          type: 'String'
                        }
                        WhereClause: {
                          value: null
                          type: 'String'
                        }
                        DropSrcTable: {
                          value: 'Y'
                          type: 'String'
                        }
                      }
                    }
                    linkedServiceName: {
                      referenceName: 'DWH_Ref'
                      type: 'LinkedServiceReference'
                    }
                  }
                ]
              }
            }
          ]
        }
      }
    ]
    parameters: {
      directory: {
        type: 'String'
      }
    }
    variables: {
      TableExists: {
        type: 'Boolean'
        defaultValue: true
      }
    }
    folder: {
      name: '03-DWH/Incremental Load/02-cleansed'
    }
    annotations: []
    lastPublishTime: '24.08.2021 07:20:13'
  }
  dependsOn: [
    '${factoryId}/datasets/source_getFiles02_cleansed'
    '${factoryId}/datasets/spTableExists'
    '${factoryId}/datasets/source_PreSQLScript'
    '${factoryId}/linkedServices/DWH_Ref'
    '${factoryId}/datasets/source_02cleansed'
    '${factoryId}/datasets/sink_DWH_Stage'
    '${factoryId}/datasets/sink_DWH_tmp'
  ]
}

resource factoryName_02_Load_Files_from_directory_02a_processed_Inc 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = {
  name: '${factoryName}/02 Load Files from directory 02a-processed Inc'
  properties: {
    activities: [
      {
        name: 'Get Files in 02-processed'
        type: 'GetMetadata'
        dependsOn: []
        policy: {
          timeout: '7.00:00:00'
          retry: 0
          retryIntervalInSeconds: 30
          secureOutput: false
          secureInput: false
        }
        userProperties: []
        typeProperties: {
          dataset: {
            referenceName: 'source_getFiles02a_processed'
            type: 'DatasetReference'
            parameters: {
              directory: {
                value: '@pipeline().parameters.directory'
                type: 'Expression'
              }
            }
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
        name: 'ForEach File'
        type: 'ForEach'
        dependsOn: [
          {
            activity: 'Get Files in 02-processed'
            dependencyConditions: [
              'Succeeded'
            ]
          }
        ]
        userProperties: []
        typeProperties: {
          items: {
            value: '@activity(\'Get Files in 02-processed\').output.childItems'
            type: 'Expression'
          }
          activities: [
            {
              name: 'Switch'
              type: 'Switch'
              dependsOn: []
              userProperties: []
              typeProperties: {
                on: {
                  value: '@replace(item().name,\'.csv\',\'\')'
                  type: 'Expression'
                }
                cases: [
                  {
                    value: 'MergedStockdata'
                    activities: [
                      {
                        name: 'Copy Stockdata'
                        type: 'Copy'
                        dependsOn: []
                        policy: {
                          timeout: '7.00:00:00'
                          retry: 0
                          retryIntervalInSeconds: 30
                          secureOutput: false
                          secureInput: false
                        }
                        userProperties: []
                        typeProperties: {
                          source: {
                            type: 'DelimitedTextSource'
                            additionalColumns: [
                              {
                                name: 'InsertDate'
                                value: {
                                  value: '@utcnow()'
                                  type: 'Expression'
                                }
                              }
                            ]
                            storeSettings: {
                              type: 'AzureBlobFSReadSettings'
                              recursive: true
                              enablePartitionDiscovery: false
                            }
                            formatSettings: {
                              type: 'DelimitedTextReadSettings'
                            }
                          }
                          sink: {
                            type: 'AzureSqlSink'
                            tableOption: 'autoCreate'
                            disableMetricsCollection: false
                          }
                          enableStaging: false
                          translator: {
                            type: 'TabularTranslator'
                            typeConversion: true
                            typeConversionSettings: {
                              allowDataTruncation: true
                              treatBooleanAsNumber: false
                            }
                          }
                        }
                        inputs: [
                          {
                            referenceName: 'sink_MergedStockdata'
                            type: 'DatasetReference'
                            parameters: {}
                          }
                        ]
                        outputs: [
                          {
                            referenceName: 'sink_DWH_Stage'
                            type: 'DatasetReference'
                            parameters: {
                              TableName: 'stockdata'
                            }
                          }
                        ]
                      }
                    ]
                  }
                ]
              }
            }
          ]
        }
      }
    ]
    parameters: {
      directory: {
        type: 'String'
      }
    }
    folder: {
      name: '03-DWH/Incremental Load/02a-processed'
    }
    annotations: []
    lastPublishTime: '24.08.2021 06:45:57'
  }
  dependsOn: [
    '${factoryId}/datasets/source_getFiles02a_processed'
    '${factoryId}/datasets/sink_MergedStockdata'
    '${factoryId}/datasets/sink_DWH_Stage'
  ]
}

resource factoryName_02_Load_Files_from_directory_02a_processed 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = {
  name: '${factoryName}/02 Load Files from directory 02a-processed'
  properties: {
    activities: [
      {
        name: 'Get Files in 02-processed'
        type: 'GetMetadata'
        dependsOn: []
        policy: {
          timeout: '7.00:00:00'
          retry: 0
          retryIntervalInSeconds: 30
          secureOutput: false
          secureInput: false
        }
        userProperties: []
        typeProperties: {
          dataset: {
            referenceName: 'source_getFiles02a_processed'
            type: 'DatasetReference'
            parameters: {
              directory: {
                value: '@pipeline().parameters.directory'
                type: 'Expression'
              }
            }
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
        name: 'ForEach File'
        type: 'ForEach'
        dependsOn: [
          {
            activity: 'Get Files in 02-processed'
            dependencyConditions: [
              'Succeeded'
            ]
          }
        ]
        userProperties: []
        typeProperties: {
          items: {
            value: '@activity(\'Get Files in 02-processed\').output.childItems'
            type: 'Expression'
          }
          activities: [
            {
              name: 'Switch'
              type: 'Switch'
              dependsOn: []
              userProperties: []
              typeProperties: {
                on: {
                  value: '@replace(item().name,\'.csv\',\'\')'
                  type: 'Expression'
                }
                cases: [
                  {
                    value: 'MergedStockdata'
                    activities: [
                      {
                        name: 'Copy Stockdata'
                        type: 'Copy'
                        dependsOn: []
                        policy: {
                          timeout: '7.00:00:00'
                          retry: 0
                          retryIntervalInSeconds: 30
                          secureOutput: false
                          secureInput: false
                        }
                        userProperties: []
                        typeProperties: {
                          source: {
                            type: 'DelimitedTextSource'
                            additionalColumns: [
                              {
                                name: 'InsertDate'
                                value: {
                                  value: '@utcnow()'
                                  type: 'Expression'
                                }
                              }
                            ]
                            storeSettings: {
                              type: 'AzureBlobFSReadSettings'
                              recursive: true
                              enablePartitionDiscovery: false
                            }
                            formatSettings: {
                              type: 'DelimitedTextReadSettings'
                            }
                          }
                          sink: {
                            type: 'AzureSqlSink'
                            tableOption: 'autoCreate'
                            disableMetricsCollection: false
                          }
                          enableStaging: false
                          translator: {
                            type: 'TabularTranslator'
                            typeConversion: true
                            typeConversionSettings: {
                              allowDataTruncation: true
                              treatBooleanAsNumber: false
                            }
                          }
                        }
                        inputs: [
                          {
                            referenceName: 'sink_MergedStockdata'
                            type: 'DatasetReference'
                            parameters: {}
                          }
                        ]
                        outputs: [
                          {
                            referenceName: 'sink_DWH_Stage'
                            type: 'DatasetReference'
                            parameters: {
                              TableName: 'stockdata'
                            }
                          }
                        ]
                      }
                    ]
                  }
                ]
              }
            }
          ]
        }
      }
    ]
    parameters: {
      directory: {
        type: 'String'
      }
    }
    folder: {
      name: '03-DWH/Initial Load/02a-processed'
    }
    annotations: []
    lastPublishTime: '24.08.2021 06:45:57'
  }
  dependsOn: [
    '${factoryId}/datasets/source_getFiles02a_processed'
    '${factoryId}/datasets/sink_MergedStockdata'
    '${factoryId}/datasets/sink_DWH_Stage'
  ]
}

resource factoryName_DoCSVCleansing 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = {
  name: '${factoryName}/DoCSVCleansing'
  properties: {
    activities: [
      {
        name: 'CSVCleaning'
        type: 'DatabricksNotebook'
        dependsOn: []
        policy: {
          timeout: '7.00:00:00'
          retry: 0
          retryIntervalInSeconds: 30
          secureOutput: false
          secureInput: false
        }
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
        linkedServiceName: {
          referenceName: 'dp_databricks_ref'
          type: 'LinkedServiceReference'
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
    lastPublishTime: '20.08.2021 06:43:34'
  }
  dependsOn: [
    '${factoryId}/linkedServices/dp_databricks_ref'
  ]
}

resource factoryName_Incremental_Load_DWH 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = {
  name: '${factoryName}/Incremental Load DWH'
  properties: {
    activities: [
      {
        name: 'Execute Load DWH 02-cleansed'
        type: 'ExecutePipeline'
        dependsOn: []
        userProperties: []
        typeProperties: {
          pipeline: {
            referenceName: '01 Load DWH from 02-cleansed_Inc'
            type: 'PipelineReference'
          }
          waitOnCompletion: true
          parameters: {}
        }
      }
      {
        name: 'Execute Load DWH 02a-processed'
        type: 'ExecutePipeline'
        dependsOn: [
          {
            activity: 'Execute Load DWH 02-cleansed'
            dependencyConditions: [
              'Succeeded'
            ]
          }
        ]
        userProperties: []
        typeProperties: {
          pipeline: {
            referenceName: '01 Load DWH from 02a-processed'
            type: 'PipelineReference'
          }
          waitOnCompletion: true
          parameters: {}
        }
      }
    ]
    folder: {
      name: '03-DWH/Incremental Load'
    }
    annotations: []
  }
  dependsOn: [
    '${factoryId}/pipelines/01 Load DWH from 02-cleansed_Inc'
    '${factoryId}/pipelines/01 Load DWH from 02a-processed'
  ]
}

resource factoryName_Initial_Load_DWH 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = {
  name: '${factoryName}/Initial Load DWH'
  properties: {
    activities: [
      {
        name: 'Execute Load 02-cleansed'
        type: 'ExecutePipeline'
        dependsOn: []
        userProperties: []
        typeProperties: {
          pipeline: {
            referenceName: '01 Load DWH from 02-cleansed'
            type: 'PipelineReference'
          }
          waitOnCompletion: true
          parameters: {}
        }
      }
      {
        name: 'Execute Load 02a-processed'
        type: 'ExecutePipeline'
        dependsOn: [
          {
            activity: 'Execute Load 02-cleansed'
            dependencyConditions: [
              'Succeeded'
            ]
          }
        ]
        userProperties: []
        typeProperties: {
          pipeline: {
            referenceName: '01 Load DWH from 02a-processed'
            type: 'PipelineReference'
          }
          waitOnCompletion: true
          parameters: {}
        }
      }
    ]
    folder: {
      name: '03-DWH/Initial Load'
    }
    annotations: []
    lastPublishTime: '24.08.2021 06:45:59'
  }
  dependsOn: [
    '${factoryId}/pipelines/01 Load DWH from 02-cleansed'
    '${factoryId}/pipelines/01 Load DWH from 02a-processed'
  ]
}

resource factoryName_Iterate_CSV_Cleansing 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = {
  name: '${factoryName}/Iterate CSV Cleansing'
  properties: {
    activities: [
      {
        name: 'Get Directories'
        type: 'GetMetadata'
        dependsOn: []
        policy: {
          timeout: '7.00:00:00'
          retry: 0
          retryIntervalInSeconds: 30
          secureOutput: false
          secureInput: false
        }
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
    lastPublishTime: '20.08.2021 06:43:35'
  }
  dependsOn: [
    '${factoryId}/datasets/source_csvCleansing_directories'
    '${factoryId}/pipelines/DoCSVCleansing'
  ]
}

resource factoryName_Load_exchangerates_API_to_01_raw 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = {
  name: '${factoryName}/Load exchangerates API to 01-raw'
  properties: {
    activities: [
      {
        name: 'Get exchangerates'
        type: 'Copy'
        dependsOn: []
        policy: {
          timeout: '7.00:00:00'
          retry: 0
          retryIntervalInSeconds: 30
          secureOutput: false
          secureInput: false
        }
        userProperties: []
        typeProperties: {
          source: {
            type: 'RestSource'
            additionalColumns: [
              {
                name: 'date'
                value: {
                  value: '@utcnow()'
                  type: 'Expression'
                }
              }
            ]
            httpRequestTimeout: '00:01:40'
            requestInterval: '00.00:00:00.010'
            requestMethod: 'GET'
          }
          sink: {
            type: 'DelimitedTextSink'
            storeSettings: {
              type: 'AzureBlobFSWriteSettings'
            }
            formatSettings: {
              type: 'DelimitedTextWriteSettings'
              quoteAllText: true
              fileExtension: '.csv'
            }
          }
          enableStaging: false
          translator: {
            type: 'TabularTranslator'
            mappings: [
              {
                source: {
                  path: '$[\'currency\']'
                }
                sink: {
                  name: 'currency'
                  type: 'String'
                }
              }
              {
                source: {
                  path: '$[\'rate\']'
                }
                sink: {
                  name: 'rate'
                  type: 'Double'
                }
              }
              {
                source: {
                  path: '$[\'date\']'
                }
                sink: {
                  name: 'date'
                  type: 'DateTime'
                }
              }
            ]
            mapComplexValuesToString: false
          }
        }
        inputs: [
          {
            referenceName: 'source_exchangerates_API'
            type: 'DatasetReference'
            parameters: {}
          }
        ]
        outputs: [
          {
            referenceName: 'sink_exchangerates_01raw'
            type: 'DatasetReference'
            parameters: {}
          }
        ]
      }
    ]
    folder: {
      name: '01-raw'
    }
    annotations: []
    lastPublishTime: '23.08.2021 10:52:54'
  }
  dependsOn: [
    '${factoryId}/datasets/source_exchangerates_API'
    '${factoryId}/datasets/sink_exchangerates_01raw'
  ]
}

resource factoryName_Load_externalSQL_to_01_raw 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = {
  name: '${factoryName}/Load externalSQL to 01-raw'
  properties: {
    activities: [
      {
        name: 'Get external-sql_Tables2Load'
        type: 'Lookup'
        dependsOn: []
        policy: {
          timeout: '7.00:00:00'
          retry: 0
          retryIntervalInSeconds: 30
          secureOutput: false
          secureInput: false
        }
        userProperties: []
        typeProperties: {
          source: {
            type: 'DelimitedTextSource'
            storeSettings: {
              type: 'AzureBlobFSReadSettings'
              recursive: true
              enablePartitionDiscovery: false
            }
            formatSettings: {
              type: 'DelimitedTextReadSettings'
            }
          }
          dataset: {
            referenceName: 'metadata_external_sql_Tables2Load'
            type: 'DatasetReference'
            parameters: {}
          }
          firstRowOnly: false
        }
      }
      {
        name: 'ForEach Table2Load'
        type: 'ForEach'
        dependsOn: [
          {
            activity: 'Get external-sql_Tables2Load'
            dependencyConditions: [
              'Succeeded'
            ]
          }
        ]
        userProperties: []
        typeProperties: {
          items: {
            value: '@activity(\'Get external-sql_Tables2Load\').output.value'
            type: 'Expression'
          }
          activities: [
            {
              name: 'CopyFromSQL2DataLake'
              type: 'Copy'
              dependsOn: []
              policy: {
                timeout: '7.00:00:00'
                retry: 0
                retryIntervalInSeconds: 30
                secureOutput: false
                secureInput: false
              }
              userProperties: []
              typeProperties: {
                source: {
                  type: 'AzureSqlSource'
                  queryTimeout: '02:00:00'
                  partitionOption: 'None'
                }
                sink: {
                  type: 'DelimitedTextSink'
                  storeSettings: {
                    type: 'AzureBlobFSWriteSettings'
                  }
                  formatSettings: {
                    type: 'DelimitedTextWriteSettings'
                    quoteAllText: true
                    fileExtension: '.txt'
                  }
                }
                enableStaging: false
                translator: {
                  type: 'TabularTranslator'
                  typeConversion: true
                  typeConversionSettings: {
                    allowDataTruncation: true
                    treatBooleanAsNumber: false
                  }
                }
              }
              inputs: [
                {
                  referenceName: 'source_SQLTable'
                  type: 'DatasetReference'
                  parameters: {
                    SchemaName: {
                      value: '@item().SchemaName'
                      type: 'Expression'
                    }
                    TableName: {
                      value: '@item().TableName'
                      type: 'Expression'
                    }
                  }
                }
              ]
              outputs: [
                {
                  referenceName: 'sink_01_raw_external_sql'
                  type: 'DatasetReference'
                  parameters: {
                    FileName: {
                      value: '@concat(item().SchemaName,\'_\',item().TableName,\'.csv\')'
                      type: 'Expression'
                    }
                  }
                }
              ]
            }
          ]
        }
      }
    ]
    folder: {
      name: '01-raw'
    }
    annotations: []
    lastPublishTime: '20.08.2021 06:43:35'
  }
  dependsOn: [
    '${factoryId}/datasets/metadata_external_sql_Tables2Load'
    '${factoryId}/datasets/source_SQLTable'
    '${factoryId}/datasets/sink_01_raw_external_sql'
  ]
}

resource factoryName_Load_stockdata_to_01_raw 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = {
  name: '${factoryName}/Load stockdata to 01-raw'
  properties: {
    activities: [
      {
        name: 'Unzip2temporary'
        type: 'Copy'
        dependsOn: []
        policy: {
          timeout: '7.00:00:00'
          retry: 0
          retryIntervalInSeconds: 30
          secureOutput: false
          secureInput: false
        }
        userProperties: []
        typeProperties: {
          source: {
            type: 'BinarySource'
            storeSettings: {
              type: 'AzureFileStorageReadSettings'
              recursive: true
            }
            formatSettings: {
              type: 'BinaryReadSettings'
              compressionProperties: {
                type: 'ZipDeflateReadSettings'
              }
            }
          }
          sink: {
            type: 'BinarySink'
            storeSettings: {
              type: 'AzureBlobFSWriteSettings'
            }
          }
          enableStaging: false
        }
        inputs: [
          {
            referenceName: 'source_stockdataZip'
            type: 'DatasetReference'
            parameters: {}
          }
        ]
        outputs: [
          {
            referenceName: 'sink_tmp_stockdata'
            type: 'DatasetReference'
            parameters: {}
          }
        ]
      }
      {
        name: 'Get all stockdata'
        type: 'GetMetadata'
        dependsOn: [
          {
            activity: 'Unzip2temporary'
            dependencyConditions: [
              'Succeeded'
            ]
          }
        ]
        policy: {
          timeout: '7.00:00:00'
          retry: 0
          retryIntervalInSeconds: 30
          secureOutput: false
          secureInput: false
        }
        userProperties: []
        typeProperties: {
          dataset: {
            referenceName: 'source_stockdata_files'
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
        name: 'ForEach stockdataFile'
        type: 'ForEach'
        dependsOn: [
          {
            activity: 'Get all stockdata'
            dependencyConditions: [
              'Succeeded'
            ]
          }
        ]
        userProperties: []
        typeProperties: {
          items: {
            value: '@activity(\'Get all stockdata\').output.childItems'
            type: 'Expression'
          }
          activities: [
            {
              name: 'Copy from tmp 2 01-raw'
              type: 'Copy'
              dependsOn: []
              policy: {
                timeout: '7.00:00:00'
                retry: 0
                retryIntervalInSeconds: 30
                secureOutput: false
                secureInput: false
              }
              userProperties: []
              typeProperties: {
                source: {
                  type: 'DelimitedTextSource'
                  storeSettings: {
                    type: 'AzureBlobFSReadSettings'
                    recursive: true
                    enablePartitionDiscovery: false
                  }
                  formatSettings: {
                    type: 'DelimitedTextReadSettings'
                  }
                }
                sink: {
                  type: 'DelimitedTextSink'
                  storeSettings: {
                    type: 'AzureBlobFSWriteSettings'
                    copyBehavior: 'MergeFiles'
                  }
                  formatSettings: {
                    type: 'DelimitedTextWriteSettings'
                    quoteAllText: true
                    fileExtension: '.txt'
                  }
                }
                enableStaging: false
                translator: {
                  type: 'TabularTranslator'
                  typeConversion: true
                  typeConversionSettings: {
                    allowDataTruncation: true
                    treatBooleanAsNumber: false
                  }
                }
              }
              inputs: [
                {
                  referenceName: 'source_stockdataFile'
                  type: 'DatasetReference'
                  parameters: {
                    FileName: {
                      value: '@item().name'
                      type: 'Expression'
                    }
                  }
                }
              ]
              outputs: [
                {
                  referenceName: 'sink_stockdata'
                  type: 'DatasetReference'
                  parameters: {
                    FileName: {
                      value: '@replace(item().name,\'.txt\',\'.csv\')'
                      type: 'Expression'
                    }
                  }
                }
              ]
            }
          ]
        }
      }
      {
        name: 'Delete from tmp'
        type: 'Delete'
        dependsOn: [
          {
            activity: 'ForEach stockdataFile'
            dependencyConditions: [
              'Succeeded'
            ]
          }
        ]
        policy: {
          timeout: '7.00:00:00'
          retry: 0
          retryIntervalInSeconds: 30
          secureOutput: false
          secureInput: false
        }
        userProperties: []
        typeProperties: {
          dataset: {
            referenceName: 'source_stockdata_files'
            type: 'DatasetReference'
            parameters: {}
          }
          enableLogging: false
          storeSettings: {
            type: 'AzureBlobFSReadSettings'
            recursive: true
            enablePartitionDiscovery: false
          }
        }
      }
    ]
    folder: {
      name: '01-raw'
    }
    annotations: []
    lastPublishTime: '20.08.2021 06:43:34'
  }
  dependsOn: [
    '${factoryId}/datasets/source_stockdataZip'
    '${factoryId}/datasets/sink_tmp_stockdata'
    '${factoryId}/datasets/source_stockdata_files'
    '${factoryId}/datasets/source_stockdataFile'
    '${factoryId}/datasets/sink_stockdata'
  ]
}

resource factoryName_Master_LoadAll 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = {
  name: '${factoryName}/Master_LoadAll'
  properties: {
    activities: [
      {
        name: 'Execute LoadLake'
        type: 'ExecutePipeline'
        dependsOn: []
        userProperties: []
        typeProperties: {
          pipeline: {
            referenceName: 'Master_LoadLake'
            type: 'PipelineReference'
          }
          waitOnCompletion: true
          parameters: {}
        }
      }
      {
        name: 'If FullLoad'
        type: 'IfCondition'
        dependsOn: [
          {
            activity: 'Execute LoadLake'
            dependencyConditions: [
              'Succeeded'
            ]
          }
        ]
        userProperties: []
        typeProperties: {
          expression: {
            value: '@pipeline().parameters.FullLoad'
            type: 'Expression'
          }
          ifFalseActivities: [
            {
              name: 'Execute Incremental Load'
              type: 'ExecutePipeline'
              dependsOn: []
              userProperties: []
              typeProperties: {
                pipeline: {
                  referenceName: 'Incremental Load DWH'
                  type: 'PipelineReference'
                }
                waitOnCompletion: true
                parameters: {}
              }
            }
          ]
          ifTrueActivities: [
            {
              name: 'Execute Load DWH Full'
              type: 'ExecutePipeline'
              dependsOn: []
              userProperties: []
              typeProperties: {
                pipeline: {
                  referenceName: 'Initial Load DWH'
                  type: 'PipelineReference'
                }
                waitOnCompletion: true
                parameters: {}
              }
            }
          ]
        }
      }
    ]
    parameters: {
      FullLoad: {
        type: 'Bool'
        defaultValue: false
      }
    }
    folder: {
      name: '00-Master'
    }
    annotations: []
    lastPublishTime: '23.08.2021 12:12:25'
  }
  dependsOn: [
    '${factoryId}/pipelines/Master_LoadLake'
    '${factoryId}/pipelines/Incremental Load DWH'
    '${factoryId}/pipelines/Initial Load DWH'
  ]
}

resource factoryName_Master_LoadLake 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = {
  name: '${factoryName}/Master_LoadLake'
  properties: {
    activities: [
      {
        name: 'Execute - Load 02-cleansed'
        type: 'ExecutePipeline'
        dependsOn: [
          {
            activity: 'Execute - Load 01-raw'
            dependencyConditions: [
              'Succeeded'
            ]
          }
        ]
        userProperties: []
        typeProperties: {
          pipeline: {
            referenceName: 'Iterate CSV Cleansing'
            type: 'PipelineReference'
          }
          waitOnCompletion: true
          parameters: {}
        }
      }
      {
        name: 'Execute - Load 02a-processed'
        type: 'ExecutePipeline'
        dependsOn: [
          {
            activity: 'Execute - Load 02-cleansed'
            dependencyConditions: [
              'Succeeded'
            ]
          }
        ]
        userProperties: []
        typeProperties: {
          pipeline: {
            referenceName: 'Master_Load_02a-processed'
            type: 'PipelineReference'
          }
          waitOnCompletion: true
          parameters: {}
        }
      }
      {
        name: 'Execute - Load 01-raw'
        type: 'ExecutePipeline'
        dependsOn: [
          {
            activity: 'PopulateDataToCurrentDate'
            dependencyConditions: [
              'Succeeded'
            ]
          }
        ]
        userProperties: []
        typeProperties: {
          pipeline: {
            referenceName: 'Master_Load_01-raw'
            type: 'PipelineReference'
          }
          waitOnCompletion: true
          parameters: {}
        }
      }
      {
        name: 'PopulateDataToCurrentDate'
        type: 'SqlServerStoredProcedure'
        dependsOn: []
        policy: {
          timeout: '7.00:00:00'
          retry: 0
          retryIntervalInSeconds: 30
          secureOutput: false
          secureInput: false
        }
        userProperties: []
        typeProperties: {
          storedProcedureName: '[DataLoadSimulation].[PopulateDataToCurrentDate]'
          storedProcedureParameters: {
            AreDatesPrinted: {
              value: '0'
              type: 'Int32'
            }
            AverageNumberOfCustomerOrdersPerDay: {
              value: '100'
              type: 'Int32'
            }
            IsSilentMode: {
              value: '1'
              type: 'Int32'
            }
            SaturdayPercentageOfNormalWorkDay: {
              value: '40'
              type: 'Int32'
            }
            SundayPercentageOfNormalWorkDay: {
              value: '20'
              type: 'Int32'
            }
          }
        }
        linkedServiceName: {
          referenceName: 'external_SQL_WideWorldImporters'
          type: 'LinkedServiceReference'
        }
      }
    ]
    folder: {
      name: '00-Master/01-Submaster'
    }
    annotations: []
    lastPublishTime: '23.08.2021 10:30:32'
  }
  dependsOn: [
    '${factoryId}/pipelines/Iterate CSV Cleansing'
    '${factoryId}/pipelines/Master_Load_02a-processed'
    '${factoryId}/pipelines/Master_Load_01-raw'
    '${factoryId}/linkedServices/external_SQL_WideWorldImporters'
  ]
}

resource factoryName_Master_Load_01_raw 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = {
  name: '${factoryName}/Master_Load_01-raw'
  properties: {
    activities: [
      {
        name: 'Execute - Load externalSQL to 01-raw'
        type: 'ExecutePipeline'
        dependsOn: []
        userProperties: []
        typeProperties: {
          pipeline: {
            referenceName: 'Load externalSQL to 01-raw'
            type: 'PipelineReference'
          }
          waitOnCompletion: true
          parameters: {}
        }
      }
      {
        name: 'Execute - Load exchangerates to 01-raw'
        type: 'ExecutePipeline'
        dependsOn: []
        userProperties: []
        typeProperties: {
          pipeline: {
            referenceName: 'Load exchangerates API to 01-raw'
            type: 'PipelineReference'
          }
          waitOnCompletion: true
          parameters: {}
        }
      }
    ]
    folder: {
      name: '00-Master/02-Submaster'
    }
    annotations: []
    lastPublishTime: '23.08.2021 10:52:54'
  }
  dependsOn: [
    '${factoryId}/pipelines/Load externalSQL to 01-raw'
    '${factoryId}/pipelines/Load exchangerates API to 01-raw'
  ]
}

resource factoryName_Master_Load_02_cleansed 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = {
  name: '${factoryName}/Master_Load_02-cleansed'
  properties: {
    activities: [
      {
        name: 'Execute - CSV Cleansing'
        type: 'ExecutePipeline'
        dependsOn: []
        userProperties: []
        typeProperties: {
          pipeline: {
            referenceName: 'Iterate CSV Cleansing'
            type: 'PipelineReference'
          }
          waitOnCompletion: true
          parameters: {}
        }
      }
    ]
    folder: {
      name: '00-Master/02-Submaster'
    }
    annotations: []
    lastPublishTime: '23.08.2021 10:30:31'
  }
  dependsOn: [
    '${factoryId}/pipelines/Iterate CSV Cleansing'
  ]
}

resource factoryName_Master_Load_02a_processed 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = {
  name: '${factoryName}/Master_Load_02a-processed'
  properties: {
    activities: [
      {
        name: 'Execute - Merge stockdata 02a-processed'
        type: 'ExecutePipeline'
        dependsOn: []
        userProperties: []
        typeProperties: {
          pipeline: {
            referenceName: 'Merge stockdata 02a-processed'
            type: 'PipelineReference'
          }
          waitOnCompletion: true
          parameters: {}
        }
      }
    ]
    folder: {
      name: '00-Master/02-Submaster'
    }
    annotations: []
    lastPublishTime: '23.08.2021 10:30:31'
  }
  dependsOn: [
    '${factoryId}/pipelines/Merge stockdata 02a-processed'
  ]
}

resource factoryName_Merge_stockdata_02a_processed 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = {
  name: '${factoryName}/Merge stockdata 02a-processed'
  properties: {
    activities: [
      {
        name: 'Get all stockdata'
        type: 'GetMetadata'
        dependsOn: []
        policy: {
          timeout: '7.00:00:00'
          retry: 0
          retryIntervalInSeconds: 30
          secureOutput: false
          secureInput: false
        }
        userProperties: []
        typeProperties: {
          dataset: {
            referenceName: 'source_stockdataCleansedFiles'
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
        name: 'ForEach stockdataFile'
        type: 'ForEach'
        dependsOn: [
          {
            activity: 'Get all stockdata'
            dependencyConditions: [
              'Succeeded'
            ]
          }
        ]
        userProperties: []
        typeProperties: {
          items: {
            value: '@activity(\'Get all stockdata\').output.childItems'
            type: 'Expression'
          }
          isSequential: true
          activities: [
            {
              name: 'Merge Stockdata'
              type: 'Copy'
              dependsOn: []
              policy: {
                timeout: '7.00:00:00'
                retry: 0
                retryIntervalInSeconds: 30
                secureOutput: false
                secureInput: false
              }
              userProperties: []
              typeProperties: {
                source: {
                  type: 'DelimitedTextSource'
                  additionalColumns: [
                    {
                      name: 'Source'
                      value: {
                        value: '@replace(item().name,\'_cleansed.csv\',\'\')'
                        type: 'Expression'
                      }
                    }
                  ]
                  storeSettings: {
                    type: 'AzureBlobFSReadSettings'
                    recursive: true
                    enablePartitionDiscovery: true
                  }
                  formatSettings: {
                    type: 'DelimitedTextReadSettings'
                  }
                }
                sink: {
                  type: 'DelimitedTextSink'
                  storeSettings: {
                    type: 'AzureBlobFSWriteSettings'
                    copyBehavior: 'MergeFiles'
                  }
                  formatSettings: {
                    type: 'DelimitedTextWriteSettings'
                    quoteAllText: true
                    fileExtension: '.csv'
                  }
                }
                enableStaging: false
                translator: {
                  type: 'TabularTranslator'
                  typeConversion: true
                  typeConversionSettings: {
                    allowDataTruncation: true
                    treatBooleanAsNumber: false
                  }
                }
              }
              inputs: [
                {
                  referenceName: 'source_stockdatacleansed'
                  type: 'DatasetReference'
                  parameters: {
                    FileName: {
                      value: '@item().name'
                      type: 'Expression'
                    }
                  }
                }
              ]
              outputs: [
                {
                  referenceName: 'sink_MergedStockdata'
                  type: 'DatasetReference'
                  parameters: {}
                }
              ]
            }
          ]
        }
      }
    ]
    folder: {
      name: '02a-processed'
    }
    annotations: []
    lastPublishTime: '20.08.2021 07:21:45'
  }
  dependsOn: [
    '${factoryId}/datasets/source_stockdataCleansedFiles'
    '${factoryId}/datasets/source_stockdatacleansed'
    '${factoryId}/datasets/sink_MergedStockdata'
  ]
}

resource factoryName_metadata_external_sql_Tables2Load 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  name: '${factoryName}/metadata_external_sql_Tables2Load'
  properties: {
    linkedServiceName: {
      referenceName: 'dplakestorageref'
      type: 'LinkedServiceReference'
    }
    folder: {
      name: 'external-sql/metadata'
    }
    annotations: []
    type: 'DelimitedText'
    typeProperties: {
      location: {
        type: 'AzureBlobFSLocation'
        fileName: 'external-sql_Tables2Load.csv'
        folderPath: '99-globalcsv'
        fileSystem: '99-metadata'
      }
      columnDelimiter: ','
      escapeChar: '\\'
      firstRowAsHeader: true
      quoteChar: '"'
    }
    schema: [
      {
        name: 'SchemaName'
        type: 'String'
      }
      {
        name: 'TableName'
        type: 'String'
      }
    ]
  }
  dependsOn: [
    '${factoryId}/linkedServices/dplakestorageref'
  ]
}

resource factoryName_sink_01_raw_external_sql 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  name: '${factoryName}/sink_01_raw_external_sql'
  properties: {
    linkedServiceName: {
      referenceName: 'dplakestorageref'
      type: 'LinkedServiceReference'
    }
    parameters: {
      FileName: {
        type: 'String'
      }
    }
    folder: {
      name: 'external-sql/sink'
    }
    annotations: []
    type: 'DelimitedText'
    typeProperties: {
      location: {
        type: 'AzureBlobFSLocation'
        fileName: {
          value: '@dataset().FileName'
          type: 'Expression'
        }
        folderPath: {
          value: '@concat(\'external-sql\',\'/\',formatDateTime(utcnow(),\'yyyy\'),\'/\',formatDateTime(utcnow(),\'MM\'),\'/\',formatDateTime(utcnow(),\'dd\'))'
          type: 'Expression'
        }
        fileSystem: '01-raw'
      }
      columnDelimiter: ','
      escapeChar: '\\'
      firstRowAsHeader: true
      quoteChar: '"'
    }
    schema: [
      {
        name: 'PurchaseOrderLineID'
        type: 'String'
      }
      {
        name: 'PurchaseOrderID'
        type: 'String'
      }
      {
        name: 'StockItemID'
        type: 'String'
      }
      {
        name: 'OrderedOuters'
        type: 'String'
      }
      {
        name: 'Description'
        type: 'String'
      }
      {
        name: 'ReceivedOuters'
        type: 'String'
      }
      {
        name: 'PackageTypeID'
        type: 'String'
      }
      {
        name: 'ExpectedUnitPricePerOuter'
        type: 'String'
      }
      {
        name: 'LastReceiptDate'
        type: 'String'
      }
      {
        name: 'IsOrderLineFinalized'
        type: 'String'
      }
      {
        name: 'LastEditedBy'
        type: 'String'
      }
      {
        name: 'LastEditedWhen'
        type: 'String'
      }
    ]
  }
  dependsOn: [
    '${factoryId}/linkedServices/dplakestorageref'
  ]
}

resource factoryName_sink_DWH_Stage 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  name: '${factoryName}/sink_DWH_Stage'
  properties: {
    linkedServiceName: {
      referenceName: 'DWH_Ref'
      type: 'LinkedServiceReference'
    }
    parameters: {
      TableName: {
        type: 'String'
      }
    }
    folder: {
      name: 'Load DWH/sink'
    }
    annotations: []
    type: 'AzureSqlTable'
    schema: []
    typeProperties: {
      schema: 'stage'
      table: {
        value: '@dataset().TableName'
        type: 'Expression'
      }
    }
  }
  dependsOn: [
    '${factoryId}/linkedServices/DWH_Ref'
  ]
}

resource factoryName_sink_DWH_tmp 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  name: '${factoryName}/sink_DWH_tmp'
  properties: {
    linkedServiceName: {
      referenceName: 'DWH_Ref'
      type: 'LinkedServiceReference'
    }
    parameters: {
      TableName: {
        type: 'String'
      }
    }
    folder: {
      name: 'Load DWH/sink'
    }
    annotations: []
    type: 'AzureSqlTable'
    schema: []
    typeProperties: {
      schema: 'tmp'
      table: {
        value: '@dataset().TableName'
        type: 'Expression'
      }
    }
  }
  dependsOn: [
    '${factoryId}/linkedServices/DWH_Ref'
  ]
}

resource factoryName_sink_MergedStockdata 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  name: '${factoryName}/sink_MergedStockdata'
  properties: {
    linkedServiceName: {
      referenceName: 'dplakestorageref'
      type: 'LinkedServiceReference'
    }
    folder: {
      name: 'stockdata/02a-processed/sink'
    }
    annotations: []
    type: 'DelimitedText'
    typeProperties: {
      location: {
        type: 'AzureBlobFSLocation'
        fileName: {
          value: '@concat(\'MergedStockdata.csv\')'
          type: 'Expression'
        }
        folderPath: 'stockdata'
        fileSystem: '02a-processed'
      }
      columnDelimiter: ','
      escapeChar: '\\'
      firstRowAsHeader: true
      quoteChar: '"'
    }
    schema: []
  }
  dependsOn: [
    '${factoryId}/linkedServices/dplakestorageref'
  ]
}

resource factoryName_sink_exchangerates_01raw 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  name: '${factoryName}/sink_exchangerates_01raw'
  properties: {
    linkedServiceName: {
      referenceName: 'dplakestorageref'
      type: 'LinkedServiceReference'
    }
    folder: {
      name: 'ExchangeRatesAPI/sink'
    }
    annotations: []
    type: 'DelimitedText'
    typeProperties: {
      location: {
        type: 'AzureBlobFSLocation'
        fileName: {
          value: '@concat(\'exchangerates\',\'.csv\')'
          type: 'Expression'
        }
        folderPath: {
          value: '@concat(\'exchangeratesAPI\',\'/\',formatDateTime(utcnow(),\'yyyy\'),\'/\',formatDateTime(utcnow(),\'MM\'),\'/\',formatDateTime(utcnow(),\'dd\'))'
          type: 'Expression'
        }
        fileSystem: '01-raw'
      }
      columnDelimiter: ','
      escapeChar: '\\'
      firstRowAsHeader: true
      quoteChar: '"'
    }
    schema: []
  }
  dependsOn: [
    '${factoryId}/linkedServices/dplakestorageref'
  ]
}

resource factoryName_sink_stockdata 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  name: '${factoryName}/sink_stockdata'
  properties: {
    linkedServiceName: {
      referenceName: 'dplakestorageref'
      type: 'LinkedServiceReference'
    }
    parameters: {
      FileName: {
        type: 'String'
      }
    }
    folder: {
      name: 'stockdata/01-raw/sink'
    }
    annotations: []
    type: 'DelimitedText'
    typeProperties: {
      location: {
        type: 'AzureBlobFSLocation'
        fileName: {
          value: '@dataset().FileName'
          type: 'Expression'
        }
        folderPath: {
          value: '@concat(\'stockdata\',\'/\',formatDateTime(utcnow(),\'yyyy\'),\'/\',formatDateTime(utcnow(),\'MM\'),\'/\',formatDateTime(utcnow(),\'dd\'))'
          type: 'Expression'
        }
        fileSystem: '01-raw'
      }
      columnDelimiter: ','
      escapeChar: '\\'
      firstRowAsHeader: true
      quoteChar: '"'
    }
    schema: [
      {
        name: 'Date'
        type: 'String'
      }
      {
        name: 'Open'
        type: 'String'
      }
      {
        name: 'High'
        type: 'String'
      }
      {
        name: 'Low'
        type: 'String'
      }
      {
        name: 'Close'
        type: 'String'
      }
      {
        name: 'Volume'
        type: 'String'
      }
      {
        name: 'OpenInt'
        type: 'String'
      }
    ]
  }
  dependsOn: [
    '${factoryId}/linkedServices/dplakestorageref'
  ]
}

resource factoryName_sink_tmp_stockdata 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  name: '${factoryName}/sink_tmp_stockdata'
  properties: {
    linkedServiceName: {
      referenceName: 'dplakestorageref'
      type: 'LinkedServiceReference'
    }
    folder: {
      name: 'stockdata/01-raw/sink'
    }
    annotations: []
    type: 'Binary'
    typeProperties: {
      location: {
        type: 'AzureBlobFSLocation'
        fileSystem: '98-temporary'
      }
    }
  }
  dependsOn: [
    '${factoryId}/linkedServices/dplakestorageref'
  ]
}

resource factoryName_source_02aprocessed 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  name: '${factoryName}/source_02aprocessed'
  properties: {
    linkedServiceName: {
      referenceName: 'dplakestorageref'
      type: 'LinkedServiceReference'
    }
    parameters: {
      directory: {
        type: 'String'
      }
      fileName: {
        type: 'String'
      }
    }
    folder: {
      name: 'Load DWH/source'
    }
    annotations: []
    type: 'DelimitedText'
    typeProperties: {
      location: {
        type: 'AzureBlobFSLocation'
        fileName: {
          value: '@dataset().fileName'
          type: 'Expression'
        }
        folderPath: {
          value: '@dataset().directory'
          type: 'Expression'
        }
        fileSystem: '02-cleansed'
      }
      columnDelimiter: ','
      escapeChar: '\\'
      firstRowAsHeader: true
      quoteChar: '"'
    }
    schema: [
      {
        name: 'LineID'
        type: 'String'
      }
      {
        name: 'OrderID'
        type: 'String'
      }
      {
        name: 'ItemID'
        type: 'String'
      }
      {
        name: 'OrderedOuters'
        type: 'String'
      }
      {
        name: 'Description'
        type: 'String'
      }
      {
        name: 'ReceivedOuters'
        type: 'String'
      }
      {
        name: 'PackageTypeID'
        type: 'String'
      }
      {
        name: 'ExpectedUnitPricePerOuter'
        type: 'String'
      }
      {
        name: 'LastReceiptDate'
        type: 'String'
      }
      {
        name: 'IsOrderLineFinalized'
        type: 'String'
      }
      {
        name: 'LastEditedBy'
        type: 'String'
      }
      {
        name: 'LastEditedWhen'
        type: 'String'
      }
    ]
  }
  dependsOn: [
    '${factoryId}/linkedServices/dplakestorageref'
  ]
}

resource factoryName_source_02cleansed 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  name: '${factoryName}/source_02cleansed'
  properties: {
    linkedServiceName: {
      referenceName: 'dplakestorageref'
      type: 'LinkedServiceReference'
    }
    parameters: {
      directory: {
        type: 'String'
      }
      fileName: {
        type: 'String'
      }
    }
    folder: {
      name: 'Load DWH/source'
    }
    annotations: []
    type: 'DelimitedText'
    typeProperties: {
      location: {
        type: 'AzureBlobFSLocation'
        fileName: {
          value: '@dataset().fileName'
          type: 'Expression'
        }
        folderPath: {
          value: '@dataset().directory'
          type: 'Expression'
        }
        fileSystem: '02-cleansed'
      }
      columnDelimiter: ','
      escapeChar: '\\'
      firstRowAsHeader: true
      quoteChar: '"'
    }
    schema: [
      {
        name: 'LineID'
        type: 'String'
      }
      {
        name: 'OrderID'
        type: 'String'
      }
      {
        name: 'ItemID'
        type: 'String'
      }
      {
        name: 'OrderedOuters'
        type: 'String'
      }
      {
        name: 'Description'
        type: 'String'
      }
      {
        name: 'ReceivedOuters'
        type: 'String'
      }
      {
        name: 'PackageTypeID'
        type: 'String'
      }
      {
        name: 'ExpectedUnitPricePerOuter'
        type: 'String'
      }
      {
        name: 'LastReceiptDate'
        type: 'String'
      }
      {
        name: 'IsOrderLineFinalized'
        type: 'String'
      }
      {
        name: 'LastEditedBy'
        type: 'String'
      }
      {
        name: 'LastEditedWhen'
        type: 'String'
      }
    ]
  }
  dependsOn: [
    '${factoryId}/linkedServices/dplakestorageref'
  ]
}

resource factoryName_source_PreSQLScript 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  name: '${factoryName}/source_PreSQLScript'
  properties: {
    linkedServiceName: {
      referenceName: 'dplakestorageref'
      type: 'LinkedServiceReference'
    }
    parameters: {
      directory: {
        type: 'String'
      }
      FileName: {
        type: 'String'
      }
    }
    folder: {
      name: 'Load DWH/source'
    }
    annotations: []
    type: 'DelimitedText'
    typeProperties: {
      location: {
        type: 'AzureBlobFSLocation'
        fileName: {
          value: '@dataset().FileName'
          type: 'Expression'
        }
        folderPath: {
          value: '@dataset().directory'
          type: 'Expression'
        }
        fileSystem: '99-metadata'
      }
      columnDelimiter: ','
      escapeChar: '\\'
      quoteChar: '"'
    }
    schema: [
      {
        type: 'String'
      }
      {
        type: 'String'
      }
    ]
  }
  dependsOn: [
    '${factoryId}/linkedServices/dplakestorageref'
  ]
}

resource factoryName_source_SQLTable 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  name: '${factoryName}/source_SQLTable'
  properties: {
    linkedServiceName: {
      referenceName: 'external_SQL_WideWorldImporters'
      type: 'LinkedServiceReference'
    }
    parameters: {
      SchemaName: {
        type: 'String'
      }
      TableName: {
        type: 'String'
      }
    }
    folder: {
      name: 'external-sql/source'
    }
    annotations: []
    type: 'AzureSqlTable'
    schema: []
    typeProperties: {
      schema: {
        value: '@dataset().SchemaName'
        type: 'Expression'
      }
      table: {
        value: '@dataset().TableName'
        type: 'Expression'
      }
    }
  }
  dependsOn: [
    '${factoryId}/linkedServices/external_SQL_WideWorldImporters'
  ]
}

resource factoryName_source_csvCleansing_directories 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  name: '${factoryName}/source_csvCleansing_directories'
  properties: {
    linkedServiceName: {
      referenceName: 'dplakestorageref'
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
  dependsOn: [
    '${factoryId}/linkedServices/dplakestorageref'
  ]
}

resource factoryName_source_directories02_cleansed_for_DWH 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  name: '${factoryName}/source_directories02_cleansed_for_DWH'
  properties: {
    linkedServiceName: {
      referenceName: 'dplakestorageref'
      type: 'LinkedServiceReference'
    }
    folder: {
      name: 'Load DWH/Metadata'
    }
    annotations: []
    type: 'DelimitedText'
    typeProperties: {
      location: {
        type: 'AzureBlobFSLocation'
        fileName: 'DWH_directories2LoadFrom02-cleansed.csv'
        folderPath: '99-globalcsv'
        fileSystem: '99-metadata'
      }
      columnDelimiter: ','
      escapeChar: '\\'
      firstRowAsHeader: true
      quoteChar: '"'
    }
    schema: [
      {
        name: 'directoryName'
        type: 'String'
      }
    ]
  }
  dependsOn: [
    '${factoryId}/linkedServices/dplakestorageref'
  ]
}

resource factoryName_source_directories02a_processed_for_DWH 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  name: '${factoryName}/source_directories02a_processed_for_DWH'
  properties: {
    linkedServiceName: {
      referenceName: 'dplakestorageref'
      type: 'LinkedServiceReference'
    }
    folder: {
      name: 'Load DWH/Metadata'
    }
    annotations: []
    type: 'DelimitedText'
    typeProperties: {
      location: {
        type: 'AzureBlobFSLocation'
        fileName: 'DWH_directories2LoadFrom02a-processed.csv'
        folderPath: '99-globalcsv'
        fileSystem: '99-metadata'
      }
      columnDelimiter: ','
      escapeChar: '\\'
      firstRowAsHeader: true
      quoteChar: '"'
    }
    schema: [
      {
        name: 'directoryName'
        type: 'String'
      }
    ]
  }
  dependsOn: [
    '${factoryId}/linkedServices/dplakestorageref'
  ]
}

resource factoryName_source_exchangerates_API 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  name: '${factoryName}/source_exchangerates_API'
  properties: {
    linkedServiceName: {
      referenceName: 'CurrencyAPI'
      type: 'LinkedServiceReference'
    }
    folder: {
      name: 'ExchangeRatesAPI/source'
    }
    annotations: []
    type: 'RestResource'
    typeProperties: {
      relativeUrl: 'https://www.live-rates.com/rates'
    }
    schema: []
  }
  dependsOn: [
    '${factoryId}/linkedServices/CurrencyAPI'
  ]
}

resource factoryName_source_getFiles02_cleansed 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  name: '${factoryName}/source_getFiles02_cleansed'
  properties: {
    linkedServiceName: {
      referenceName: 'dplakestorageref'
      type: 'LinkedServiceReference'
    }
    parameters: {
      directory: {
        type: 'String'
      }
    }
    folder: {
      name: 'Load DWH/source'
    }
    annotations: []
    type: 'Binary'
    typeProperties: {
      location: {
        type: 'AzureBlobFSLocation'
        folderPath: {
          value: '@dataset().directory'
          type: 'Expression'
        }
        fileSystem: '02-cleansed'
      }
    }
  }
  dependsOn: [
    '${factoryId}/linkedServices/dplakestorageref'
  ]
}

resource factoryName_source_getFiles02a_processed 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  name: '${factoryName}/source_getFiles02a_processed'
  properties: {
    linkedServiceName: {
      referenceName: 'dplakestorageref'
      type: 'LinkedServiceReference'
    }
    parameters: {
      directory: {
        type: 'String'
      }
    }
    folder: {
      name: 'Load DWH/source'
    }
    annotations: []
    type: 'Binary'
    typeProperties: {
      location: {
        type: 'AzureBlobFSLocation'
        folderPath: {
          value: '@dataset().directory'
          type: 'Expression'
        }
        fileSystem: '02a-processed'
      }
    }
  }
  dependsOn: [
    '${factoryId}/linkedServices/dplakestorageref'
  ]
}

resource factoryName_source_stockdataCleansedFiles 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  name: '${factoryName}/source_stockdataCleansedFiles'
  properties: {
    linkedServiceName: {
      referenceName: 'dplakestorageref'
      type: 'LinkedServiceReference'
    }
    folder: {
      name: 'stockdata/02a-processed/source'
    }
    annotations: []
    type: 'Binary'
    typeProperties: {
      location: {
        type: 'AzureBlobFSLocation'
        folderPath: 'stockdata'
        fileSystem: '02-cleansed'
      }
    }
  }
  dependsOn: [
    '${factoryId}/linkedServices/dplakestorageref'
  ]
}

resource factoryName_source_stockdataFile 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  name: '${factoryName}/source_stockdataFile'
  properties: {
    linkedServiceName: {
      referenceName: 'dplakestorageref'
      type: 'LinkedServiceReference'
    }
    parameters: {
      FileName: {
        type: 'String'
      }
    }
    folder: {
      name: 'stockdata/01-raw/source'
    }
    annotations: []
    type: 'DelimitedText'
    typeProperties: {
      location: {
        type: 'AzureBlobFSLocation'
        fileName: {
          value: '@dataset().FileName'
          type: 'Expression'
        }
        folderPath: 'Stocks.zip'
        fileSystem: '98-temporary'
      }
      columnDelimiter: ','
      escapeChar: '\\'
      firstRowAsHeader: true
      quoteChar: '"'
    }
    schema: []
  }
  dependsOn: [
    '${factoryId}/linkedServices/dplakestorageref'
  ]
}

resource factoryName_source_stockdataZip 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  name: '${factoryName}/source_stockdataZip'
  properties: {
    linkedServiceName: {
      referenceName: 'FileStorage_external'
      type: 'LinkedServiceReference'
    }
    folder: {
      name: 'stockdata/01-raw/source'
    }
    annotations: []
    type: 'Binary'
    typeProperties: {
      location: {
        type: 'AzureFileStorageLocation'
        fileName: 'Stocks.zip'
        folderPath: 'stockdata'
      }
      compression: {
        type: 'ZipDeflate'
        level: 'Optimal'
      }
    }
  }
  dependsOn: [
    '${factoryId}/linkedServices/FileStorage_external'
  ]
}

resource factoryName_source_stockdata_files 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  name: '${factoryName}/source_stockdata_files'
  properties: {
    linkedServiceName: {
      referenceName: 'dplakestorageref'
      type: 'LinkedServiceReference'
    }
    folder: {
      name: 'stockdata/01-raw/source'
    }
    annotations: []
    type: 'Binary'
    typeProperties: {
      location: {
        type: 'AzureBlobFSLocation'
        folderPath: 'Stocks.zip'
        fileSystem: '98-temporary'
      }
    }
  }
  dependsOn: [
    '${factoryId}/linkedServices/dplakestorageref'
  ]
}

resource factoryName_source_stockdatacleansed 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  name: '${factoryName}/source_stockdatacleansed'
  properties: {
    linkedServiceName: {
      referenceName: 'dplakestorageref'
      type: 'LinkedServiceReference'
    }
    parameters: {
      FileName: {
        type: 'String'
      }
    }
    folder: {
      name: 'stockdata/02a-processed/source'
    }
    annotations: []
    type: 'DelimitedText'
    typeProperties: {
      location: {
        type: 'AzureBlobFSLocation'
        fileName: {
          value: '@dataset().FileName'
          type: 'Expression'
        }
        folderPath: 'stockdata'
        fileSystem: '02-cleansed'
      }
      columnDelimiter: ','
      escapeChar: '\\'
      firstRowAsHeader: true
      quoteChar: '"'
    }
    schema: [
      {
        type: 'String'
      }
      {
        type: 'String'
      }
      {
        type: 'String'
      }
      {
        type: 'String'
      }
      {
        type: 'String'
      }
      {
        type: 'String'
      }
      {
        type: 'String'
      }
    ]
  }
  dependsOn: [
    '${factoryId}/linkedServices/dplakestorageref'
  ]
}

resource factoryName_spTableExists 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  name: '${factoryName}/spTableExists'
  properties: {
    linkedServiceName: {
      referenceName: 'DWH_Ref'
      type: 'LinkedServiceReference'
    }
    folder: {
      name: 'Load DWH'
    }
    annotations: []
    type: 'AzureSqlTable'
    schema: []
    typeProperties: {}
  }
  dependsOn: [
    '${factoryId}/linkedServices/DWH_Ref'
  ]
}

resource factoryName_CurrencyAPI 'Microsoft.DataFactory/factories/linkedServices@2018-06-01' = {
  name: '${factoryName}/CurrencyAPI'
  properties: {
    annotations: []
    type: 'RestService'
    typeProperties: {
      url: CurrencyAPI_properties_typeProperties_url
      enableServerCertificateValidation: true
      authenticationType: 'Anonymous'
    }
  }
  dependsOn: []
}

resource factoryName_DWH_Ref 'Microsoft.DataFactory/factories/linkedServices@2018-06-01' = {
  name: '${factoryName}/DWH_Ref'
  properties: {
    annotations: []
    type: 'AzureSqlDatabase'
    typeProperties: {
      connectionString: DWH_Ref_connectionString
      password: {
        type: 'AzureKeyVaultSecret'
        store: {
          referenceName: 'dp_keyvault_ref'
          type: 'LinkedServiceReference'
        }
        secretName: 'dp-lakesqlserver-admin'
      }
    }
    connectVia: {
      referenceName: 'AutoResolveIntegrationRuntime'
      type: 'IntegrationRuntimeReference'
    }
  }
  dependsOn: [
    '${factoryId}/integrationRuntimes/AutoResolveIntegrationRuntime'
    '${factoryId}/linkedServices/dp_keyvault_ref'
  ]
}

resource factoryName_FileStorage_external 'Microsoft.DataFactory/factories/linkedServices@2018-06-01' = {
  name: '${factoryName}/FileStorage_external'
  properties: {
    annotations: []
    type: 'AzureFileStorage'
    typeProperties: {
      connectionString: FileStorage_external_connectionString
      fileShare: 'external'
    }
    connectVia: {
      referenceName: 'AutoResolveIntegrationRuntime'
      type: 'IntegrationRuntimeReference'
    }
  }
  dependsOn: [
    '${factoryId}/integrationRuntimes/AutoResolveIntegrationRuntime'
  ]
}

resource factoryName_dp_databricks_ref 'Microsoft.DataFactory/factories/linkedServices@2018-06-01' = {
  name: '${factoryName}/dp_databricks_ref'
  properties: {
    annotations: []
    type: 'AzureDatabricks'
    typeProperties: {
      domain: 'https://adb-4064004136427662.2.azuredatabricks.net'
      authentication: 'MSI'
      workspaceResourceId: '/subscriptions/147eb7a5-1550-417c-aad5-c39c3e264d4d/resourceGroups/Referenz_Core/providers/Microsoft.Databricks/workspaces/dp-databricks-ref'
      newClusterNodeType: 'Standard_DS3_v2'
      newClusterNumOfWorker: '1:4'
      newClusterSparkEnvVars: {
        PYSPARK_PYTHON: '/databricks/python3/bin/python3'
      }
      newClusterVersion: '7.3.x-scala2.12'
      newClusterInitScripts: []
    }
    connectVia: {
      referenceName: 'AutoResolveIntegrationRuntime'
      type: 'IntegrationRuntimeReference'
    }
  }
  dependsOn: [
    '${factoryId}/integrationRuntimes/AutoResolveIntegrationRuntime'
  ]
}

resource factoryName_dp_keyvault_ref 'Microsoft.DataFactory/factories/linkedServices@2018-06-01' = {
  name: '${factoryName}/dp_keyvault_ref'
  properties: {
    annotations: []
    type: 'AzureKeyVault'
    typeProperties: {
      baseUrl: dp_keyvault_ref_properties_typeProperties_baseUrl
    }
  }
  dependsOn: []
}

resource factoryName_dplakestorageref 'Microsoft.DataFactory/factories/linkedServices@2018-06-01' = {
  name: '${factoryName}/dplakestorageref'
  properties: {
    annotations: []
    type: 'AzureBlobFS'
    typeProperties: {
      url: dplakestorageref_properties_typeProperties_url
      accountKey: {
        type: 'SecureString'
        value: dplakestorageref_accountKey
      }
    }
    connectVia: {
      referenceName: 'AutoResolveIntegrationRuntime'
      type: 'IntegrationRuntimeReference'
    }
  }
  dependsOn: [
    '${factoryId}/integrationRuntimes/AutoResolveIntegrationRuntime'
  ]
}

resource factoryName_dpstorageexternalref 'Microsoft.DataFactory/factories/linkedServices@2018-06-01' = {
  name: '${factoryName}/dpstorageexternalref'
  properties: {
    annotations: []
    type: 'AzureBlobFS'
    typeProperties: {
      url: dpstorageexternalref_properties_typeProperties_url
      accountKey: {
        type: 'SecureString'
        value: dpstorageexternalref_accountKey
      }
    }
    connectVia: {
      referenceName: 'AutoResolveIntegrationRuntime'
      type: 'IntegrationRuntimeReference'
    }
  }
  dependsOn: [
    '${factoryId}/integrationRuntimes/AutoResolveIntegrationRuntime'
  ]
}

resource factoryName_external_SQL_WideWorldImporters 'Microsoft.DataFactory/factories/linkedServices@2018-06-01' = {
  name: '${factoryName}/external_SQL_WideWorldImporters'
  properties: {
    annotations: []
    type: 'AzureSqlDatabase'
    typeProperties: {
      connectionString: external_SQL_WideWorldImporters_connectionString
      password: {
        type: 'AzureKeyVaultSecret'
        store: {
          referenceName: 'dp_keyvault_ref'
          type: 'LinkedServiceReference'
        }
        secretName: 'dp-lakesqlserver-admin'
      }
    }
    connectVia: {
      referenceName: 'AutoResolveIntegrationRuntime'
      type: 'IntegrationRuntimeReference'
    }
  }
  dependsOn: [
    '${factoryId}/integrationRuntimes/AutoResolveIntegrationRuntime'
    '${factoryId}/linkedServices/dp_keyvault_ref'
  ]
}

resource factoryName_DailyTrigger 'Microsoft.DataFactory/factories/triggers@2018-06-01' = {
  name: '${factoryName}/DailyTrigger'
  properties: {
    annotations: []
    runtimeState: 'Started'
    pipelines: []
    type: 'ScheduleTrigger'
    typeProperties: {
      recurrence: {
        frequency: 'Day'
        interval: 1
        startTime: '20.08.2021 00:00:00'
        endTime: '17.09.2021 00:00:00'
        timeZone: 'UTC'
        schedule: {
          minutes: [
            0
          ]
          hours: [
            7
          ]
        }
      }
    }
  }
  dependsOn: []
}

resource factoryName_AutoResolveIntegrationRuntime 'Microsoft.DataFactory/factories/integrationRuntimes@2018-06-01' = {
  name: '${factoryName}/AutoResolveIntegrationRuntime'
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
    '${factoryId}/managedVirtualNetworks/default'
  ]
}

resource factoryName_default 'Microsoft.DataFactory/factories/managedVirtualNetworks@2018-06-01' = {
  name: '${factoryName}/default'
  properties: {}
  dependsOn: []
}

resource factoryName_default_azureSQLprivateEndpoint 'Microsoft.DataFactory/factories/managedVirtualNetworks/managedPrivateEndpoints@2018-06-01' = {
  parent: factoryName_default
  name: 'azureSQLprivateEndpoint'
  properties: {
    privateLinkResourceId: azureSQLprivateEndpoint_properties_privateLinkResourceId
    groupId: azureSQLprivateEndpoint_properties_groupId
  }
  dependsOn: [
    '${factoryId}/managedVirtualNetworks/default'
  ]
}

resource factoryName_default_dplakestorageref_ep 'Microsoft.DataFactory/factories/managedVirtualNetworks/managedPrivateEndpoints@2018-06-01' = {
  parent: factoryName_default
  name: 'dplakestorageref_ep'
  properties: {
    privateLinkResourceId: dplakestorageref_ep_properties_privateLinkResourceId
    groupId: dplakestorageref_ep_properties_groupId
  }
  dependsOn: [
    '${factoryId}/managedVirtualNetworks/default'
  ]
}

resource factoryName_default_dpstorageexternalref_ep 'Microsoft.DataFactory/factories/managedVirtualNetworks/managedPrivateEndpoints@2018-06-01' = {
  parent: factoryName_default
  name: 'dpstorageexternalref_ep'
  properties: {
    privateLinkResourceId: dpstorageexternalref_ep_properties_privateLinkResourceId
    groupId: dpstorageexternalref_ep_properties_groupId
  }
  dependsOn: [
    '${factoryId}/managedVirtualNetworks/default'
  ]
}