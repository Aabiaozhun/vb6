VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "GUseZipProtocol"
Attribute VB_GlobalNameSpace = True
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Public Const zipProtocolHead = "zip://"
Public Const zipSep = "|/"
Public Const zipfakeTrail = "[LXRFakeItHoHo]/"
Public Const zipTempName = "zhReader"
Public Type zipUrl
sZipName As String
sHtmlPath As String
End Type


Public Function zipProtocol_ParseURL(ByVal URL As String) As zipUrl

    Dim lPos As Long
    On Error GoTo InvalidURL
    ' Unescape the URL
    'UrlUnescape URL, URL, Len(URL), URL_UNESCAPE_INPLACE
    URL = UnescapeUrl(URL)
    ' Remove the protocol

    If Left$(URL, Len(zipProtocolHead)) <> zipProtocolHead Then Exit Function
    URL = Right$(URL, Len(URL) - Len(zipProtocolHead))
    ' Remove the / at the end of the URL

    If Right$(URL, 1) = "/" Then URL = Left$(URL, Len(URL) - 1)
    ' Remove the // at the begining of the URL

    Do While Left$(URL, 1) = "/"
        URL = Mid$(URL, 2)
    Loop

    ' Find the first / from the right
    lPos = InStr(URL, zipSep)

    If lPos > 0 Then

        With zipProtocol_ParseURL
            .sZipName = Left$(URL, lPos - 1)
            .sHtmlPath = Right$(URL, Len(URL) - lPos - Len(zipSep) + 1)
        End With

    End If

    Exit Function
InvalidURL:
    Err.Clear

End Function

Public Function FakeToReal(ByVal fakeStr As String, Optional ByRef realStr As String = "") As Boolean

    FakeToReal = False
    'realStr = fakeStr

    If Left$(fakeStr, Len(zipfakeTrail)) = zipfakeTrail Then
        FakeToReal = True
        realStr = Right$(fakeStr, Len(fakeStr) - Len(zipfakeTrail))
    End If

End Function


