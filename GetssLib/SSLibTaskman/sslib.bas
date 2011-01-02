Attribute VB_Name = "MSSLib"
Option Explicit

Public Enum SSLIBTaskStatus
    STS_Start = 1
    sts_pause = 0
    STS_Complete = 2
    STS_Pending = 3
End Enum
Public Type SSLIBTaskData
    Title As String
    Author As String
    SSID As String
    Publisher As String
    PublishedDate As String
    Subject As String
    Header As String
    PagesCount As String
    AddInfo As String
    URL As String
    About As String
End Type

Private SSLIB_FLAGS_INIT As Boolean
Public Const CST_SSLIB_FIELDS_COUNT As Long = 12
Public Enum SSLIBFields
        SSF_TITLE = 1
        SSF_Author = 2
        SSF_SSID = 3
        SSF_Publisher = 4
        SSF_Subject = 5
        SSF_PublishedData = 6
        SSF_URL = 7
        SSF_PAGESCOUNT = 8
        SSF_SAVEDIN = 9
        SSF_STATUS = 10
        SSF_HEADER = 11
        SSF_FULLNAME = 12
End Enum
Public SSLIB_FIELDS_NAME(1 To CST_SSLIB_FIELDS_COUNT, 1 To 2) As String


Public Sub SSLIB_Init()

    If SSLIB_FLAGS_INIT Then Exit Sub
    
    SSLIB_FIELDS_NAME(SSLIBFields.SSF_Author, 1) = "Author"
    SSLIB_FIELDS_NAME(SSLIBFields.SSF_Author, 2) = "����"
    
    SSLIB_FIELDS_NAME(SSLIBFields.SSF_FULLNAME, 1) = "Fullname"
    SSLIB_FIELDS_NAME(SSLIBFields.SSF_FULLNAME, 2) = "ȫ��"
    
    SSLIB_FIELDS_NAME(SSLIBFields.SSF_HEADER, 1) = "Header"
    SSLIB_FIELDS_NAME(SSLIBFields.SSF_HEADER, 2) = "��ͷ"
    
    SSLIB_FIELDS_NAME(SSLIBFields.SSF_PAGESCOUNT, 1) = "PagesCount"
    SSLIB_FIELDS_NAME(SSLIBFields.SSF_PAGESCOUNT, 2) = "ҳ��"
    
    SSLIB_FIELDS_NAME(SSLIBFields.SSF_PublishedData, 1) = "PublishedData"
    SSLIB_FIELDS_NAME(SSLIBFields.SSF_PublishedData, 2) = "��������"
    
    SSLIB_FIELDS_NAME(SSLIBFields.SSF_Publisher, 1) = "Publisher"
    SSLIB_FIELDS_NAME(SSLIBFields.SSF_Publisher, 2) = "������"
    
    SSLIB_FIELDS_NAME(SSLIBFields.SSF_SAVEDIN, 1) = "SavedIn"
    SSLIB_FIELDS_NAME(SSLIBFields.SSF_SAVEDIN, 2) = "����λ��"
    
    SSLIB_FIELDS_NAME(SSLIBFields.SSF_SSID, 1) = "SSID"
    SSLIB_FIELDS_NAME(SSLIBFields.SSF_SSID, 2) = "SSID"
    
    SSLIB_FIELDS_NAME(SSLIBFields.SSF_STATUS, 1) = "Status"
    SSLIB_FIELDS_NAME(SSLIBFields.SSF_STATUS, 2) = "״̬"
    
    SSLIB_FIELDS_NAME(SSLIBFields.SSF_Subject, 1) = "Subject"
    SSLIB_FIELDS_NAME(SSLIBFields.SSF_Subject, 2) = "�����"
    
    SSLIB_FIELDS_NAME(SSLIBFields.SSF_TITLE, 1) = "Title"
    SSLIB_FIELDS_NAME(SSLIBFields.SSF_TITLE, 2) = "����"
    
    SSLIB_FIELDS_NAME(SSLIBFields.SSF_URL, 1) = "Url"
    SSLIB_FIELDS_NAME(SSLIBFields.SSF_URL, 2) = "����λ��"

    
    SSLIB_FLAGS_INIT = True
    
End Sub

Public Function SSLIB_GetFieldName1(ByRef vField As SSLIBFields) As String
    On Error Resume Next
    
    SSLIB_GetFieldName1 = SSLIB_FIELDS_NAME(vField, 1)
End Function

Public Function SSLIB_GetFieldName2(ByRef vField As SSLIBFields) As String
    On Error Resume Next
    
    SSLIB_GetFieldName2 = SSLIB_FIELDS_NAME(vField, 2)
End Function

'4. �������ͯ��ѧ���� С���ˡ�
'�����Ķ�  |  ��ͨ�Ķ�
'����:[��]�¶����أ�Alcott��L.M.���� ������ ��ӱ����
'ҳ��:330   ��������:2001��08�µ�3��
'�����:��ƪС˵ ���� ���� CT S007141 ��ƪС˵
 

Public Function SSLIB_ParseInfoText(Optional ByRef vText As String) As SSLIBTaskData
    On Error Resume Next
    If vText = "" Then vText = Clipboard.GetText
    If vText = "" Then Exit Function
    If InStr(1, vText, vbCrLf & "SSCT:", vbTextCompare) > 0 Then
        SSLIB_ParseInfoText.Header = Replace$(vText, "(Request-Line):", "")
    Else
        With SSLIB_ParseInfoText
            .Author = SubStringBetween(vText, "����:", vbCrLf)
            .Title = SubStringBetween(vText, "��", "��")
            .PagesCount = SubStringBetween(vText, "ҳ��:", " ")
            .PublishedDate = SubStringBetween(vText, "��������:", vbCrLf)
            .Subject = SubStringBetween(vText, "�����:", vbCrLf)
            .About = SubStringBetween(vText, "���:", vbCrLf)
            .AddInfo = "���=" & .About & vbCrLf & "�����=" & .Subject
        End With
        
    End If
End Function

Public Function SubStringUntilMatch(ByRef source As String, ByRef Start As Long, ByRef Target As String) As String
    On Error GoTo NoMatch
    Dim iEnd As Long
    If Start < 1 Then Start = 1
    iEnd = InStr(Start, source, Target)
    If (iEnd > Start) Then
        SubStringUntilMatch = Mid$(source, Start, iEnd - Start)
    End If
    Exit Function
    
NoMatch:
    
End Function

Public Function SubStringBetween(ByRef source As String, ByRef vLeft As String, ByRef vRight As String) As String
    On Error GoTo NoMatch
    Dim pStart As Long
    pStart = InStr(source, vLeft)
    If (pStart > 0) Then
        SubStringBetween = SubStringUntilMatch(source, pStart + Len(vLeft), vRight)
    End If
    Exit Function
NoMatch:
End Function

Public Function SSLIB_ParseInfoRule(ByRef vFilename As String, ByRef vUrls() As String) As Long
    On Error GoTo Error_ParseInfoRule
    
    Dim srcLen As Long
    Dim fNum As Integer
    Dim Result() As Byte
    
    fNum = FreeFile
    Open vFilename For Binary Access Read Shared As #fNum
    
    srcLen = LOF(fNum) - &H44
    ReDim source(0 To srcLen) As Byte
    Seek #fNum, &H44 + 1
    Get #fNum, , source()
    Close #fNum
    
    Dim CharZero As String
    CharZero = Chr$(0)
    If (UncompressBuf(source, Result)) Then
        Dim vSource As String
        Dim iCount As Long
        vSource = StrConv(Result, vbUnicode)
        Dim iStart As Long
        Dim iEnd As Long
        Dim iPos As Long
        iPos = 1
        Do
            iEnd = InStr(iPos, vSource, ".pdg", vbTextCompare)
            If iEnd > 0 Then
                iStart = InStrRev(vSource, CharZero, iEnd)
                If iStart > 0 Then
                    ReDim Preserve vUrls(0 To iCount)
                    vUrls(iCount) = Mid$(vSource, iStart + 1, iEnd - iStart + 3)
                    iCount = iCount + 1
                    iPos = iEnd + 4
                    'vSource = Mid$(vSource, iEnd + 4)
                Else
                    Exit Do
                End If
            Else
                Exit Do
            End If
        Loop
        
        SSLIB_ParseInfoRule = iCount
    End If
    

    Exit Function
Error_ParseInfoRule:
    SSLIB_ParseInfoRule = -1
End Function

