# Define options
$option1 = "E:\Works\Unreal\UE_5.3\Engine\Build\BatchFiles\RunUAT.bat"
$option2 = "E:\Works\Unreal\UE_5.4\Engine\Build\BatchFiles\RunUAT.bat"

Write-Host "Please select an UE Version:"
Write-Host "1. $option1"
Write-Host "2. $option2"
$selection = Read-Host "Enter the number of your choice:"

switch ($selection) {
    1 {
        $RunUATPath = $option1
    }
    2 {
        $RunUATPath = $option2
    }
    default {
        Write-Host "Invalid selection. Please choose 1 or 2."
    }
}

# Search for a .uplugin file in the current directory and subdirectories
$upluginFile = Get-ChildItem -Path . -Recurse -Filter *.uplugin | Select-Object -First 1

# Check if a .uplugin file was found
if ($upluginFile) {
    # Get the full path of the .uplugin file
    $upluginFullPath = $upluginFile.FullName

    # Run the command with the found .uplugin file
    & $RunUATPath BuildPlugin -plugin="$upluginFullPath" -Package="$($PWD)\package"
} else {
    Write-Host "No .uplugin file found."
}

# Keep the terminal open
Read-Host -Prompt "Press Enter to exit"
