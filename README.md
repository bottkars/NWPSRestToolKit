# NWPSRestToolKit
Powershell Toolkit for Networker Rest API 
###about
the Goal of the Networker Powershell Toolkit is to make a Networker Admin´s live on windows easier  
teh Toolkit should support Pielining of commands, and combine the value of Powershell with the strength of the RestAPI


###requirements
in order to run the commands, you need to unrestrict executionpolicy.
also, make sure to unblock the zipfile if you download the modules as zip and not via git ( unblock-file or right click in explorer )
open a powershell as admin and run
```powershell
Set-ExecutionPolicy -ExecutionPolicy Unrestricted
```

## installation  
The Modules are loaded via Import-Module NWPSRestToolKit
The Module sudirectories are based on the methods and functions , eg GET,PUT,POST..., errors.

use this Automatic downloader to install NWPSRestToolKit:  
(COPY TEXT INTO A  POWERSHELL)
```Powershell
$Uri="https://gist.githubusercontent.com/bottkars/a555ee59c63b65dbb38f027a547030ba/raw/install-nwpsresttoolkit.ps1"
$DownloadLocation = "$Env:USERPROFILE\Downloads"
$File = Split-Path -Leaf $Uri
$OutFile = Join-Path $DownloadLocation $File
Invoke-WebRequest -Uri $Uri -OutFile $OutFile
Unblock-File -Path $Outfile
Set-Location $DownloadLocation
.\install-NWPSRestToolKit.ps1 -Installpath [replacewithyourdestination]
```
## alternative installation  
if not using the Downloader, i Recommend cloning into the modules using and do regular pulls for update rather tan downloading the zip. this also eliminates the need for unblocking the zip archive !!! )

consider https://desktop.github.com/ for windows

import the modules
```powershell
import-module \path-to-moduledir\NWPSRestToolKit.psd1
```

test the commnds from the module :-)  
##Test
try to connect to your Networker Server
![image](https://cloud.githubusercontent.com/assets/8255007/16623331/c5bf023c-439d-11e6-9186-e271953b3285.png)

the cmdlet shall Respond with the servername and operating sytem of the server

## Examples  
View Vbackups of a Client Using ressourceID od the Client

![image](https://cloud.githubusercontent.com/assets/8255007/16623185/37dec11e-439d-11e6-8484-28f60357836a.png)


View Backups of a Client using Pipeline Support

![image](https://cloud.githubusercontent.com/assets/8255007/16623088/d43bd0ca-439c-11e6-85cc-5cac73e6ac8c.png)

