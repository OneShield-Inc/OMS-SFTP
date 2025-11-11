import paramiko
import os

class SftpService:
    def __init__(self, host, username, password=None, port=8222, private_key_path=None):
        """
        Initialize connection details.
        """
        self.host = host
        self.port = port
        self.username = username
        self.password = password
        self.private_key_path = private_key_path

    def _connect(self):
        """
        Establish and return an SFTP connection.
        """
        transport = paramiko.Transport((self.host, self.port))
        
        if self.private_key_path:
            private_key = paramiko.RSAKey.from_private_key_file(self.private_key_path)
            transport.connect(username=self.username, pkey=private_key)
        else:
            transport.connect(username=self.username, password=self.password)
        
        return paramiko.SFTPClient.from_transport(transport)

    def upload_file(self, local_path, remote_path):
        """
        Upload a local file to the SFTP server.
        """
        with self._connect() as sftp:
            sftp.put(local_path, remote_path)
            print(f"Uploaded: {local_path} → {remote_path}")

    def download_file(self, remote_path, local_path):
        """
        Download a file from the SFTP server to local machine.
        """
        os.makedirs(os.path.dirname(local_path), exist_ok=True)

        with self._connect() as sftp:
            sftp.get(remote_path, local_path)
            print(f"Downloaded: {remote_path} → {local_path}")

    def delete_file(self, remote_path):
        """
        Delete a file from the SFTP server.
        """
        with self._connect() as sftp:
            sftp.remove(remote_path)
            print(f"Deleted: {remote_path}")

    def transfer_file(self, source_file_path, destination_file_path):
        """
        Move (rename) a file from one remote folder to another on the same SFTP server.
        """
        with self._connect() as sftp:
            sftp.rename(source_file_path, destination_file_path)
            print(f"Transferred file: {source_file_path} → {destination_file_path}")
