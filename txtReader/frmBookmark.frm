VERSION 5.00
Begin VB.Form frmBookmark 
   Caption         =   "Manage Bookmark"
   ClientHeight    =   1944
   ClientLeft      =   60
   ClientTop       =   456
   ClientWidth     =   6732
   LinkTopic       =   "Form1"
   ScaleHeight     =   1944
   ScaleWidth      =   6732
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdExit 
      Caption         =   "Exit"
      Height          =   330
      Left            =   5400
      TabIndex        =   7
      Top             =   1344
      Width           =   1065
   End
   Begin VB.CommandButton cmdSave 
      Caption         =   "Save"
      Height          =   330
      Left            =   3912
      TabIndex        =   6
      Top             =   1344
      Width           =   1065
   End
   Begin VB.CommandButton cmdDelete 
      Caption         =   "Delete"
      Height          =   330
      Left            =   2424
      TabIndex        =   5
      Top             =   1344
      Width           =   1065
   End
   Begin VB.ComboBox cboIndex 
      Appearance      =   0  'Flat
      Height          =   288
      Left            =   324
      Style           =   2  'Dropdown List
      TabIndex        =   4
      Top             =   1392
      Width           =   855
   End
   Begin VB.TextBox txtLocation 
      Height          =   300
      Left            =   1530
      Locked          =   -1  'True
      MousePointer    =   1  'Arrow
      TabIndex        =   3
      Top             =   780
      Width           =   4950
   End
   Begin VB.TextBox txtName 
      Height          =   300
      Left            =   1560
      TabIndex        =   1
      Top             =   225
      Width           =   4935
   End
   Begin VB.Label lblLocation 
      Caption         =   "Location:"
      Height          =   360
      Left            =   360
      TabIndex        =   2
      Top             =   840
      Width           =   1215
   End
   Begin VB.Label lblBMname 
      Caption         =   "Name:"
      Height          =   360
      Left            =   390
      TabIndex        =   0
      Top             =   285
      Width           =   1215
   End
End
Attribute VB_Name = "frmBookmark"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit


Private Sub cboIndex_Click()

    Dim i As Integer
    Dim pos As Integer
    i = cboIndex.ListIndex + 1
    txtName.Text = ""
    txtLocation.Text = ""

    With MainFrm
        txtName.Text = .mnuBookmark(i).Caption
        txtLocation.Text = .mnuBookmark(i).Tag
    End With

End Sub

Private Sub cmdDelete_Click()

    Dim mnuIndex As Integer
    Dim i As Integer

    If cboIndex.ListCount < 1 Then Exit Sub

    If cboIndex.ListIndex < 0 Then Exit Sub
    
    mnuIndex = cboIndex.ListIndex + 1
    cboIndex.RemoveItem cboIndex.ListIndex

    With MainFrm
        Dim lEnd As Long
        lEnd = .mnuBookmark.Count - 2

        For i = mnuIndex To lEnd
            .mnuBookmark(i) = .mnuBookmark(i + 1)
        Next

        Unload MainFrm.mnuBookmark(.mnuBookmark.Count - 1)
    End With

    For i = 0 To cboIndex.ListCount - 1
        cboIndex.List(i) = Str$(i + 1)
    Next

    If cboIndex.ListCount > 0 Then cboIndex.ListIndex = cboIndex.ListCount - 1 Else Unload Me

End Sub

Private Sub cmdExit_Click()

    Unload Me

End Sub

Private Sub cmdSave_Click()

    Dim mnuIndex As Integer

    If cboIndex.ListCount < 1 Then Exit Sub

    If cboIndex.ListIndex < 0 Then Exit Sub
    mnuIndex = cboIndex.ListIndex + 1

    With MainFrm
        .mnuBookmark(mnuIndex).Caption = txtName.Text
        .mnuBookmark(mnuIndex).Tag = txtLocation.Text
    End With

    MsgBox "Done!"

End Sub

Private Sub Form_Load()

    loadFormStr Me
    
    Dim i As Integer
    Dim pos As Integer
    Dim lEnd As Long
    
    Me.Icon = MainFrm.Icon

    lEnd = MainFrm.mnuBookmark.Count - 1
    For i = 1 To lEnd
    cboIndex.AddItem Str$(i)
    Next
    
    If cboIndex.ListCount > 0 Then cboIndex.ListIndex = cboIndex.ListCount - 1

End Sub
