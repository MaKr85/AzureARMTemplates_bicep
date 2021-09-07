#### TODOs ####


### reference_parameters.bicep
## Set Parameters
# In der Datei "reference_parameters.bicep" sind die Parameter des Deplyoments zu setzen

## ACHTUNG: Allowed IPs definieren
# In der Datei "reference_parameters.bicep" sind die erlaubten IPs zu setzen.
# Bei mehr als zwei einzutragenden IPs ist in der Datei "reference_datalake.bicep" im Abschnitt IP rules noch entsprechende Einträge zu ergänzen

## Deplyoment starten
# Befehle siehe "deploy.azcli"

## Nach dem Deplyoment
# im Azure Portal beim erstellten StorageAccount für den DataLake unter "Networking" den angefragten Private Endpoint der DataFactory bestätigen,
# im Azure Portal bei der erstellten DataFActory unter "Networking" die Option für "Connect via:" auf Private endpoint setzen
# im Azure Portal beim erstellten SynapseWorkspace unter "Networking" die Option für "Public network access to workspace endpoints" auf Disabled setzen
# in den Databricks Workspace einloggen und ein Notebook unter /Shared/CSVCleanser erstellen und den Code "CSVCleanser.py" einfügen