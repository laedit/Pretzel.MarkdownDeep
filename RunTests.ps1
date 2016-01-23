$ErrorActionPreference = "Stop"

$currentPath = (Get-Item -Path ".\" -Verbose).FullName
$testsiteFolder = "$currentPath\testsite"
$pluginsFolder = "$testsiteFolder\_plugins"
$postsFolder = "$testsiteFolder\_posts"
$testGeneratedFile = "$testsiteFolder\_site\2015\11\06\MarkdownDeepTest.html"

If (-Not (Test-Path $testsiteFolder)){
    & "pretzel" create testsite

    if ($LASTEXITCODE -ne 0) 
    {
        Exit
    }

    New-Item "$postsFolder/2015-11-06-MarkdownDeepTest.md" -type file -value @"
---
layout: post
title: "My First Post"
author: "Author"
comments: true
---

## Hello world...

```cs
static void Main() 
{
    Console.WriteLine("Hello World!");
}
```

This is my first post on the site!

First Header  | Second Header
------------- | -------------
Content Cell  | Content Cell
Content Cell  | Content Cell 
"@
}

If (Test-Path $pluginsFolder){
    Remove-Item $pluginsFolder -recurse
    Start-Sleep -milliseconds 100
}
New-Item $pluginsFolder -type directory
Start-Sleep -milliseconds 100
Add-Type -assembly "system.io.compression.filesystem"
[io.compression.zipfile]::ExtractToDirectory("$currentPath/artifacts/MarkdownDeepMarkdownEngine.zip", $pluginsFolder)

& "pretzel" bake testsite --debug

if ($LASTEXITCODE -ne 0) 
{
    Exit $LASTEXITCODE
}

$wordToFind ="<table>"
$file = Get-Content $testGeneratedFile
$containsWord = $file | %{$_ -match $wordToFind}

If($containsWord -contains $true)
{
    $originalForeground = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = "green"
    Write-Host "test passed"
    $host.UI.RawUI.ForegroundColor = $originalForeground
}
Else {
    throw "Generated post doesn't contains table'"
}