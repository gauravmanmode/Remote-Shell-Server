# Set FTP server details
$ftpServer = "ftpupload.net"
$ftpUsername = "b4_35142607"
$ftpPassword = "Saurabh@123"

# Set the local and remote file paths
$localFileName1 = "output.txt"
$remoteFileName = "/output.txt"  # Adjust the path as needed

# Read the content of the local file
$fileContent = Get-Content -Path $localFileName1

# Create an FTPWebRequest object
$ftpRequest = [System.Net.FtpWebRequest]::Create("ftp://$ftpServer$remoteFileName")
$ftpRequest.Credentials = New-Object System.Net.NetworkCredential($ftpUsername, $ftpPassword)
$ftpRequest.Method = [System.Net.WebRequestMethods+Ftp]::UploadFile

# Convert the file content to bytes
$fileBytes = [System.Text.Encoding]::UTF8.GetBytes($fileContent)

# Set the request content
$ftpRequest.ContentLength = $fileBytes.Length
$requestStream = $ftpRequest.GetRequestStream()
$requestStream.Write($fileBytes, 0, $fileBytes.Length)
$requestStream.Close()

# Get the FTP server's response
$response = $ftpRequest.GetResponse()
$response.Close()

Write-Host "File uploaded successfully to FTP server."
