Get-Process | Where-Object CPU -gt 100
Get-Process | Where-Object WorkingSet64 -gt 200MB