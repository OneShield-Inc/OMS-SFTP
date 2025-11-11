using WinSCP;

namespace SftpIntegration
{
    public class SftpService
    {
        private readonly SessionOptions _sessionOptions;

        public SftpService(string host, string username, string password, SshHostKeyPolicy sshHostKeyPolicy)
        {
            _sessionOptions = new SessionOptions
            {
                Protocol = Protocol.Sftp,
                HostName = host,
                PortNumber = 8222,
                UserName = username,
                Password = password,
                SshHostKeyPolicy = sshHostKeyPolicy  // Use a real fingerprint in production
            };
        }

        public SftpService(string host, string username, string password, string sshHostKeyFingerprint)
        {
            _sessionOptions = new SessionOptions
            {
                Protocol = Protocol.Sftp,
                HostName = host,
                PortNumber = 8222,
                UserName = username,
                Password = password,
                SshHostKeyFingerprint = sshHostKeyFingerprint
            };
        }

        /// <summary>
        /// Uploads a file to the SFTP server.
        /// </summary>
        public void UploadFile(string localPath, string remotePath)
        {
            using (Session session = new Session())
            {
                session.Open(_sessionOptions);

                TransferOptions transferOptions = new TransferOptions
                {
                    TransferMode = TransferMode.Binary
                };

                TransferOperationResult result = session.PutFiles(localPath, remotePath, false, transferOptions);

                result.Check(); // throws exception if transfer failed
                Console.WriteLine($"Uploaded: {localPath} → {remotePath}");
            }
        }

        /// <summary>
        /// Downloads a file from the SFTP server.
        /// </summary>
        public void DownloadFile(string remotePath, string localPath)
        {
            using (Session session = new Session())
            {
                session.Open(_sessionOptions);

                TransferOptions transferOptions = new TransferOptions
                {
                    TransferMode = TransferMode.Binary
                };

                TransferOperationResult result = session.GetFiles(remotePath, localPath, false, transferOptions);

                result.Check();
                Console.WriteLine($"Downloaded: {remotePath} → {localPath}");
            }
        }

        /// <summary>
        /// Deletes a file from the SFTP server.
        /// </summary>
        public void DeleteFile(string remotePath)
        {
            using (Session session = new Session())
            {
                session.Open(_sessionOptions);

                session.RemoveFiles(remotePath);
                Console.WriteLine($"Deleted: {remotePath}");
            }
        }

        /// <summary>
        /// Transfers (moves) a file from one folder to another on the same SFTP server.
        /// </summary>
        public void TransferFile(string sourceFilePath, string destinationFilePath)
        {
            using (Session session = new Session())
            {
                session.Open(_sessionOptions);

                // Move command (rename acts as move if different folder)
                string command = $"mv \"{sourceFilePath}\" \"{destinationFilePath}\"";
                session.ExecuteCommand(command);

                Console.WriteLine($"Transferred file: {sourceFilePath} → {destinationFilePath}");
            }
        }
    }
}

