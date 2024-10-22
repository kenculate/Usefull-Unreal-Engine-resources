# Array of folders and files to check
$pathsToCheck = @(
    "./package/Config",
    "./package/Content",
    "./package/Resources",
    "./package/Shaders",
    "./package/Source"
)


# Search for a .uplugin file in the current directory and subdirectories
$upluginFile = Get-ChildItem -Path . -Recurse -Filter *.uplugin | Select-Object -First 1

# Check if a .uplugin file was found
if ($upluginFile) {
    # Get the full path of the .uplugin file
    $upluginFullPath = $upluginFile.FullName
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
    Compress-Archive -Path $validPaths -DestinationPath "Release.zip"
    Write-Host "Archive created: Release.zip"
} else {
    Write-Host "No valid paths found to archive."
}
Read-Host -Prompt "Press Enter to exit"
