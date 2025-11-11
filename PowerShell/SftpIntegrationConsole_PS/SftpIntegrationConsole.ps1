# Load all SFTP functions
. .\SftpService.ps1

# --- Configuration ---
$HostName = "sftp.example.com"
$Username = "testuser"
$Password = "testpassword"
$Fingerprint = ""

Write-Host "=== SFTP Integration Console (PowerShell) ===" -ForegroundColor Cyan

# Upload
Upload-File -Host $HostName -Username $Username -Password $Password -HostKeyFingerprint $Fingerprint `
    -LocalPath "C:\Local\File1.txt" -RemotePath "/remote/incoming/File1.txt"

# Download
Download-File -Host $HostName -Username $Username -Password $Password -HostKeyFingerprint $Fingerprint `
    -RemotePath "/remote/incoming/File1.txt" -LocalPath "C:\Local\Downloaded\File1.txt"

# Transfer
Transfer-File -Host $HostName -Username $Username -Password $Password -HostKeyFingerprint $Fingerprint `
    -SourcePath "/remote/incoming/File1.txt" -DestinationPath "/remote/processed/File1.txt"

# Delete
Delete-File -Host $HostName -Username $Username -Password $Password -HostKeyFingerprint $Fingerprint `
    -RemotePath "/remote/processed/File1.txt"

Write-Host "All operations completed successfully." -ForegroundColor Green
