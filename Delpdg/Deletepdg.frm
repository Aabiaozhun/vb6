VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3330
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6645
   LinkTopic       =   "Form1"
   ScaleHeight     =   3330
   ScaleWidth      =   6645
   StartUpPosition =   3  '����ȱʡ
   Begin VB.DriveListBox Drive1 
      Height          =   300
      Left            =   120
      TabIndex        =   3
      Top             =   120
      Width           =   6255
   End
   Begin VB.TextBox Text1 
      Height          =   372
      Left            =   3360
      TabIndex        =   1
      Top             =   1320
      Width           =   3012
   End
   Begin VB.DirListBox Dir1 
      Height          =   1560
      Left            =   120
      TabIndex        =   2
      Top             =   720
      Width           =   3012
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Delete"
      Height          =   372
      Left            =   3360
      TabIndex        =   0
      Top             =   1920
      Width           =   3012
   End
   Begin VB.Label Label1 
      Height          =   735
      Left            =   240
      TabIndex        =   4
      Top             =   2520
      Width           =   6255
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command1_Click()
Dim ff() As String '����һ���ַ����������������ҵ����ļ�����
Dim fn As Long '�����ҵ����ļ���Ŀ
Dim i As Integer
fn = TreeSearch(Dir1.Path, Text1.Text, ff())
Rem If fn > 0 Then
'    Label1.Caption = "һ����" + Str(fn) + "���ļ�����Ҫ��"
'    Text2.Text = ff(1)
'    If fn > 1 Then
'    For i = 2 To fn
'    Text2.Text = Text2.Text + Chr(13) + Chr(10) + ff(i)
'    Next
'    End If
'Else
'    Call MsgBox("            û���ʺ������Ľ��             ", vbOKOnly, "��ʾ��Ϣ")
'End If
End Sub

Private Function TreeSearch(ByVal sPath As String, ByVal sFileSpec As String, sFiles() As String) As Long
Static fstFiles As Long '�ļ���Ŀ
Dim sDir As String
Dim sSubDirs() As String '�����Ŀ¼����
Dim fstIndex As Long
If Right(sPath, 1) <> "\" Then sPath = sPath + "\"
sDir = Dir(sPath + sFileSpec)
'��õ�ǰĿ¼���ļ�������Ŀ
Do While Len(sDir)
fstFiles = fstFiles + 1
ReDim Preserve sFiles(1 To fstFiles)
sFiles(fstFiles) = sPath + sDir

Label1.Caption = "Deleting " + sFiles(fstFiles)
Form1.Refresh
Kill sFiles(fstFiles)
sDir = Dir
Loop
'��õ�ǰĿ¼�µ���Ŀ¼����
fstIndex = 0
sDir = Dir(sPath + "*.*", 16)
Do While Len(sDir)
If Left(sDir, 1) <> "." Then 'skip.and..
'�ҳ���Ŀ¼��
If GetAttr(sPath + sDir) = vbDirectory Then
fstIndex = fstIndex + 1
'������Ŀ¼��
ReDim Preserve sSubDirs(1 To fstIndex)
sSubDirs(fstIndex) = sPath + sDir + "\"
End If
End If
sDir = Dir
Loop
For fstIndex = 1 To fstIndex '����ÿһ����Ŀ¼���ļ������������˵ݹ�
Call TreeSearch(sSubDirs(fstIndex), sFileSpec, sFiles())
Next fstIndex
TreeSearch = fstFiles
End Function
Private Sub Drive1_Change()
Dir1.Path = Drive1.Drive
End Sub

Private Sub Text1_KeyPress(KeyAscii As Integer)
If KeyAscii = 13 Then Call Command1_Click
End Sub
