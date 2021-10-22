<#
Syntax: OpConTriggerFile.ps1 -SourceLocation "C:\ProgramData\OpConxps\Statements" -SourceFileExt "*.zip" -TRGFileName "MDR009"
Create a Trigger File that is CSV formatted containing File Name and File Size
Note if looking for a file/s with no ext use * IE -SourceFileExt "*"
Exit Code 30 = Unable to access the folder
Tested on 09/28/2021
Written By David Cornelius
#>

param (
    [parameter(mandatory=$true)]
    [string]$SourceLocation,
    [parameter(mandatory=$true)]
    [string]$SourceFileExt,
    [parameter(mandatory=$true)]
    [string]$TRGFileName
)

$ErrorActionPreference = "Stop"

#Testing to confirm accss to SourceLocation
 if ((Test-Path $SourceLocation))
    {
        Write-output [$(Get-Date)]:"Able to access $SourceLocation"
    }
else
    {
        $rc = 30
        Write-output [$(Get-Date)]:"Unable to access $SourceLocation"
        [Environment]::Exit($rc)
    }
#Creating Trigger File
Get-ChildItem "$SourceLocation\$SourceFileExt" -Force | ForEach {
    [PSCustomObject]@{
        Name = $_.Name
        Size = "$([int]($_.length ))"
    }
} | ConvertTo-Csv -NoTypeInformation | select -Skip 1 | Set-Content -Path "$SourceLocation\$TRGFileName.TRG"