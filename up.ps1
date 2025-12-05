# ===========================================
# Generate README.md with image gallery
# Flat folder structure (no nesting)
# ===========================================

$githubRepoUrl = "https://github.com/ryokr/Share"   # << CHANGE THIS
$branch = "main"

$imageExtensions = ".png", ".jpg", ".jpeg", ".gif", ".webp", ".svg"
$root = Get-Location
$readmePath = "$root/README.md"

$builder = @()
$builder += "# Image Gallery"
$builder += "---`n"

# Get only top-level directories
$folders = Get-ChildItem -Directory

foreach ($folder in $folders) {

    # Find images inside this folder
    $images = Get-ChildItem $folder.FullName -File | Where-Object {
        $imageExtensions -contains $_.Extension.ToLower()
    }

    if ($images.Count -eq 0) { continue }  # skip empty folders

    $folderName = $folder.Name
    $builder += "## 📂 $folderName"
    $builder += ""

    foreach ($img in $images) {
        $relativePath = ($img.FullName.Replace("$root\", "")).Replace("\", "/")
        $githubUrl = "$githubRepoUrl/blob/$branch/$relativePath"

        $builder += "<a href='$githubUrl' target='_blank'>"
        $builder += "<img src='$relativePath' width='220' style='border-radius:10px;margin:8px;box-shadow:0 2px 6px rgba(0,0,0,0.2);'/>"
        $builder += "</a>"
    }

    $builder += "`n---`n"
}

$builder -join "`n" | Set-Content $readmePath -Encoding UTF8

Write-Host "README.md generated!" -ForegroundColor Green
