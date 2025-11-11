from sftp_service import SftpService

def main():
    print("=== SFTP Integration Console ===")

    sftp = SftpService(
        host="sftp.example.com",
        username="testuser",
        password="testpassword"
    )

    sftp.upload_file("C:/Local/File1.txt", "/remote/incoming/File1.txt")
    sftp.transfer_file("/remote/incoming/File1.txt", "/remote/processed/File1.txt")
    sftp.download_file("/remote/processed/File1.txt", "C:/Local/Downloaded/File1.txt")
    sftp.delete_file("/remote/processed/File1.txt")

    print("All operations completed successfully.")

if __name__ == "__main__":
    main()
