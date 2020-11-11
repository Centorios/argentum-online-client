VERSION 5.00
Begin VB.Form frmMensaje 
   Appearance      =   0  'Flat
   BackColor       =   &H00000000&
   BorderStyle     =   0  'None
   ClientHeight    =   3195
   ClientLeft      =   15
   ClientTop       =   15
   ClientWidth     =   4365
   ClipControls    =   0   'False
   ControlBox      =   0   'False
   DrawMode        =   1  'Blackness
   DrawStyle       =   5  'Transparent
   FontTransparent =   0   'False
   HasDC           =   0   'False
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   Picture         =   "frmMensaje.frx":0000
   ScaleHeight     =   213
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   291
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.Image imgCerrar 
      Height          =   420
      Left            =   3900
      Tag             =   "0"
      Top             =   15
      Width           =   465
   End
   Begin VB.Image Image1 
      Height          =   420
      Left            =   1200
      Tag             =   "1"
      Top             =   2535
      Width           =   1980
   End
   Begin VB.Label msg 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "Mensaje"
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   6.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00C0C0C0&
      Height          =   1215
      Left            =   600
      TabIndex        =   0
      Top             =   1200
      Width           =   3165
      WordWrap        =   -1  'True
   End
   Begin VB.Menu mnuMensaje 
      Caption         =   "Mensaje"
      Visible         =   0   'False
      Begin VB.Menu mnuNormal 
         Caption         =   "Normal"
      End
      Begin VB.Menu mnuGlobal 
         Caption         =   "Global"
      End
      Begin VB.Menu mnuPrivado 
         Caption         =   "Privado"
      End
      Begin VB.Menu mnuGritar 
         Caption         =   "Gritar"
      End
      Begin VB.Menu mnuClan 
         Caption         =   "Clan"
      End
      Begin VB.Menu mnuGMs 
         Caption         =   "Grupo"
      End
   End
End
Attribute VB_Name = "frmMensaje"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Public bmoving      As Boolean

Public dX           As Integer

Public dy           As Integer

' Constantes para SendMessage
Const WM_SYSCOMMAND As Long = &H112&

Const MOUSE_MOVE    As Long = &HF012&

Private Declare Function ReleaseCapture Lib "user32" () As Long

Private Declare Function SendMessage Lib "user32" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, lParam As Long) As Long

Private RealizoCambios As String

Const HWND_TOPMOST = -1

Const HWND_NOTOPMOST = -2

Const SWP_NOSIZE = &H1

Const SWP_NOMOVE = &H2

Const SWP_NOACTIVATE = &H10

Const SWP_SHOWWINDOW = &H40

Private Declare Sub SetWindowPos Lib "user32" (ByVal hwnd As Long, ByVal hWndInsertAfter As Long, ByVal X As Long, ByVal Y As Long, ByVal cx As Long, ByVal cy As Long, ByVal wFlags As Long)
'Argentum Online 0.11.6

' funci�n Api para aplicar la transparencia a la ventana
Private Declare Function SetLayeredWindowAttributes Lib "user32" (ByVal hwnd As Long, ByVal crKey As Long, ByVal bAlpha As Byte, ByVal dwFlags As Long) As Long

' Funciones api para los estilos de la ventana
Private Declare Function GetWindowLong Lib "user32" Alias "GetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long) As Long

Private Declare Function SetWindowLong Lib "user32" Alias "SetWindowLongA" (ByVal hwnd As Long, ByVal nIndex As Long, ByVal dwNewLong As Long) As Long

'constantes
Private Const GWL_EXSTYLE = (-20)

Private Const LWA_ALPHA = &H2

Private Const WS_EX_LAYERED = &H80000
  
' Funci�n Api SetWindowPos
  
'En el primer par�metro se le pasa el Hwnd de la ventana
'El segundo es la constante que permite hacer el OnTop
'Los par�metros que est�n en 0 son las coordenadas, o sea la _
 pocici�n, obviamente opcionales
'El �ltimo par�metro es para que al establecer el OnTop la ventana _
 no se mueva de lugar y no se redimensione

Public Function Is_Transparent(ByVal hwnd As Long) As Boolean

    On Error Resume Next
  
    Dim msg As Long
  
    msg = GetWindowLong(hwnd, GWL_EXSTYLE)
         
    If (msg And WS_EX_LAYERED) = WS_EX_LAYERED Then
        Is_Transparent = True
    Else
        Is_Transparent = False

    End If
  
    If Err Then
        Is_Transparent = False

    End If
  
End Function
  
'Funci�n que aplica la transparencia, se le pasa el hwnd del form y un valor de 0 a 255
Public Function Aplicar_Transparencia(ByVal hwnd As Long, Valor As Integer) As Long
  
    Dim msg As Long
  
    On Error Resume Next
  
    If Valor < 0 Or Valor > 255 Then
        Aplicar_Transparencia = 1
    Else
        msg = GetWindowLong(hwnd, GWL_EXSTYLE)
        msg = msg Or WS_EX_LAYERED
     
        SetWindowLong hwnd, GWL_EXSTYLE, msg
     
        'Establece la transparencia
        SetLayeredWindowAttributes hwnd, 0, Valor, LWA_ALPHA
  
        Aplicar_Transparencia = 0
  
    End If
  
    If Err Then
        Aplicar_Transparencia = 2

    End If
  
End Function

Private Sub moverForm()

    Dim res As Long

    ReleaseCapture
    res = SendMessage(Me.hwnd, WM_SYSCOMMAND, MOUSE_MOVE, 0)

End Sub

'Ladder 21/09/2012
'Cierra el form presionando enter.
Private Sub Form_KeyPress(KeyAscii As Integer)

    If KeyAscii = vbKeyReturn Then
        Unload Me

    End If

End Sub

'Ladder 21/09/2012

Private Sub Form_Load()
    'Call FormParser.Parse_Form(Me)
    SetWindowPos Me.hwnd, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE Or SWP_NOSIZE
    'Call Aplicar_Transparencia(Me.hwnd, 200)
    ''Call Audio.PlayWave(SND_MSG)
    frmMensaje.Picture = LoadInterface("mensaje.bmp")
    Me.Caption = "A"
    Call Form_RemoveTitleBar(Me)
    Me.Height = 3190
    Me.Width = 4380
End Sub

Private Sub Form_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    moverForm

    If Image1.Tag = "1" Then
        Image1.Picture = Nothing
        Image1.Tag = "0"
    End If
    
    If imgCerrar.Tag = "1" Then
        imgCerrar.Picture = Nothing
        imgCerrar.Tag = "0"
    End If

End Sub

Private Sub Image1_Click()
    'Call Sound.Sound_Play(SND_CLICK)
    Unload Me
End Sub

Private Sub Image1_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    Image1.Picture = LoadInterface("boton-aceptar-ES-off.jpg")
    Image1.Tag = "1"
End Sub

Private Sub Image1_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    If Image1.Tag = "0" Then
        Image1.Picture = LoadInterface("boton-aceptar-ES-over.jpg")
        Image1.Tag = "1"
    End If
End Sub

Private Sub Form_Deactivate()
    ' Me.SetFocus
End Sub

Public Sub PopupMenuMensaje()

    Select Case SendingType

        Case 1
            mnuNormal.Checked = True
            mnuGritar.Checked = False
            mnuPrivado.Checked = False
            mnuClan.Checked = False
            mnuGMs.Checked = False
            mnuGlobal.Checked = False

        Case 2
            mnuNormal.Checked = False
            mnuGritar.Checked = True
            mnuPrivado.Checked = False
            mnuClan.Checked = False
            mnuGMs.Checked = False
            mnuGlobal.Checked = False

        Case 3
            mnuNormal.Checked = False
            mnuGritar.Checked = False
            mnuPrivado.Checked = True
            mnuClan.Checked = False
            mnuGMs.Checked = False
            mnuGlobal.Checked = False

        Case 4
            mnuNormal.Checked = False
            mnuGritar.Checked = False
            mnuPrivado.Checked = False
            mnuClan.Checked = True
            mnuGMs.Checked = False
            mnuGlobal.Checked = False

        Case 5
            mnuNormal.Checked = False
            mnuGritar.Checked = False
            mnuPrivado.Checked = False
            mnuClan.Checked = False
            mnuGMs.Checked = True
            mnuGlobal.Checked = False

        Case 6
            mnuNormal.Checked = False
            mnuGritar.Checked = False
            mnuPrivado.Checked = False
            mnuClan.Checked = False
            mnuGMs.Checked = False
            mnuGlobal.Checked = False

        Case 7
            mnuNormal.Checked = False
            mnuGritar.Checked = False
            mnuPrivado.Checked = False
            mnuClan.Checked = False
            mnuGMs.Checked = False
            mnuGlobal.Checked = True

    End Select

    PopUpMenu mnuMensaje

End Sub

Private Sub imgCerrar_Click()
    Unload Me
End Sub

Private Sub imgCerrar_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
    imgCerrar.Picture = LoadInterface("boton-cerrar-off.bmp")
    imgCerrar.Tag = "1"
End Sub

Private Sub imgCerrar_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
    If imgCerrar.Tag = "0" Then
        imgCerrar.Picture = LoadInterface("boton-cerrar-over.bmp")
        imgCerrar.Tag = "1"
    End If
End Sub

Private Sub mnuNormal_Click()
    SendingType = 1

    If frmmain.SendTxt.Visible Then frmmain.SendTxt.SetFocus

End Sub

Private Sub mnuGritar_click()
    SendingType = 2

    If frmmain.SendTxt.Visible Then frmmain.SendTxt.SetFocus

End Sub

Private Sub mnuPrivado_click()
    sndPrivateTo = InputBox("Escriba el usuario con el que desea iniciar una conversaci�n privada", "")

    If sndPrivateTo <> "" Then
        SendingType = 3

        If frmmain.SendTxt.Visible Then frmmain.SendTxt.SetFocus
    Else
        Call MensajeAdvertencia("Debes escribir un usuario v�lido")

    End If

End Sub

Private Sub mnuClan_click()
    SendingType = 4

    If frmmain.SendTxt.Visible Then frmmain.SendTxt.SetFocus

End Sub

Private Sub mnuGMs_click()
    SendingType = 5

    If frmmain.SendTxt.Visible Then frmmain.SendTxt.SetFocus

End Sub

Private Sub mnuGrupo_click()
    SendingType = 6

    If frmmain.SendTxt.Visible Then frmmain.SendTxt.SetFocus

End Sub

Private Sub mnuGlobal_Click()
    SendingType = 7

    If frmmain.SendTxt.Visible Then frmmain.SendTxt.SetFocus

End Sub
