Clear-Host

Write-Host "Please connect to ExchangeOnline using Connect-ExchangeOnline before using this! Refer to the following KB for more info: https://rac-wa.atlassian.net/wiki/x/TwEIzQ" -ForegroundColor Yellow

# will search for the specific meeting room. $calendar line needed for bookin and resource delegates
$search = Read-Host "Enter Meeting Room name"
$room = Get-Mailbox "*$search*" -RecipientTypeDetails RoomMailbox
$calendar = Get-CalendarProcessing -Identity $room.Identity

# will show the object to the user first before modifying
Get-CalendarProcessing -Identity $calendar.Identity | Select-Object `
    AllBookinpolicy, 
allrequestinpolicy, 
allrequestoutofpolicy,
bookinpolicy,
resourcedelegates

$action = Read-Host "Change attributes? (y/n)"

# if the user wants to change the values, they will continue down this path.
# could probably be made more efficient and readable
if ($action -eq "y") {
    
    # instructions
    Write-Host "Press enter to not make any change. 
1 and 0 refer to True and False respectively. 
BookInPolicy and ResourceDelegates must separate each value with a comma.`n" -ForegroundColor Yellow

    # reads the input, if the user hits enter, will use the current value
    [int]$allbookin = Read-Host "AllBookInPolicy (1/0)"
    if ($allbookin -eq "") {
        $allbookin = $calendar.AllBookInPolicy
    }

    [int]$allrequestin = Read-Host "AllRequestInPolicy (1/0)"
    if ($allrequestin -eq "") {
        $allrequestin = $calendar.AllRequestInPolicy
    }

    [int]$allrequestout = Read-Host "AllRequestOutPolicy (1/0)"
    if ($allrequestout -eq "") {
        $allrequestout = $calendar.AllRequestOutPolicy
    }

    # these two will split and trim the string input so it becomes an array
    $bookin = Read-Host 'BookInPolicy (eg user1@rac.com.au, user2@rac.com.au)'
    if ($bookin -eq "") {
        $bookin = $calendar.BookInPolicy
    }
    else {
        $bookin = $bookin.Split(',').Trim()
    }

    $resourcedelegates = Read-Host 'ResourceDelegates (eg user1@rac.com.au, user2@rac.com.au)'
    if ($resourcedelegates -eq "") {
        $resourcedelegates = $calendar.ResourceDelegates
    }
    else {
        $resourcedelegates = $resourcedelegates.Split(',').Trim()
    }

    # display what the final object will look like
    Write-Host "Confirmation:
    AllBookInPolicy`t: $allbookin
    AllRequestInPolicy`t: $allrequestin
    AllRequestOutPolicy`t: $allrequestout
    BookInPolicy`t: $bookin
    ResourceDelegates`t: $resourcedelegates" -ForegroundColor Yellow

    # confirmation
    $continue = Read-Host "Continue? (y/n)"
    
    # will go ahead if the user wants to continue
    if ($continue -eq "y") {

        Write-Host "Applying..." -ForegroundColor Yellow

        # applies the changes, then shows the result
        Set-CalendarProcessing -Identity $calendar.Identity `
            -AllBookInPolicy $allbookin `
            -allrequestinpolicy $allrequestin `
            -allrequestoutofpolicy $allrequestout `
            -bookinpolicy $bookin `
            -resourcedelegates $resourcedelegates `
            # -WhatIf

        Write-Host "Result:" -ForegroundColor Yellow
        Get-CalendarProcessing -Identity $calendar.Identity | Select-Object `
            AllBookinpolicy, 
        allrequestinpolicy, 
        allrequestoutofpolicy,
        bookinpolicy,
        resourcedelegates
    }
       
}
