Dim strQuery, strQuery2, objLocator, objWMI, objItem, objItem2, colItems, colItems2, resultString, nicName, sSpeed	

strQuery2 = "SELECT * FROM Win32_NetworkAdapter"
Set objLocator = CreateObject( "WbemScripting.SWbemLocator" )
Set objWMI = objLocator.ConnectServer( ".", "root\CIMV2" )
objWMI.Security_.ImpersonationLevel = 3
Set colItems2 = objWMI.ExecQuery( strQuery2, "WQL", 0 )

resultString = ""

For Each objItem2 In colItems2
 If objItem2.NetConnectionStatus = 2 Then
  nicName = Mid(objItem2.Name, 1, 5 )
  'WScript.Echo nicName
  if objItem2.NetEnabled = True and left(nicName,2) <> "VM" then
  
  
        If IsNull(objItem2.Speed)         Then 
		sSpeed = "Speed not reported" 
        Else 
			sSpeed = Left(objItem2.Speed, Len(objItem2.Speed) - 6) & " MBits/s"  
		end if
    echo sSpeed
  end if
 End If
Next
Set objLocator = Nothing
Set objWMI = Nothing
Set colItems = Nothing
Set colItems2 = Nothing
