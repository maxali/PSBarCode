
```powershell

  .\Scan-BarImage.ps1 -FilePath ".\test\*" | ForEach-Object { $_.Trim() }

```

## Function test

![QR-Code Example](https://upload.wikimedia.org/wikipedia/commons/0/07/QR_Droid_2663.png)
```
https://readcodes.azurewebsites.net/api/get?url=https://upload.wikimedia.org/wikipedia/commons/0/07/QR_Droid_2663.png
```