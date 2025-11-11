param(
    [string]$WinScpPath = ".\WinSCPnet.dll"
)

# Load WinSCP assembly
Add-Type -Path $WinScpPath

function New-SftpSession {
    param(
        [string]$Host,
        [string]$Username,
        [string]$Password,
        [string]$HostKeyFingerprint
    )

	if ([string]::IsNullOrEmpty($HostKeyFingerprint)) {
        $sessionOptions = New-Object WinSCP.SessionOptions -Property @{
			Protocol         = [WinSCP.Protocol]::Sftp
			HostName         = $Host
            PortNumber       = 8222
			UserName         = $Username
			Password         = $Password
			SshHostKeyPolicy = [WinSCP.SshHostKeyPolicy]::GiveUpSecurityAndAcceptAny
		}
    } else {
        $sessionOptions = New-Object WinSCP.SessionOptions -Property @{
			Protocol              = [WinSCP.Protocol]::Sftp
			HostName              = $Host
            PortNumber            = 8222
			UserName              = $Username
			Password              = $Password
			SshHostKeyFingerprint = $HostKeyFingerprint
		}
    }

    $session = New-Object WinSCP.Session
    $session.Open($sessionOptions)
    return $session
}

function Upload-File {
    param(
        [string]$Host,
        [string]$Username,
        [string]$Password,
        [string]$HostKeyFingerprint,
        [string]$LocalPath,
        [string]$RemotePath
    )

    $session = New-SftpSession -Host $Host -Username $Username -Password $Password -HostKeyFingerprint $HostKeyFingerprint

    try {
        $transferOptions = New-Object WinSCP.TransferOptions
        $transferOptions.TransferMode = [WinSCP.TransferMode]::Binary

        $result = $session.PutFiles($LocalPath, $RemotePath, $false, $transferOptions)
        $result.Check()
        Write-Host "Uploaded: $LocalPath → $RemotePath"
    }
    finally {
        $session.Dispose()
    }
}

function Download-File {
    param(
        [string]$Host,
        [string]$Username,
        [string]$Password,
        [string]$HostKeyFingerprint,
        [string]$RemotePath,
        [string]$LocalPath
    )

    $session = New-SftpSession -Host $Host -Username $Username -Password $Password -HostKeyFingerprint $HostKeyFingerprint

    try {
        $transferOptions = New-Object WinSCP.TransferOptions
        $transferOptions.TransferMode = [WinSCP.TransferMode]::Binary

        $result = $session.GetFiles($RemotePath, $LocalPath, $false, $transferOptions)
        $result.Check()
        Write-Host "Downloaded: $RemotePath → $LocalPath"
    }
    finally {
        $session.Dispose()
    }
}

function Delete-File {
    param(
        [string]$Host,
        [string]$Username,
        [string]$Password,
        [string]$HostKeyFingerprint,
        [string]$RemotePath
    )

    $session = New-SftpSession -Host $Host -Username $Username -Password $Password -HostKeyFingerprint $HostKeyFingerprint

    try {
        $session.RemoveFiles($RemotePath)
        Write-Host "Deleted: $RemotePath"
    }
    finally {
        $session.Dispose()
    }
}

function Transfer-File {
    param(
        [string]$Host,
        [string]$Username,
        [string]$Password,
        [string]$HostKeyFingerprint,
        [string]$SourcePath,
        [string]$DestinationPath
    )

    $session = New-SftpSession -Host $Host -Username $Username -Password $Password -HostKeyFingerprint $HostKeyFingerprint

    try {
        $command = "mv `"$SourcePath`" `"$DestinationPath`""
        $session.ExecuteCommand($command)
        Write-Host "Transferred file: $SourcePath → $DestinationPath"
    }
    finally {
        $session.Dispose()
    }
}
