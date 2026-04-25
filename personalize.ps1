# Personalize github-readme-stats for Priyan2520 fork
# Run this script from the root of the cloned repository

Write-Host "Personalizing files for Priyan2520..." -ForegroundColor Green

# Define replacements
$replacements = @(
    @{ Old = "anuraghazra"; New = "Priyan2520" }
    @{ Old = "Anurag Hazra"; New = "Priya Nakate" }
    @{ Old = "hazru.anurag@gmail.com"; New = "priyanakate2026@gmail.com" }
    @{ Old = "https://github.com/anuraghazra/github-readme-stats"; New = "https://github.com/Priyan2520/github-readme-stats" }
    @{ Old = "git://github.com/anuraghazra/github-readme-stats.git"; New = "git://github.com/Priyan2520/github-readme-stats.git" }
)

# File extensions to process (skip binary, node_modules, .git)
$includeExtensions = @(".md", ".json", ".js", ".yml", ".yaml", ".html", ".txt", ".ts", ".jsx", ".tsx", ".css", ".scss", ".xml", ".svg")
$excludeDirs = @("node_modules", ".git", "dist", "build", "coverage")

# Get all files recursively, skip excluded directories
$files = Get-ChildItem -Recurse -File | Where-Object {
    $exclude = $false
    foreach ($dir in $excludeDirs) {
        if ($_.FullName -like "*\$dir\*") { $exclude = $true; break }
    }
    if ($exclude) { return $false }
    $ext = $_.Extension.ToLower()
    return $includeExtensions -contains $ext
}

$changedFiles = @()

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    $original = $content
    foreach ($rep in $replacements) {
        $content = $content -replace $rep.Old, $rep.New
    }
    if ($content -ne $original) {
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
        $changedFiles += $file.FullName
        Write-Host "Modified: $($file.FullName)" -ForegroundColor Yellow
    }
}

# Special handling for LICENSE file (if exists)
$licensePath = Join-Path $PWD "LICENSE"
if (Test-Path $licensePath) {
    $licenseContent = Get-Content -Path $licensePath -Raw -Encoding UTF8
    $newLicense = $licenseContent -replace "Copyright \(c\) 2020 Anurag Hazra", "Copyright (c) 2026 Priya Nakate"
    if ($newLicense -ne $licenseContent) {
        Set-Content -Path $licensePath -Value $newLicense -Encoding UTF8 -NoNewline
        $changedFiles += $licensePath
        Write-Host "Modified LICENSE" -ForegroundColor Yellow
    }
}

Write-Host "`nPersonalization complete. Modified $($changedFiles.Count) files." -ForegroundColor Green

# Reminder about package-lock.json
Write-Host "`nIMPORTANT: Delete package-lock.json and run 'npm install' to regenerate it." -ForegroundColor Cyan