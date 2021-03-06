######################################################### #
#                                                         #
# List tracked Artefacts in BizTalk Server Environment     #
# Created by: Niklas Gustafsson                           #
# Organisation: Integrationsbolaget / Kongsberg Maritime  #
# Date: 27 May 2015	.\0                                   #
# Version: 1.0                                            #
#                                                         #
######################################################### #
#                                                         #
#  Thanks to Sandro Pereira at Devscope for inspiring     #
###########################################################

########################################################### 
# Script Variables
########################################################### 
# $fileName = './trackedArtefacts.txt'
$nl = [Environment]::NewLine

########################################################### 
# SQL Settings
########################################################### 
$BTSSQLInstance = get-wmiobject MSBTS_GroupSetting -namespace root\MicrosoftBizTalkServer | 
					select-object -expand MgmtDbServerName
$BizTalkManagementDb = get-wmiobject MSBTS_GroupSetting -namespace root\MicrosoftBizTalkServer | 
						select-object -expand MgmtDbName

###########################################################
# Connect the BizTalk Management database
########################################################### 
[void] [System.reflection.Assembly]::LoadWithPartialName("Microsoft.BizTalk.ExplorerOM")
$BTSCatalog = New-Object Microsoft.BizTalk.ExplorerOM.BtsCatalogExplorer
$BTSCatalog.ConnectionString = "SERVER=$BTSSQLInstance;DATABASE=$BizTalkManagementDb;Integrated Security=SSPI"

###########################################################
# Get all BizTalk applications
###########################################################
$BTSApplications = $BTSCatalog.Applications 

Echo "Orchestrations with tracking enabled" 
foreach ($Application in $BTSApplications)
{
	$orchestrations = $Application.orchestrations | Where-Object {$_.Tracking -ne 0}
	foreach($orchestration in $orchestrations){
        echo "$($Application.Name)/$($orchestration.FullName)" 
    }
}

echo $nl
echo "Receive ports with tracking enabled:" 
$trackedReceivePorts = $BTSCatalog.ReceivePorts | where-object {$_.tracking -ne 0}
ForEach($receivePort in $trackedReceivePorts){ 
    echo "$($receivePort.Application.Name)/$($receivePort.name)" 
}

echo $nl
echo "Send ports with tracking enabled:" 
$trackedSendPorts = $BTSCatalog.SendPorts | where-object {$_.tracking -ne 0}
ForEach($sendPort in $trackedReceivePorts){ 
    echo "$($sendPort.Application.Name)/$($sendPort.name)" 
}


$whatever = Read-Host 'Script done, press enter to continue'