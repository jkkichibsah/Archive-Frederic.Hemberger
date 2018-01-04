<?xml version="1.0" encoding="windows-1252" ?> 
<rss version="2.0">
<channel>
	<title>CMS Feed</title>
	<%	'Choose your Project 
		projektid = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" 
		
		'Reddot Scriptuser - needs to be a user who has rights to access the last login data:
		suname="XXXXXXXXXX"
		supassword="XXXXXXXXXX"
		
		%>
	<link>http://yourserver</link>
	<description />
	<pubDate></pubDate>
	<generator>Reddot Who logged in ASP</generator>
	<language>de</language>
    <description>last logged in users</description> 
  <lastBuildDate><%=now%></lastBuildDate> 
  
<%
Function return_RFC822_Date(myDate, offset)
   Dim myDay, myDays, myMonth, myYear
   Dim myHours, myMonths, mySeconds

   myDate = CDate(myDate)
   myDay = WeekdayName(Weekday(myDate),true)
   myDays = Day(myDate)
   myMonth = MonthName(Month(myDate), true)
   myYear = Year(myDate)
   myHours = zeroPad(Hour(myDate), 2)
   myMinutes = zeroPad(Minute(myDate), 2)
   mySeconds = zeroPad(Second(myDate), 2)

   return_RFC822_Date = myDay&", "& _
                                  myDays&" "& _
                                  myMonth&" "& _
                                  myYear&" "& _
                                  myHours&":"& _
                                  myMinutes&":"& _
                                  mySeconds&" "& _
                                  offset
End Function
Function zeroPad(m, t)
   zeroPad = String(t-Len(m),"0")&m
End Function

function sendXML (XMLString) 
 set objData = server.CreateObject("RDCMSASP.RdPageData") ' *
 objData.XMLServerClassname="RDCMSServer.XmlServer" ' *
 sendXML = objData.ServerExecuteXML(XMLString, sErrors)
end function 

Function DecodeDate(OldDate)
  Set objIO = CreateObject("RDCMSAsp.RDPageData")  ' Objekt erstellen
  DecodeDate = objIO.decodedate(OldDate)           ' Zahl in Datum wandeln
End Function


XMLString = "" & _
"<IODATA>" & _
  "<ADMINISTRATION action='login' name='" & suname & "' password='" & supassword & "'/>" & _
"</IODATA>"
xmlFile = sendXML(XMLString)


Set xmlDoc = server.CreateObject("Msxml2.DOMDocument.4.0")
xmlDoc.loadXML(xmlFile)
Set RDxmlNodeList = xmlDoc.getElementsByTagName("LOGIN") 
 For i=0 To (RDxmlNodeList.length - 1)
   loginguid   = RDxmlNodeList.item(i).getAttribute("guid")
  Next
set xmlDoc = nothing


XMLString = "" & _
"<IODATA loginguid='" & loginguid & "'>" & _
  "<ADMINISTRATION action='validate' guid='" & loginguid & "' useragent='script'>" & _
    "<PROJECT guid='" & projektid & "'/>" & _
  "</ADMINISTRATION>" & _
"</IODATA>"

xmlFile = sendXML(XMLString)


Set xmlDoc = server.CreateObject("Msxml2.DOMDocument.4.0")
xmlDoc.loadXML(xmlFile)
Set RDxmlNodeList = xmlDoc.getElementsByTagName("SERVER") 
 For i=0 To (RDxmlNodeList.length - 1)
   skey   = RDxmlNodeList.item(i).getAttribute("key")
  Next
set xmlDoc = nothing

XMLString = "" & _
"<IODATA loginguid='" & loginguid & "' sessionkey='" & skey & "'>" & _
 "<AUTHORIZATION>" & _
   "<PAGES action='list' maxcount='10' orderby='1' direction='0'/>" & _
 "</AUTHORIZATION>" & _
"</IODATA>"

xmlFile = sendXML(XMLString)
Set xmlDoc = server.CreateObject("Msxml2.DOMDocument.4.0")
xmlDoc.loadXML(xmlFile)
Set RDxmlNodeList = xmlDoc.getElementsByTagName("PAGE") 
 For i=0 To (RDxmlNodeList.length - 1)

   headline   = RDxmlNodeList.item(i).getAttribute("headline")
   changedate = RDxmlNodeList.item(i).getAttribute("changedate")
   editlinkguid = RDxmlNodeList.item(i).getAttribute("editlinkguid")

   changeuserguid  = RDxmlNodeList.item(i).getAttribute("changeuserguid")      
   createuser  = RDxmlNodeList.item(i).getAttribute("createuser")   
   createdate  = RDxmlNodeList.item(i).getAttribute("createdate")
   guid  = RDxmlNodeList.item(i).getAttribute("guid")      
   languagevariantid  = RDxmlNodeList.item(i).getAttribute("languagevariantid")   
   languagevariantname  = RDxmlNodeList.item(i).getAttribute("languagevariantname")
   mainlinkguid  = RDxmlNodeList.item(i).getAttribute("mainlinkguid")      
   rejectiontype  = RDxmlNodeList.item(i).getAttribute("rejectiontype")   
   releasedate  = RDxmlNodeList.item(i).getAttribute("releasedate")
   releasegroups  = RDxmlNodeList.item(i).getAttribute("releasegroups")      
   username  = RDxmlNodeList.item(i).getAttribute("username")   
   RELEASEUSERS   = RDxmlNodeList.item(i).getAttribute("RELEASEUSERS")      
   assentcount   = RDxmlNodeList.item(i).getAttribute("assentcount")      
      
   decription = ""
   decription = decription & "changeuserguid: " & changeuserguid & "<br>"
   decription = decription & "createuser: " & createuser & "<br>"
   decription = decription & "createdate: " & DecodeDate(createdate) & "<br>"
   decription = decription & "guid: " & guid & "<br>"
   decription = decription & "languagevariantid: " & languagevariantid & "<br>"
   decription = decription & "languagevariantname: " & languagevariantname & "<br>"
   decription = decription & "mainlinkguid: " & mainlinkguid & "<br>"
   decription = decription & "rejectiontype: " & rejectiontype & "<br>"
   decription = decription & "releasedate: " & DecodeDate(releasedate) & "<br>"
   decription = decription & "releasegroups: " & releasegroups & "<br>"
   decription = decription & "username: " & username & "<br>"
   decription = decription & "RELEASEUSERS: " & RELEASEUSERS & "<br>"
   decription = decription & "assentcount: " & assentcount & "<br>"
   
   
   response.write("<item>" & vbcrlf)
   response.write("<title>" & headline & "</title>" & vbcrlf)
   response.write("<link>" & editlinkguid & "</link>" & vbcrlf)
   response.write("<description><![CDATA[ " & decription & " ]]></description>" & vbcrlf)
   response.write("<pubDate>" & return_RFC822_Date(DecodeDate(changedate),"GMT+1") & "</pubDate>" & vbcrlf)
   response.write("<guid>" & guid & "</guid>" & vbcrlf)      
   response.write("</item>" & vbcrlf)
  Next
set xmlDoc = nothing

'Logout======================================================
XMLString = "" & _
"<IODATA loginguid='" & loginguid & "'>" & _
  "<ADMINISTRATION>" & _
	  "<LOGOUT guid='" & loginguid & "' />" & _
  "</ADMINISTRATION>" & _
"</IODATA>"
sReturnValue = sendXML(XMLString)
'Logout======================================================

%>
  </channel>
  </rss>