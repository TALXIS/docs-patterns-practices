$filePath = "../Scripts.UI/TS/build/main.js"
$dataXmlFilePath = "Declarations\WebResources\udpp_fileexamplename.data.xml"
$destinationFolder = "Declarations\WebResources"
#$fileDisplayName = [System.IO.Path]::GetFileName($filePath)
#$fileName = $fileDisplayName -replace '[\p{P}\p{Zs}]', ''
$fileName = [System.IO.Path]::GetFileName($filePath)
$fileDisplayName = $fileName 
$newDataXmlFilePath = "Declarations\WebResources\udpp_$fileName.data.xml"

$guid = [guid]::NewGuid().ToString()
$guidUpper = $guid.ToUpper()

$content = Get-Content -Path $dataXmlFilePath -Raw

$content = $content -replace "fileexamplename", $fileName
$content = $content -replace "fileexampledisplayname", $fileDisplayName
$content = $content -replace "wridexamplecapital", $guidUpper
$content = $content -replace "wridexample", $guid

Remove-Item -Path $dataXmlFilePath

Set-Content -Path $newDataXmlFilePath -Value $content

$fileNewNoExtName = "udpp_$fileName"
$destinationPath = Join-Path $destinationFolder $fileNewNoExtName

Copy-Item -Path $filePath -Destination $destinationPath

