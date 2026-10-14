Clear-Host

Write-Host "Please connect to ExchangeOnline using Connect-ExchangeOnline before using this! Refer to the following KB for more info: https://rac-wa.atlassian.net/wiki/x/TwEIzQ" -ForegroundColor Yellow

$search = Read-Host "Enter Meeting Room name"

$room = Get-Mailbox "*$search*" -RecipientTypeDetails RoomMailbox
$calendar = Get-CalendarProcessing -Identity $room.Identity

Get-CalendarProcessing -Identity $calendar.Identity | Select-Object `
    AllBookinpolicy, 
allrequestinpolicy, 
allrequestoutofpolicy,
bookinpolicy,
resourcedelegates

$action = Read-Host "Change attributes? (y/n)"



if ($action -eq "y") {
    
    Write-Host "Press enter to not make any change. 
1 and 0 refer to True and False respectively. 
BookInPolicy and ResourceDelegates must separate each value with a comma.`n" -ForegroundColor Yellow

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

    Write-Host "Confirmation:
    AllBookInPolicy`t: $allbookin
    AllRequestInPolicy`t: $allrequestin
    AllRequestOutPolicy`t: $allrequestout
    BookInPolicy`t: $bookin
    ResourceDelegates`t: $resourcedelegates" -ForegroundColor Yellow

    $continue = Read-Host "Continue? (y/n)"
    
    if ($continue -eq "y") {

        Write-Host "Applying..." -ForegroundColor Yellow

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
