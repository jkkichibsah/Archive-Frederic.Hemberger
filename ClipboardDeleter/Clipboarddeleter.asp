<%
' -------------------------------------------------------------------
' Clipboarddeleter.asp - Version 0.1.0
'
' 090401 Dennis Kueper, www.viega.com
'
' Based on: ClipboardPublisher.asp - Version 1.02, 2008-08-11, Frederic Hemberger
'
' This software is licensed under a Creative Commons
' Attribution-Share Alike 3.0 License. Some rights reserved.
' http://creativecommons.org/licenses/by-sa/3.0/
'
' THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
' EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
' OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
' NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
' HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
' WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
' FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
' OTHER DEALINGS IN THE SOFTWARE.
' -------------------------------------------------------------------
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
	<meta http-equiv="expires" content="0" />
	<meta http-equiv="cache-control" content="no-cache" />
	<meta http-equiv="pragma" content="no-cache" />
	<link rel="stylesheet" href="Clipboarddeleter.css" type="text/css" />
	<title>Clipboarddeleter</title>
</head>
<body>
<%
dim rqlError

' Check if user is logged into RedDot
If Session("LoginGuid") <> "" Then
	' Get selected pages from clipboard
	selectedGUIDs = Split(getSelectedPageGUIDs, vbCrLf)
	If UBound(selectedGUIDs) > -1 Then
		' Check publishing settings
		If Request.Form("GUIDs") <> "" Then
			Call DeleteSelectedPages(selectedGUIDs)
		Else
			Call showPublishForm(selectedGUIDs)
		End If
	Else	
	%>
		<div id="response"><b>No pages selected in clipboard.</b></div>
		<div id="footer">
			<button onclick="self.close()"><div class="close">Close</div></button>
		</div>
	<%
	End If
End If	

' Parses all GUID's and sends the RQL request
'
Sub DeleteSelectedPages(selectedGUIDs)
	Dim arrGUIDs, arrLng, arrPrj, followup, related, lngVariants, prjVariants
	Dim rqlQuery, rqlResult, rqlError, tmpError

	arrGUIDs = selectedGUIDs
	%><form><h2>Page deletion process log</h2><br><br><%

	rqlQuery = "<IODATA loginguid=""" & session("LoginGuid") & """ sessionkey=""" & session("Sessionkey") & """>"

	For page = 0 To UBound(arrGUIDs)
		if len(trim(arrGUIDs(page))) > 5 then
			%><%=arrGUIDs(page)%><br><%	
			rqlQuery=rqlQuery & "<PAGE action=""delete"" guid=""" & arrGUIDs(page) & """/>" 
		end if
	Next
    rqlQuery=rqlQuery & "</IODATA>"
	rqlResult = sendXML(rqlQuery, rqlError)
	%><br>rqlQuery: <%=replace(rqlQuery,"<","<br>")%><br><%	
	%><br>rqlResult: <%=replace(rqlResult,"<","<br>")%><br><%	
	%><br>Error help:<br>
	#RDError2910: Some elements link to the page.<br>
	#RDError2911: One or more elements of the page are a target-container of a link.<br><br>
	Errors:<br>
	<%=replace(rqlError,"<","<br>")%><br><%	
	
	%><br><button onclick="self.close()"><div class="cancel">Close</div></button>
	</form><%
End Sub



' Shows the confirmation form 
Sub showPublishForm(selectedGUIDs)
	Dim rqlQuery, rqlResult, i, guid, text
	arrGUIDs = selectedGUIDs
		%>

	<form action="Clipboarddeleter.asp" name="deleteForm" method="post">
		<input type="hidden" name="GUIDs" value="<%=Trim(Join(selectedGUIDs))%>" />
		<input type="hidden" name="user" value="<%=session("UserGuid")%>" />
		<h2>Delete <%=UBound(selectedGUIDs)%> pages from clipboard</h2>
		<br><br>Page ID's to delete:<br>
		<%
			For page = 0 To UBound(arrGUIDs)
				if len(trim(arrGUIDs(page))) > 5 then
					%><%=arrGUIDs(page)%><br><%	
					rqlQuery=rqlQuery & "<PAGE action=""delete"" guid=""" & arrGUIDs(page) & """/>" 
				end if
			Next
		%>
	</form>
	<div id="footer">
		<button onclick="document.deleteForm.submit();"><div class="submit">OK</div></button>
		<button onclick="self.close()"><div class="cancel">Cancel</div></button>
	</div>
	<%
	set RDxmlNodeList = nothing
	set xmlDoc = nothing
End Sub



' Returns the GUIDs of selected pages in the clipboard
'
' @return	GUIDs separated by vbCrLf or empty string on error
'
Function getSelectedPageGUIDs()
	Dim rqlQuery, rqlResult, filteredHTML, strGUIDs
	
	' Get RedDot clipboard content
	rqlQuery = "<IODATA loginguid=""" & session("LoginGuid") & """>" & _
	               "<ADMINISTRATION><USER guid=""" & session("UserGuid") & """><CLIPBOARDDATA action=""load"" projectguid=""" & session("ProjectGuid") & """/></USER></ADMINISTRATION>" & _
	           "</IODATA>"
	rqlResult = sendXML(rqlQuery, rqlError)

	If Len(rqlResult) > 0 Then
	

		Set xmlDoc = server.CreateObject("Msxml2.DOMDocument.4.0")
		xmlDoc.loadXML(rqlResult) 
		clipboardContent = unescape(xmlDoc.SelectSingleNode("//IODATA/CLIPBOARDDATA").getAttribute("value"))
		clipboardContent = Replace(clipboardContent, vbCrLf, "")
		Set xmlDoc = nothing
		' We have to filter the content, as it is ugly HTML 3.2
		filteredHTML = ""

		Set objRegExpInput = new RegExp
		objRegExpInput.Pattern = "<TR (.*?)>(.*?)<INPUT(.*?)></TD>"
		objRegExpInput.Global = True
		Set htmlSnippets = objRegExpInput.Execute(clipboardContent)
		For Each htmlSnippet In htmlSnippets
			' Combine all selected entries which are pages into the string for further processing
		    If ( InStr(ucase(htmlSnippet.Value), "CHECKED") > 0 AND InStr(htmlSnippet.Value, "elttype=""page""") > 0 ) Then filteredHTML = filteredHTML & htmlSnippet.Value
		Next
					
		' Now we have the selected pages, let's get the GUIDs
		strGUIDs = ""
		objRegExpInput.Pattern = "id=[A-F0-9]{32}"
		objRegExpInput.Global = True
		Set pageGUIDs = objRegExpInput.Execute(filteredHTML)
		For Each pageGUID In pageGUIDs
			strGUIDs = strGUIDs & Right(pageGUID.Value, 32) & vbCrLf
		Next
		Set objRegExpInput = nothing
		
		getSelectedPageGUIDs = strGUIDs
	Else
		getSelectedPageGUIDs = ""
	End If	
End Function


' -- RQL helper functions -------------------------------------------
' RQL request
'
' @param	XMLString	RQL request
' @return	RQL response
'
Function sendXML(XMLString, ByRef rqlError)
    Set objData = server.CreateObject("RDCMSASP.RdPageData")
    objData.XmlServerClassName="RDCMSServer.XmlServer"
    sendXML = objData.ServerExecuteXml(XMLString, rqlError)
    objData = NULL
End Function
%>
</body>
</html>