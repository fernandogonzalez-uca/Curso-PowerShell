Get-Process | Where-Object CPU -gt 100
echo "************************"
Get-Process | Where-Object WorkingSet64 -gt 200MB