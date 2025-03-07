# version 0.3
# Array of folders and files to check
$pathsToCheck = @(
    "./package/Config",
    "./package/Content",
    "./package/Resources",
    "./package/Shaders"
)


Write-Host "Do you want to include the source code?"
Write-Host "1. yes"
Write-Host "2. no"
$selection = Read-Host "Enter the number of your choice:"

$Source = ""
switch ($selection) {
    1 {
        $pathsToCheck += "./package/Source"
        $Source = "Source"
    }
    2 {
        $pathsToCheck += "./package/Binaries"
        $Source = "Binaries"

    }
    default {
        Write-Host "Invalid selection. Please choose 1 or 2."
        Read-Host -Prompt "Press Enter to exit"
        exit
    }
}

Write-Host $pathsToCheck
# Search for a .uplugin file in the current directory and subdirectories
$upluginFile = Get-ChildItem -Path . -Recurse -Filter *.uplugin | Select-Object -First 1

$FriendlyName = ""
$VersionName = "_"
$EngineVersion = "_"
# Check if a .uplugin file was found
if ($upluginFile) {
    # Get the full path of the .uplugin file
    $upluginFullPath = $upluginFile.FullName

    $upluginContent = Get-Content -Path $upluginFullPath -Raw | ConvertFrom-Json
    # Extract the VersionName
    $FriendlyName = $upluginContent.FriendlyName
    $VersionName = $upluginContent.VersionName
    $EngineVersion = $upluginContent.EngineVersion

    $pathsToCheck += $upluginFullPath
} else {
    Write-Host "No .uplugin file found."
}

# Array to store valid paths that exist
$validPaths = @()

# Check if each path exists and add it to the validPaths array
foreach ($path in $pathsToCheck) {
    if (Test-Path $path) {
        $validPaths += $path
    } else {
        Write-Host "Skipping: $path (not found)"
    }
}

# Compress the valid paths if any were found
if ($validPaths.Count -gt 0) {

    $zipname = "${FriendlyName}_UE${EngineVersion}_v${VersionName}_${Source}.zip"
    Compress-Archive -Path $validPaths -DestinationPath $zipname
    Write-Host "Archive created: $zipname"
} else {
    Write-Host "No valid paths found to archive."
}
Read-Host -Prompt "Press Enter to exit"
