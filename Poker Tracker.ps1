$logLocation = 'C:\Ypp Chat Logs\Location\File.txt' #Set this to the location of your Ypp Chat Log
$pirateName = 'PirateName' #Set this to your Pirate Name

$totalBuyIn = 0
$totalRebuy = 0
$totalCashOut = 0

$buyIns = Select-String -Path $logLocation -Pattern "$pirateName bought in for ([\d]*)" 
$rebuys = Select-String -Path $logLocation -Pattern "$pirateName rebought for ([\d]*)"
$cashOuts = Select-String -Path $logLocation -pattern "Ye cashed out with ([\d]*)"

foreach ($buyIn in $buyIns) {
    $buyIn -match "bought in for ([\d,]*)" | Out-Null
    $totalBuyin = $totalBuyin + $Matches[1]
}
foreach ($cashOut in $cashOuts) {
    $cashOut -match "Ye cashed out with ([\d,]*)" | Out-Null
    $totalCashOut = $totalCashout + $Matches[1]
}
foreach ($rebuy in $reBuys) {
    $rebuy -match "rebought for ([\d,]*)" | Out-Null
    $totalRebuy = $totalRebuy + $Matches[1]
}

$finalValue = $totalCashOut - $totalBuyIn -$totalRebuy

If ($finalValue -ge 0) {
    Write-Host "Total Bought In In $totalBuyIn" -ForegroundColor Red
    Write-Host "Total Rebought $totalRebuy" -ForegroundColor Red
    Write-Host "Total Cashed out $totalCashOut" -ForegroundColor Green
    Write-Host "$pirateName made a total profit of $finalValue PoE" -ForegroundColor Green
}
Else {
    Write-Host "Total Bought In $totalBuyIn" -ForegroundColor Red
    Write-Host "Total Rebought $totalRebuy" -ForegroundColor Red
    Write-Host "Total Cashed out $totalCashOut" -ForegroundColor Green
    Write-Host "$pirateName lost a total of $finalValue PoE" -ForegroundColor Red
}
Pause
