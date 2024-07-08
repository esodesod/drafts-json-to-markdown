# Path to the directory containing the Markdown files
$directoryPath = "./drafts_output"

# Get all Markdown files in the directory
$markdownFiles = Get-ChildItem -Path $directoryPath -Recurse -Filter *.md

foreach ($file in $markdownFiles) {
    # Read the content of the file
    $content = Get-Content -Path $file.FullName

    # Extract the "created" value
    $createdLine = $content | Select-String -Pattern "^created:\s*(.+)$"
    $modifiedLine = $content | Select-String -Pattern "^updated:\s*(.+)$"

    if ($createdLine) {
        $createdValue = $createdLine.Matches.Groups[1].Value
        $createdDateTime = [datetime]::Parse($createdValue)

        # Set the file creation time
        [System.IO.File]::SetCreationTime($file.FullName, $createdDateTime)

        Write-Host "Updated file: $($file.FullName) with created: $createdDateTime"
    } else {
        Write-Host "No 'created' value found in file: $($file.FullName)"
    }
    if ($modifiedLine) {
        $modifiedValue = $modifiedLine.Matches.Groups[1].Value
        $modifiedDateTime = [datetime]::Parse($modifiedValue)

        # Set the file last write time (based on updated/modified)
        [System.IO.File]::SetLastWriteTime($file.FullName, $modifiedDateTime)

        Write-Host "Updated file: $($file.FullName) with updated: $modifiedDateTime"
    } else {
        Write-Host "No 'created' value found in file: $($file.FullName)"
    }
}