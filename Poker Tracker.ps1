$logLocation = 'D:\Ypp Chat Logging\Ept_emerald_Ypp_Chat_Log_EPT - Poker Example.txt' #Set this to the location of your Ypp Chat Log
$pirateName = 'ept' #Set this to your Pirate Name

$totalBuyIn = 0
$totalCashOut = 0

$buyIns = Select-String -Path $logLocation -Pattern "$pirateName bought in for ([\d]*)" 
$cashOuts = Select-String -Path $logLocation -pattern "$pirateName cashed out with ([\d]*)"

foreach ($buyIn in $buyIns) {

    $buyIn -match "bought in for ([\d]*)" | Out-Null
    $totalBuyin = $totalBuyin + $Matches[1]

}

foreach ($cashOut in $cashOuts) {

    $cashOut -match "cashed out with ([\d]*)" | Out-Null
    $totalCashOut = $totalCashout + $Matches[1]

}

$finalValue = $totalCashOut - $totalBuyIn

If ($totalCashOut -ge $totalBuyIn) {

Write-Host "You made a profit of $finalValue PoE" -ForegroundColor Green

}
Else {
Write-Host "You lost a total of $finalValue PoE" -ForegroundColor Red
}

