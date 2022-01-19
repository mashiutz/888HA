##########################################
# 888holdings PowerShell home assignment - Nahum Ella
# this script monitors the notepad.exe process
# according to assignment requierments.

# CSV file path, maintenance file path,
# and script execution duration all have defaults,
# but can be changed via script parameters.

# I have added a small csv writer function,
# trying to make the code a bit cleaner.

# use the -SecondPart or -BonusPart switch
# parameters when running the script to
# run the assignemnt's second part and bonus part

# examples:
# run main script with second part:
# .\NotepadWatcher -SecondPart

# run main script with bonus part:
# .\NotepadWatcher -BonusPart

# run main with both parts, and change the csv file to the current user desktop folder
# .\NotepadWatcher -SecondPart -BonusPart -CSVFile $env:USERPROFILE\Desktop\NotepadWatcher.csv
##########################################

param (
    # Parameter for CSV file path (by default - C:\Windows\Temp\NotepadWatcher.csv)
    [string]
    $CSVFile = "$env:windir\temp\NotepadWatcher.csv",

    # Parameter for maintenance file path (by default - c:\tmp\maintenance.txt)
    [string]
    $MaintenanceFile = "c:\tmp\maintenance.txt",

    # Parameter for timing the script execution (by default - 5)
    [int]
    $ScriptTimeMinutes = 5,

    # Switch parameter for the assignment's second part
    [switch]
    $SecondPart = $false,

    [switch]
    $BonusPart = $false
)

# CSV writer function definition
# a helper function to write to CSV file and console host
function WriteCSV ($Message , $Path = $CSVFile) {
    # Create the object properties to be exported to the CSV
    $DateTimeStr = Get-Date -Format "dd-MM-yyyy HH:mm:ss"
    $ProcessStatus = $Message

    # Create the object
    $obj = New-Object -TypeName psobject -Property @{
        Date    = $DateTimeStr
        Message = $ProcessStatus
    }

    # Export the object to CSV
    $obj | Export-Csv -Path $path -NoTypeInformation -Append -Force

    Write-Host "$DateTimeStr`t$Message"
}

# Create a DateTime object with future time of now + $ScriptTimeMinutes for script running time
$ScriptEndTime = (Get-Date).AddMinutes($ScriptTimeMinutes)

# do-while run for $ScriptTimeMinutes minutes
do {
    # Check if Notepad process is running.
    # Exception are being suppressed so errors wont show in the console (no need to catch exceptions for Get-Process command)
    if ($null -eq (Get-Process -Name Notepad -ErrorAction SilentlyContinue)) {
        # check if maintenance file exists, start it otherwise (if not in maintenance)
        if (Test-Path $MaintenanceFile) {
            WriteCSV "We are under maintenance mode!"
        }
        else {
            try {
                Start-Process notepad -ErrorAction Stop
                WriteCSV "Notepad was started"
            }
            catch {
                WriteCSV "Could not start notepad - $_"            
            }
        }
    }
    else {
        WriteCSV "Notepad is running"
    }  
    
    Start-Sleep -Seconds 5

} while ( ((Get-Date) -lt $ScriptEndTime) )

# Assignment second part
if ($SecondPart) {
    $InMaintenance = Import-Csv $CSVFile | Where-Object {$_.Message -eq "We are under maintenance mode!"}
    Write-Host "`nMaintenance mode timestamps (total $($InMaintenance.count)):" -ForegroundColor Yellow
    Write-Output $InMaintenance
}

# Assignment bonus part
if ($BonusPart) {
    $AllRows = Import-Csv $CSVFile | Where-Object {$_.Message -eq "Notepad was started"}
    $SelctedRows = $AllRows | Out-GridView -Title "Select lines to export to CSV" -OutputMode Multiple

    # check if the user selected any rows
    # if so, open a save file dialog
    if ($null -ne $SelctedRows) {
        [void][System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")
        $SaveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
        $SaveFileDialog.Filter = "CSV files (*.csv)|*.csv"
       
        $SaveFileDialog.initialDirectory = "c:\"
        
        if ($SaveFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK)
        { $filepath = $SaveFileDialog.FileName }

        $SelectedLines | Export-Csv -Path $filepath -NoTypeInformation -Force
    }
}