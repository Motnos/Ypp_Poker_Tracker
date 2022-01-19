$logLocation = 'D:\Ypp Chat Logging\Ept_emerald_Ypp_Chat_Log_EPT - Poker Example.txt' #Set this to your Ypp Chat Log Location
$pirateName = 'ept' #Set this to your pirate Name


$buyIns = Select-String -Path $logLocation -pattern "$pirateName bought in for"
$cashOuts = Select-String -Path $logLocation -pattern "$pirateName cashed out with"


Write-Host $buyIns
