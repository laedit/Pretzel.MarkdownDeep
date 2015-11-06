$ErrorActionPreference = "Stop"

$currentPath = (Get-Item -Path ".\" -Verbose).FullName
$artifactsFolder = "$currentPath\artifacts"
$tempFolder = "$currentPath\temp"

tools\nuget install MarkdownDeep.NET

Add-Type -assembly "system.io.compression.filesystem"

If (Test-Path $tempFolder){
    Remove-Item $tempFolder -recurse
    Start-Sleep -milliseconds 100
}

New-Item $tempFolder -type directory
Start-Sleep -milliseconds 100

If (Test-Path $artifactsFolder){
    Remove-Item $artifactsFolder -recurse
    Start-Sleep -milliseconds 100
}

New-Item $artifactsFolder -type directory
Start-Sleep -milliseconds 100

Copy-Item "MarkdownDeep.NET.1.5\lib\.NetFramework 3.5\MarkdownDeep.dll" "$tempFolder\MarkdownDeep.dll"
Copy-Item "src\MarkdownDeepEngine.csx" "$tempFolder\MarkdownDeepEngine.csx"

[io.compression.zipfile]::CreateFromDirectory("$tempFolder", "$artifactsFolder\MarkdownDeepMarkdownEngine.zip")
Remove-Item $tempFolder -recurse