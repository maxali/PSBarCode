$requestBody = Get-Content $req -Raw | ConvertFrom-Json

# Get request body or query string parameter
if ($req_query_url) {
    $url = $req_query_url
} else {
    $url = $requestBody.url
}
$fileName = $url.Substring($url.LastIndexOf("/") + 1);

$localFilePath = "$EXECUTION_CONTEXT_FUNCTIONDIRECTORY\tmp\$fileName"
Write-Output "Downloading $url"

(New-Object System.Net.WebClient).DownloadFile($url, $localFilePath)

Write-Output "Run ZBarImg ... "
$stderr = $null
$pinfo = New-Object System.Diagnostics.ProcessStartInfo
$pinfo.FileName = "$EXECUTION_CONTEXT_FUNCTIONDIRECTORY\lib\zbar\bin\zbarimg.exe"
$pinfo.WorkingDirectory = $PSScriptRoot

$pinfo.RedirectStandardError = $true
$pinfo.RedirectStandardOutput = $true
$pinfo.UseShellExecute = $false
$pinfo.CreateNoWindow = $true

$pinfo.Arguments = "-D $localFilePath"

$p = New-Object System.Diagnostics.Process
$p.StartInfo = $pinfo
$p.Start() | Out-Null
$stdout = $p.StandardOutput.ReadToEnd()
$stderr = $p.StandardError.ReadToEnd()

$p.WaitForExit()

Write-Output "Deleting temp file $fileName"

Remove-Item -Path $localFilePath -Force

if (!$stdout) {
   throw $stderr
}

$codes = $stdout | ForEach-Object { $_.Trim() }

#Out-File -InputObject $response -FilePath $res -Encoding Ascii
#$content = "FUNCTIONNAME=$EXECUTION_CONTEXT_FUNCTIONNAME,FUNCTIONDIRECTORY=$EXECUTION_CONTEXT_FUNCTIONDIRECTORY" 
$result = @{Status = 200; Headers =@{ "content-type" = "text/plain" }; Body = $codes} | ConvertTo-Json
Out-File -Encoding Ascii $res -inputObject $result;

