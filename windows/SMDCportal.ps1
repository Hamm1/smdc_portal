
if (!(Test-Path "C:\Users\$($env:Username)\AppData\Local\SMDC-Portal")){
    mkdir "C:\Users\$($env:Username)\AppData\Local\SMDC-Portal"
}
copy-item '\\smdhw6huaans01n.smdch.smdc.army.mil\portal$\locations.json' "C:\Users\$($env:Username)\AppData\Local\SMDC-Portal" -Force
copy-item '\\smdhw6huaans01n.smdch.smdc.army.mil\portal$\smdc_portal.exe' "C:\Users\$($env:Username)\AppData\Local\SMDC-Portal" -Force
start-process "C:\Users\$($env:Username)\AppData\Local\SMDC-Portal\smdc_portal.exe" -wait
remove-item "C:\Users\$($env:Username)\AppData\Local\SMDC-Portal\smdc_portal.exe" -Force
remove-item "C:\Users\$($env:Username)\AppData\Local\SMDC-Portal\locations.json" -Force