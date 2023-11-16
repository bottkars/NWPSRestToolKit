# NWPSRestToolKit

[Dell Developer API Marketplace](https://developer.dell.com/apis/2378/versions/v3/docs/tutorials/Tutorial-1APIBasics.md)  
Powershell Toolkit for Networker Rest API  
### about
the Goal of the Networker Powershell Toolkit is to make a Networker Admin´s live on windows easier  
teh Toolkit should support Pielining of commands, and combine the value of Powershell with the strength of the RestAPI




install the modules from psgallery
```powershell
Install-Module NWPSRestToolKit
```

test the commnds from the module :-)  
##Test
try to connect to your Networker Server
![image](https://cloud.githubusercontent.com/assets/8255007/16623331/c5bf023c-439d-11e6-9186-e271953b3285.png)

the cmdlet shall Respond with the servername and operating sytem of the server

## Examples  
View backups of a Client Using ressourceID od the Client

![image](https://cloud.githubusercontent.com/assets/8255007/16623185/37dec11e-439d-11e6-8484-28f60357836a.png)


View Backups of a Client using Pipeline Support
![image](https://cloud.githubusercontent.com/assets/8255007/16623088/d43bd0ca-439c-11e6-85cc-5cac73e6ac8c.png)

Getting Workflows from a Policy
![image](https://cloud.githubusercontent.com/assets/8255007/16629401/cf8e4bde-43b5-11e6-86ba-585abd6ed13c.png)


Starting a Workflow from Pipeline
![image](https://cloud.githubusercontent.com/assets/8255007/16629296/95f61686-43b5-11e6-9a57-feeb75483c6b.png)

