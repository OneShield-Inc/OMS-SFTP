using SftpIntegration;
using WinSCP;

//For Prod
//var sftp = new SftpService(
//    host: "sftp.example.com",
//    username: "testuser",
//    password: "testpassword",
//    sshHostKeyFingerprint: "ssh-rsa 2048 xx:xx:xx:xx:xx:..." // get from OMS Ops
//);

// For NonProd or TestEnv
var sftp = new SftpService(
    host: "sftp.example.com",
    username: "testuser",
    password: "testpassword",
    sshHostKeyPolicy: SshHostKeyPolicy.GiveUpSecurityAndAcceptAny
);

// Upload a file
sftp.UploadFile(@"C:\Local\File.txt", "/remote/path/File.txt");

// Download a file
sftp.DownloadFile("/remote/path/File.txt", @"C:\Local\File_Downloaded.txt");

// Delete a file
sftp.DeleteFile("/remote/path/File.txt");

// Transfer (Move) a file
sftp.TransferFile("/remote/incoming/File2.txt", "/remote/processed/File2.txt");

