##########################################
# 888holdings Scripting home assignment - Nahum Ella
# this script queries the DogAPI - https://dog.ceo/api/
# according to assignment requierments.

# examples:
# Get the sub-breeds of Hound:
# .\DogAPI.ps1 -Breed Hound -List

# Get a picture of akita:
# .\DogAPI.ps1 -Breed akita -Image
##########################################


param (
    # Breed name parameter (mandatory)
    [Parameter(Mandatory=$true)]
    [string]
    $Breed,

    # get sub-breed parameter
    [switch]
    $List,

    # count sub-breed parameter
    [switch]
    $Count,

    # download image of breed parameter
    [switch]
    $Image
)

# Helper function for querying REST Api - can be in use for other scripts
function QueryRestAPI ([string]$Query, $BaseURI = "https://dog.ceo/api/") {
    # BaseURI variable was created for future use with other API's.
    $URI = $BaseURI + $Query
    Invoke-RestMethod -Method GET -Uri $URI
}

# Get the result for the selected Breed to a variable,
# to make sure you can query the API and that kind of breed exists.
# if not - throw terminating error and exit script.
# By default, Invoke-RestMethod throws a terminating exception that can be catched.
try {
    Write-Host "Querying DogAPI for $Breed" -ForegroundColor Yellow
    $result = QueryRestAPI "breed/$Breed/list"
    Write-Host "Found breed $Breed" -ForegroundColor Yellow
}
catch {
    if ($_.ErrorDetails.Message -like "*breed not found*") {
        throw "Breed $Breed could not be found"
    }
    else {
        throw "Error happend while querying the DogAPI - $_"
    }
}

# Check for sub-breed if mentioned the swtich parameter
if ($List) {

    # if sub-breeds exists, $result will have a Message property with a list of sub breeds
    if ($result.message.count -ne 0) {
        Write-Host "sub-breeds:" -ForegroundColor Yellow
        $result.message
    }
    else {
        Write-Host "No sub-breeds found for $Breed" -ForegroundColor Yellow
    }
 
}

# Print out total number of sub-breeds (only if there is some )
if ($Count) {
    if ($result.message.count -ne 0) {
        Write-Host "Total count of sub-breeds: $($result.message.count)" -ForegroundColor Yellow
    }
}

# If parameter is used - download a random picture of the breed,
# save the picture to %temp%, and open it
if ($Image) {
    # Path of the pic file
    $picPath = "$env:TEMP\$Breed.jpg"

    # Get a random picture for the breed, and extract the URI
    Write-Host "Downloading a random picture of $Breed" -ForegroundColor Yellow
    $picURI = QueryRestAPI "breed/$Breed/images/random" | Select-Object -ExpandProperty message

    # download the picture to %temp%
    Invoke-WebRequest -Uri $picURI -OutFile $picPath

    # open the pictre using your default picture viewer
    Start-Process $picPath

    # Wait for the picture to be started by the picture viewer
    Start-Sleep -Seconds 5

    # So it can be deleted (no need to trash your pc :) )
    Remove-Item $picPath -Force
}