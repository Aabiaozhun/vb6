  


��δ�ӡ: ���������������ѡ�� �ļ� �˵��е� ��ӡ ѡ��
--------------------------------------------------------------
�����´�ӡ��ZDNet China��
--------------------------------------------------------------

��������������������ӹ���
Builder.com 
23/4/2004 
URL: http://www.zdnet.com.cn/developer/webdevelop/story/0,2000081602,39236051,00.htm 
������Ĵ�����ӵ�ģ����

 

�������������У���ͨ�����û��������ʱ���WebӦ�ó����������п���Ȩ��ͨ���������������Internet Explorer��IE����

�ⲻһ���ǻ��£���ΪIE���������ṩ�˴�������ǿ��������Ӧ�ó���Ĺ��ߡ����Ĳ�����������IE��������ΪIEȷʵ���ڣ������Ǳ���������Ӧ�ó���ĳ��ù��ߣ������б�Ҫ�ᵽһЩ��Web������Ա���õļ�����

����һ�ּ��������������������BHO����BHO����IE���̿ռ������еġ����ڿ����õĴ��ں�ģ����ִ���κ�ָ����������ģ�ͣ�COM������BHOͨ������ű�֮���WebӦ�ó�����Ը����ṩ���⹦�ܡ�

�������Ѿ���������Ҫ�û�����Ĳ�ͬ���򣬶�����һЩ������Ҫ��ͬ����Ϣ�������Ҫ���û������������Σ�������ܻ�����������ݡ�

�������������ҳ��ʱ��������Զ��������ݣ���������Խ���Щ��Ϣ������һ���û�������ϣ�����һ��������Ϣ�⣬���ֻ������أ����п���������������һ����Ϣ���û���˽����Ϣ�����ַ���绰����ȡ���������������ҳ������ʱ��BHO���Զ������ݼ��뵽����ֶ��С�

�ҽ�ʹ��Visual Basic �����������������ǣ�Ϊ���ṩ�ӿ���IE�ܺ�����������ұ������һ����ʾIObjectWithSite�ӿڵ����Ϳ⡣��Ϊ�ⲻ��ʮ�����ף������Ҳ��ò�����һ�����ҽ�ʹ�ö����������ԣ�ODL���Լ���VBһ��װ�ص�mktyplib������ʵ����������һ������VBBHO.ODL���ı��ļ����������´��룺

 [
uuid(CF9D9B76-EC4B-470D-99DC-AEC6F36A9261),
helpstring("VB IObjectWithSite Interface"),
version(1.0)
]
library IObjectWithSiteTLB
{
importlib("stdole2.tlb");
typedef [public] long GUIDPtr;
typedef [public] long VOIDPtr;
[
uuid(00000000-0000-0000-C000-000000000046),
odl
]
interface IUnknownVB
{
HRESULT QueryInterface(
[in] GUIDPtr priid,
[out] VOIDPtr *pvObj
);
long AddRef();
long Release();
}
[
uuid(FC4801A3-2BA9-11CF-A229-00AA003D7352),
odl
]
interface IObjectWithSite:IUnknown
{
typedef IObjectWithSite *LPOBJECTWITHSITE;
HRESULT SetSite([in] IUnknownVB* pSite);
HRESULT GetSite([in] GUIDPtr priid, [in, out] VOIDPtr* ppvObj);
}
}; 

 

��������ļ�������mktyplib���ߴ������Ϳ��ļ�����������ʾ������λ������MKTYPLIB.EXE��Ŀ¼��ַ��Ȼ�����mktyplib c:\[path to ODL file]\vbbho.odl����VB�д���һ���µ�ActiveX DLLӦ�ó��򣬽������������ΪVBBHO������ģ��������ΪMyBHO���򿪳�����������������ť������������Ǹոմ�����VBBHO.TLB�ļ������У�Ҫ����΢��XML2.6�棨Microsoft XML v2.6������°汾��΢��Internet �ؼ���Microsoft Internet Controls���Լ�΢��HTML����⣨Microsoft HTML Object Library����

 

������Ĵ�����ӵ�ģ����


������Ĵ�����ӵ������ģ���У�

Option Explicit
Option Base 0

Implements IObjectWithSiteTLB.IObjectWithSite
Dim WithEvents m_ie As InternetExplorer
Dim m_Site As IUnknownVB

Private Sub IObjectWithSite_GetSite(ByVal priid As
IObjectWithSiteTLB.GUIDPtr,
 ppvObj As IObjectWithSiteTLB.VOIDPtr)
    m_Site.QueryInterface priid, ppvObj
End Sub

Private Sub IObjectWithSite_SetSite(ByVal pSite As
IObjectWithSiteTLB.IUnknownVB)
    Set m_Site = pSite
    Set m_ie = pSite
End Sub

Private Sub m_ie_DocumentComplete(ByVal pDisp As Object,
URL As Variant)
On Error GoTo ErrorHandler
    Dim HTMLDoc As MSHTML.HTMLDocument
    Dim HTMLElement As MSHTML.HTMLInputElement
    Dim ElementCollection As Object
    Dim DOMDoc As MSXML2.DOMDocument
    Dim i As Integer, l As Integer
    Dim m_lError As Long, m_sError As String
    m_lError = 0
    Set HTMLDoc = m_ie.document
    Set ElementCollection = HTMLDoc.getElementsByName("myInput")
    l = ElementCollection.length
    If l > 0 Then
        Set DOMDoc = New MSXML2.DOMDocument
        DOMDoc.Load App.Path & "/data.xml"
        If DOMDoc.parseError.errorCode <> 0 Then
            App.LogEvent "DOM Error: " & DOMDoc.parseError.errorCode
 & vbCrLf
& DOMDoc.parseError.reason
            GoTo ExitCall
        End If
        Dim sField As String
        For i = 1 To l
            Set HTMLElement = ElementCollection.Item("myInput", i - 1)
            On Error Resume Next
            HTMLElement.setAttribute "value",
 DOMDoc.selectSingleNode(HTMLElement.getAttribute("field")).Text
            On Error GoTo ErrorHandler
        Next
    End If
ExitCall:
    Set HTMLDoc = Nothing
    Set HTMLElement = Nothing
    Set ElementCollection = Nothing
    Set DOMDoc = Nothing
    If m_lError <> 0 Then
        App.LogEvent "There was an error in VBBHO.MyBHO: " & vbCrLf &
 m_lError & vbCrLf & m_sError
    End If
    Exit Sub
ErrorHandler:
    m_lError = Err.Number
    m_sError = Err.Description
    Err.Clear
    GoTo ExitCall
End Sub 

 

��IE��ʼ����ʱ����������һ������ʵ�����������ȵ���SetSite()������һ��ָ��InternetExplorer�����ָ�뱻���ͽ�ȥ��ͬʱ������m_Site��m_ie��Ա�������С�m_Site��Ա������������GetSite()�����е�һ������ֵ��

 

�������������Ҫ�Ĳ�����m_ie��Ա������DocumentComplete�¼���������¼�����ʱ��Ҳ���ǵ�ҳ�����װ��ʱ����ÿ��myInput INPUTԪ�ؽ���ѭ����ֵ���Ա����á������ʾ�����£�

<INPUT TYPE="text" NAME="myInput" field="//personal_info/first_name"> 

  

�������뻹װ����һ������data.xml���ļ�������ļ�λ�ں������ͬ��Ŀ¼��ַ����������Ǹ��ļ���XML��

<?xml version='1.0'?>
<xml>
    <personal_info>
        <first_name>John</first_name>
        <last_name>Public</last_name>
        <age>99</age>
    </personal_info>
</xml> 

 

Ϊ��ʹIE�������������������Ҫ��HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects�������һ������ע���ļ������Browser Helper Objects�������ڣ�����Ҫ��������༭���������HKEY_CLASSES_ROOT\VBBHO.MyBHO��ע������ҵ������CLSID�ļ������������CLSID�ļ���������ӵ�Browser Helper Objects������Ҳ������SetSite()�����е��������������һ��MsgBox���ã���ȷ������װ�ء�

 

һ����ȷ��������װ�أ������HTML��������������������

<HTML>
<BODY>
<FORM>
<INPUT TYPE="text" NAME="myInput" field="//personal_info/first_name"><BR>
<INPUT TYPE="text" NAME="myInput" field="//personal_info/last_name"><BR>
<INPUT TYPE="text" NAME="myInput" field="//personal_info/age"><BR>
</FORM>
</BODY>
</HTML> 

 

��¼��IE�е����ҳ�棬����Կ�����Щ�Զ�װ��XML�ļ���Ϣ��INPUT�ֶΡ�

 

ע�⣺�༭ע����ǲ���ȫ�ġ������κθĶ�֮ǰ�����Ҫ��ע�����б��ݣ���������д�����֣���Ϳ��Զ������лָ��� 

���α༭������

��ӭ���ۻ�Ͷ�� 
 
 
