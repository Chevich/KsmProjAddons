unit GetExUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP, Menus, XMLMenuTranslation;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    Memo1: TMemo;
    IdHTTP1: TIdHTTP;
    MainMenu: TMainMenu;
    Edit2: TEdit;
    Edit3: TEdit;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure CreateMenuFromXMLFile(Str:TStrings);
  end;

var
  Form1: TForm1;

implementation
  uses XMLIntf, XMLDoc;
{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  MainMenu.Items.Clear;
  Memo1.Text:='';
  idHttp1.ProxyParams.ProxyServer:=Edit2.Text;
  idHttp1.ProxyParams.ProxyPort:=StrToInt(Edit3.Text);
  Memo1.Text:=idHttp1.Get(Edit1.Text);
  CreateMenuFromXMLFile(Memo1.Lines);
end;

procedure TForm1.CreateMenuFromXMLFile(Str:TStrings);

   function Get_Int(S: string): Integer;
   begin
     Result := 0;
     try
       Result := StrToInt(S);
     except
     end;
   end;

   procedure AddRecursive(Parent: TMenuItem; Item: IXMLNode);
   var
     I: Integer;
     Node: TMenuItem;
     Child: IXMLNode;
     Address: TMethod;
   begin
     Node := TMenuItem.Create(Parent);
     if Item.Attributes['Name']<>null then
       Node.Caption := Item.Attributes['Name']
     else
       Node.Caption := Item.NodeName;
     if (Item.Attributes['ID']<>null) and (Uppercase(Item.Attributes['ID']) <> 'NONE') then
     begin
       Address.Code := MethodAddress(Item.Attributes['ID']);
       Address.Data := Self;
       if (Item.ChildNodes.Count - 1 < 0) then
         Node.OnClick := TNotifyEvent(Address);
     end;
     Node.Visible := True;

     if Parent <> nil then
       Parent.Add(Node)
     else
       MainMenu.Items.Add(Node);

     for I := 0 to Item.ChildNodes.Count - 1 do
     begin
       Child := item.ChildNodes[i];
       if (Child.NodeName = 'Item') then
         AddRecursive(Node, Child);
     end;
   end;
 var
   Root: IXMLMENUType;
   Parent: TMenuItem;
   I: Integer;
   Child: IXMLNode;
   XMLDocument:TXMLDocument;
 begin
   XMLDocument:=TXMLDocument.Create(Self);
   XMLDocument.XML := Str;
   {if not FileExists(XMLDocument.FileName) then
   begin
     MessageDlg('Menu-XML-Document nicht gefunden!', mtError, [mbOK], 0);
     Halt;
   end;}
   XMLDocument.Active := True;


   Screen.Cursor := crHourglass;
   try
     Root := GetXMLMenu(XMLDocument);
     Parent := nil;

     for I := 0 to Root.ChildNodes.Count - 1 do
     begin
       Child := Root.ChildNodes[i];
       if
       (Child.NodeName = 'VisualLevel') or
       (Child.NodeName = 'AudioLevel') or
       (Child.NodeName = 'Integration') or
       (Child.NodeName = 'VisualPresence') or
       (Child.NodeName = 'VisualClarity') or
       (Child.NodeName = 'AudioClarity') or

       (Child.NodeName = 'IntegrationDesc') or
       (Child.NodeName = 'IntegrationDesc') or
       (Child.NodeName = 'IntegrationDesc') or
       (Child.NodeName = 'Error') or
       (Child.NodeName = 'SegmentDesc')
        then
         AddRecursive(Parent, Child);
     end;
   finally
     Screen.Cursor := crDefault;
   end;
 end;

end.
