# drafts-export-to-markdown

# Define the path to your JSON file
$jsonFilePath = "./2024-07-08-draftsExport.json"

# Read and parse the JSON file
$jsonContent = Get-Content $jsonFilePath -Raw | ConvertFrom-Json

# Process each entry in the JSON
foreach ($entry in $jsonContent)
{
	# Extract relevant fields from the entry
	$uuid = $entry.uuid
	$created_at = $(Get-Date ($entry.created_at).ToLocalTime() -Format yyyy-MM-ddTHH:mm:sszzz)
	$modified_at = $(Get-Date ($entry.modified_at).ToLocalTime() -Format yyyy-MM-ddTHH:mm:sszzz)
	$content = $entry.content
	$created_longitude = $entry.created_longitude
	$created_latitude = $entry.created_latitude

	# Generate the filename using created_at date and the first part of uuid
	$created_date = $(Get-Date $entry.created_at -Format yyyy-MM-dd)
	$uuid_short = $uuid.Substring(0, 8)  # First part of UUID
	$fileName = "$created_date $uuid_short.md"

	# Construct the Markdown content with YAML front matter
	$markdownContent = @"
---
created: $created_at
updated: $modified_at
reviewed: 
tags:
  - draft
  - import/drafts
location: "$created_latitude,$created_longitude"
  
---

$content
"@

	# Define the output path for the Markdown file
	$outputFilePath = "./drafts_output/$fileName"

	# Save the Markdown content to the file
	$markdownContent | Out-File -FilePath $outputFilePath -Encoding utf8
}

Write-Host "Markdown files created successfully."

