[CmdletBinding()]
param(
  [String]$FilePath
)
$stderr = $null
$pinfo = New-Object System.Diagnostics.ProcessStartInfo
$pinfo.FileName = "$PSScriptRoot\lib\zbar\bin\zbarimg.exe"
$pinfo.WorkingDirectory = $PSScriptRoot

$pinfo.RedirectStandardError = $true
$pinfo.RedirectStandardOutput = $true
$pinfo.UseShellExecute = $false
$pinfo.CreateNoWindow = $true

$pinfo.Arguments = "-D $FilePath"

$p = New-Object System.Diagnostics.Process
$p.StartInfo = $pinfo
$p.Start() | Out-Null
$stdout = $p.StandardOutput.ReadToEnd()
$stderr = $p.StandardError.ReadToEnd()

$p.WaitForExit()

if (!$stdout) {
   throw $stderr
}

$stdout


