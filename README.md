# StatePassiveInstrumentationNode
State Passive Instrumentation Node (SPIN) - PowerShell Version

Rough proof of concept for PowerShell backend.  

To test:

Run New_Spin.SQL on your SQL server to create SQL DB.

Edit $ConnectionString variable in both ImportNodesFromAD.ps1 and PingUpdate.ps1.

Run ImportNodesFromAD.ps1 to add all your servers from AD to the DB.

Run PingUpdate.ps1 to ping all servers and update the DB--this could be configured to either loop or run as a scheduled task.

Needs web front end.
