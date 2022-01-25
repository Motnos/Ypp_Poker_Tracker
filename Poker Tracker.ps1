$logLocation = 'D:\Ypp Chat Logging\Ept_emerald_Ypp_Chat_Log_EPT.txt' #Set this to the location of your Ypp Chat Log
$pirateName = 'Ept' #Set this to your Pirate Name
$streamOutput = 'D:\Ypp Chat Logging\Stream\Output.txt' #Set this as a text source in OBS

$totalBuyIn = 0
$totalRebuy = 0
$totalCashOut = 0
$totalCashOutRebuy = 0
$loss = 0

While ($pirateName = 'Ept') {

    $buyIns = Select-String -Path $logLocation -Pattern "[[]{1}[\d]{2}[:]{1}[\d]{2}[:]{1}[\d]{2}\S{1} $pirateName bought in for ([\d]*)" 
    $rebuys = Select-String -Path $logLocation -Pattern "[[]{1}[\d]{2}[:]{1}[\d]{2}[:]{1}[\d]{2}\S{1} $pirateName rebought for ([\d]*)"
    $cashOuts = Select-String -Path $logLocation -pattern "[[]{1}[\d]{2}[:]{1}[\d]{2}[:]{1}[\d]{2}\S{1} Ye cashed out with ([\d]*)"
    $cashOutRebuys = Select-String -Path $logLocation -pattern "[[]{1}[\d]{2}[:]{1}[\d]{2}[:]{1}[\d]{2}\S{1} $pirateName cashed out with ([\d]*)" # If you cash out and rebuy in the same turn puts your pirate name in the chat rather than 'Ye'.

    foreach ($buyIn in $buyIns) {
        $buyIn -match "bought in for ([\d,]*)" | Out-Null
        $totalBuyin = $totalBuyin + $Matches[1]
    }
    foreach ($rebuy in $reBuys) {
        $rebuy -match "rebought for ([\d,]*)" | Out-Null
        $totalRebuy = $totalRebuy + $Matches[1]
    }
    foreach ($cashOut in $cashOuts) {
        $cashOut -match "Ye cashed out with ([\d,]*)" | Out-Null
        $totalCashOut = $totalCashout + $Matches[1]
    }
    foreach ($cashOutRebuy in $cashOutRebuys) {
        $cashOutRebuy -match "$pirateName cashed out with ([\d,]*)" | Out-Null
        $totalCashOutRebuy = $totalCashoutRebuy + $Matches[1]
    }

    $totalCashOut = $totalCashOut + $totalCashOutRebuy
    $finalValue = $totalCashOut - $totalBuyIn -$totalRebuy 

    If ($finalValue -ge 0) {

        Write-Host "$pirateName made a total profit of $finalValue PoE" -ForegroundColor Green
        "+$finalValue" | Out-File -FilePath $streamOutput
        
        $totalBuyIn = 0
        $totalRebuy = 0
        $totalCashOut = 0
        $totalCashOutRebuy = 0
        $loss = 0
    }

    Else {

        Write-Host "$pirateName lost a total of $finalValue PoE" -ForegroundColor Red
        $totalBuyIn = 0
        $totalRebuy = 0
        $totalCashOut = 0
        $totalCashOutRebuy = 0
        $loss = 1
    }

    $finalValue = $finalValue.ToString() #Converts $finalValue to String from INT before rounding
    $finalValue = $finalValue -replace '[-]','' #Removes the - if there is a loss to prevent broken calculation, to a it back later on.


    if ($finalValue.length -eq '8') {
 
        $finalValue = $finalValue.Substring(0,2) + "." + $finalValue.Substring(2,2)
        $finalValue =  $finalValue+"M"

    }
    elseif ($finalValue.length -eq '7') {
 
        $finalValue = $finalValue.Substring(0,1) + "." + $finalValue.Substring(1,2)
       $finalValue = $finalValue+"M"

    }
    elseif ($finalValue.length -eq '6') {
 
        $finalValue = $finalValue.Substring(0,3) + "." + $finalValue.Substring(3,1)
        $finalValue = $finalValue+"K"

    }
    elseif ($finalValue.length -eq '5') {
 
        $finalValue = $finalValue.Substring(0,2) + "." + $finalValue.Substring(2,1)
        $finalValue = $finalValue+"K"

    }
    elseif ($finalValue.length -eq '4') {

        $finalValue = $finalValue.Substring(0,1) + "." + $finalValue.Substring(1,1)
        $finalValue = $finalValue+"K"

    }
    
    if ($loss -eq 1) {
    
        Write-Host "-$finalValue Saved to $streamOutput"
        "-$finalValue" | Out-File -FilePath $streamOutput

    }
    else {

        Write-Host "+$finalValue Saved to $streamOutput"
        "+$finalValue" | Out-File -FilePath $streamOutput

    }

    Start-Sleep 5 #Amount of seconds to wait before script runs again
}
