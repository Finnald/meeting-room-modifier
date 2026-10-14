# \[DRAFT\] SD \- Modifying access to meeting rooms

## Using the script

1. Download the script and open PowerShell
2. Run the command `Connect-ExchangeOnline`
3. In PowerShell, navigate to the directory that the script is stored in. Run: `.\meeting_room_helper.ps1`
4. Enter the meeting room name. This will fetch the first object it finds that matches the search.
5. You will then be given the option to change its attributes. If you leave an attribute blank and hit enter, it will not change it.
6. After confirming, it will apply the changes to the meeting room and show you the new changes.