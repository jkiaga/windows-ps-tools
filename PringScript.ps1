#prompt user to enter ip address
param (                     #basically the parameter section
    [string]$IPAddress = (  #defines a parameter of type String
    #read host prompts the user to enter ip address
    Read-Host "Enter the IP address")
)
#defines a function called called 'Start-PingLoop'
function Start-PingLoop {
    while ($true) {
        $timestamp = Get-Date -Format "HH:mm:ss"
        $response = Test-Connection -ComputerName $IPAddress -Count 1 -ErrorAction SilentlyContinue

        if ($response -eq $null) {
            Write-Host "$timestamp Request Timed Out" 
        } elseif ($response.Status -eq "DestinationHostUnreachable") {
            Write-Host "$timestamp Destination Host Unreachable"
        } elseif ($response.Status -eq "GeneralFailure") {
            Write-Host "$timestamp General Failure"
        } else {
            Write-Host "$timestamp $($response.Address) $($response.ResponseTime)ms TTL=$($response.TimeToLive)"
        }

        Start-Sleep -Seconds 1
    }
}

do {
    Start-PingLoop
    Write-Host "Press Enter to restart the ping loop or Ctrl+C to exit..."
    $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Key
} while ($key -eq "Enter")

Write-Host "Exiting the script."
