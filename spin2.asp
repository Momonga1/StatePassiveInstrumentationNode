<%@ Language=VBScript %>
<html>
<head>
<meta http-equiv="refresh" content="15">
</head>
<body>
<basefont face="Arial">

'This script originally designed and built by P. Tong
'No support or suitability is implied or inferred if you choose to use this script
'support requests and bug reports are coordinated on github repository

<%
dim strUTCTime, objcomputer

ON ERROR RESUME NEXT
strUTCTime = now
Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")
Set colTime = objWMIService.ExecQuery("Select * from Win32_UTCTime")
For Each objTime in colTime
	If Len(objTime.Hour) < 2 Then strZhour = "0" & objTime.Hour Else strZhour = objTime.Hour
	If Len(objTime.Minute) < 2 Then strZminute = "0" & objTime.Minute Else strZminute = objTime.Minute
strUTCtime = strZhour & ":" & strZminute
DCTime = DateAdd("h",-12,now)
DCTime = DateAdd("n",,DCTime)
NEXT
%>


<!---------------------CLOCK TOWER------------------------------->

<table width=100% bgcolor=black>
<tr align=center>
	<td> <font color=white><b><font color=white size=6><% response.Write(formatdatetime(time,4)) %> </td>
	<td> <b><font color=white size=6> <% response.Write(strUTCtime) %> </td>
	<td><font color=white size=6><b><% response.Write(formatdatetime(DCTime,4)) %> </td>
</tr>


<tr align=center>
	<td><b><font color=white size=6>SHANGHAI</td>
	<td><b><font color=white size=6>ZULU</td>
	<td><b><font color=white size=6>EDT</td>
</tr>
</font></table>

<!-----------------END CLOCK TOWER------------------------------->

<table width=100% style='filter:progid:DXImageTransform.Microsoft.Gradient(endColorstr=#ffffff, startColorstr=#000000, gradientType='0');'>
	<tr><td align=right><font size=5 color=red>SPIN</font><font size=5 color=white> | POSTNAME</td></tr>
	<tr><td align=right>State Passive Instrumentation Node</font></td></tr>
</table>

<!-----------------OPEN MASTER TABLES----------------------------->

<table><tr><td valign=top>

<% 
Dim strSite,arrLatency

'------------------------------------------
'------------------------------------------
'------------------------------------------
'------------------------------------------
'------------Returns Latency as strLatency
Dim arrSite(23,1) '--------Set the first number to the total number of sites you are pinging below, starting with 0

ON ERROR RESUME NEXT

arrSite(0,0) = "10.253.240.3"
arrSite(0,1) = "Main State"

arrSite(1,0) = "10.68.38.11"
arrSite(1,1) = "Intranet.State.sbu"

arrSite(2,0) = "10.0.0.0"
arrSite(2,1) = "Servername"

arrSite(3,0) = "10.0.0.0"
arrSite(3,1) = "Servername"

arrSite(4,0) = "10.0.0.0"
arrSite(4,1) = "servername"

arrSite(5,0) = "10.0.0.0"
arrSite(5,1) = "servername"

arrSite(6,0) = "10.0.0.0"
arrSite(6,1) = "Router"

arrSite(7,0) = "10.0.0.0"
arrSite(7,1) = "Switch"

arrSite(8,0) = "10.0.0.0"
arrSite(8,1) = "Switch"


'------------------------------------------
'------------------------------------------
'------------------------------------------
'------------------------------------------


	Set objShell = CreateObject("WScript.Shell")

For x = 0 to Ubound(arrSite,1)


	Set objExec = objShell.Exec("ping -n 1 -w 4000 " & arrSite(x,0))
	


	strPingResults = LCase(objExec.StdOut.ReadAll)
	Err.Clear
	arrLatency = split(strPingResults,"average = ")
        
   
        

	strLatency = arrLatency(1)
	strSpeed = split(strLatency,"ms")
		If strSpeed(0) > 300 then
			strBGColor = "red" 
		elseIf strSpeed(0) > 250 then
			strBGColor = "yellow" 
		else strBGColor = "7dc623"
		End If

	if Err.Number <> 0 Then
		strLatency = "Unreachable"
		strBGColor = "red"
	End If

	
	tblLatency = tblLatency & "<tr height='15'><td align=center bgcolor=white style='filter:progid:DXImageTransform.Microsoft.Gradient(endColorstr=#00aaeed, startColorstr=#ffffff, gradientType='2');'><font size=4>" & arrSite(x,1) & 

"</font></td></tr>" & "<tr><td bgcolor=" & strBGColor & ">" & strLatency & "</td></tr>"

Next

'------------------------------------------
'------------------------------------------
'------------------------------------------
'------------------------------------------
strComputer = array("Servername","Servername","Servername","Servername","Servername","Servername","Servername")



' REM out the strComputer line above and unrem the below lines and set the server OU path if you want the script to find all your servers for you.
'dim strComputer()
'Set objServers = GetObject("LDAP://OU=Servers,OU=postname,DC=domain,DC=state,DC=sbu")
'objServers.Filter = Array("Computer")
'w=0
'For Each objServer in objServers
'redim preserve strComputer(w)
'strComputer(w) = objServer.CN
'w=w+1
'Next

'------------------------------------------
'------------------------------------------
'------------------------------------------
'------------------------------------------


	Dim objWMIService, objItem, colItems
	Dim strDriveType, strDiskSize, txt


z=0
For each objComputer in strComputer

	Set objWMIService = GetObject("winmgmts:\\" & objComputer & "\root\cimv2")
	Set colItems = objWMIService.ExecQuery("Select * from Win32_LogicalDisk WHERE DriveType=3")
	txt = "<table ><tr height='15'><td align=center colspan='4'bgcolor=white style='filter:progid:DXImageTransform.Microsoft.Gradient(endColorstr=#00aaeed, startColorstr=#ffffff, gradientType='2');'><font size='4px'>" & objComputer & 

"</font></td></tr><tr><td width=30px> DL</td><td width=40px> Size</td><td width=50px> Free</td></tr> " 

	For Each objItem in colItems

		DIM pctFreeSpace,strFreeSpace,strusedSpace
		strBGColor="7dc623"
		'pctFreeSpace = INT((objItem.FreeSpace / objItem.Size) * 1000)/10
		strDiskSize = Int(objItem.Size /1073741824)
		strFreeSpace = Int(objItem.FreeSpace /1073741824) 
			If strFreeSpace < 3 then
				strBGColor = "red" 
			elseIf strFreeSpace < 7 then
				strBGColor = "yellow" 
			end if
		txt = txt & "<tr><td> " & objItem.Name & "<td> " & strDiskSize & "<td bgcolor='" & strBGColor & "'>" & strFreeSpace & "<td></tr> "


	Next
	txt = txt & "</table>"


If not Err.Number = 0 Then txt = "<table width='100%'><tr height='15'><td align=center bgcolor=white style='filter:progid:DXImageTransform.Microsoft.Gradient(endColorstr=#00aaeed, startColorstr=#ffffff, gradientType='2');'><font 

size='4px'>" & objComputer & "</font></td></tr><tr><td bgcolor=red>Error: " & error.number & "</td></tr>"
Err.Clear
z=z+1
If z=5 then txt=txt & "<td valign=top><table>"


	response.Write(txt)
if z=5 then z=0

Next



%>

</td><td valign=top>
<table>



<%

'response.Write(tblLatency)




%>



</td><td valign=top>
<table>


<%

strsqlComputer = array("sqlservername","IISservername")

	
        dim strname, strstate

z=0
For each objComputer in strsqlComputer

	Set objWMIService = GetObject("winmgmts:\\" & objComputer & "\root\cimv2")
	Set colItems = objWMIService.ExecQuery("Select * from Win32_Service where displayname like 'SQL Server Agent%' or displayname like 'WEBPASS%'  ")
	txt = "<table ><tr height='15'><td align=center colspan='4'bgcolor=white style='filter:progid:DXImageTransform.Microsoft.Gradient(endColorstr=#00aaeed, startColorstr=#ffffff, gradientType='2');'><font size='4px'>" & objComputer & 

"</font></td></tr><tr></tr> " 

	For Each objItem in colItems
	
				
		strname = objitem.displayname
		strstate = objitem.state
		If strstate = "Running" then
			strBGColor = "7dc623" 
		
		else
 			strBGColor = "RED"
		End If
		
                
		txt = txt & "<tr><td> " & objItem.displayname & "<td> " &  "<td bgcolor='" & strBGColor & "'>" & strstate & "<td></tr> "

	Next
	txt = txt & "</table>"

If not Err.Number = 0 Then txt = "<table width='100%'><tr height='15'><td align=center bgcolor=white style='filter:progid:DXImageTransform.Microsoft.Gradient(endColorstr=#00aaeed, startColorstr=#ffffff, gradientType='2');'><font 

size='4px'>" & objComputer & "</font></td></tr><tr><td bgcolor=red>Error: " & error.number & "</td></tr>"
Err.Clear
z=z+1
If z=4 then txt=txt & "<td valign=top><table>"

	response.Write(txt)
if z=4 then z=0

Next
%>


</td></tr></table>

</td><td valign=top>
<table>
<%

response.Write(tblLatency)





%>

</font>
</body>
</html>
