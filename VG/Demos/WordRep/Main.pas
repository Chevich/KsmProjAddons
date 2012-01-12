unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DB, DBTables, Menus, vgWP, ExtCtrls, vgWPBDE, vgWPDB;

type
  TMainForm = class(TForm)
    wp: TvgBDEWordPrint;
    db: TDatabase;
    gbWhatHappens: TGroupBox;
    lbEvent: TLabel;
    Label2: TLabel;
    cmConnect: TButton;
    cmPrint: TButton;
    Label3: TLabel;
    cbFile: TComboBox;
    cbAliases: TComboBox;
    procedure cmConnectClick(Sender: TObject);
    procedure cmPrintClick(Sender: TObject);
    procedure wpBeginAnalize(Sender: TObject);
    procedure wpEndAnalize(Sender: TObject);
    procedure wpEndPrint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure wpDataOpen(Sender: TObject; Bookmark: TWordBookmark);
    procedure wpBeginPrintRecord(Sender: TObject; Bookmark: TWordBookmark);
  private
    { Private declarations }
    procedure SetEvent(Event: String);
  public
    { Public declarations }
    property Event: String write SetEvent;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

procedure TMainForm.SetEvent(Event: String);
begin
  lbEvent.Caption := Event;
  if Handleallocated then Update;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Session.GetDatabaseNames(cbAliases.Items);
  cbAliases.ItemIndex := 0;
  Event := 'Nothing';
end;

procedure TMainForm.cmConnectClick(Sender: TObject);
begin
 if db.Connected then db.Close;
 db.AliasName := cbAliases.Text;
 db.Open;
end;

procedure TMainForm.cmPrintClick(Sender: TObject);
var
  Text: String;
begin
  Text := cbFile.Text;
  if cbFile.Items.IndexOf(Text) < 0 then
    cbFile.Items.Add(Text);

  if not db.Connected then
    db.AliasName := cbAliases.Text;
  wp.Disconnect;
  wp.Connect;
  wp.SourceDoc := ExpandFileName(cbFile.Text);
  wp.WordVisible := True;
  try
    Enabled := False;
    try
      wp.Print;
    finally
      Enabled := True;
    end;
  except
    Event := 'Error while printing';
    raise;
  end;
end;

procedure TMainForm.wpBeginAnalize(Sender: TObject);
begin
  Event := 'Analize bookmark structure...';
end;

procedure TMainForm.wpEndAnalize(Sender: TObject);
begin
  Event := 'Analize done';
end;

procedure TMainForm.wpEndPrint(Sender: TObject);
begin
  Event := 'Printed';
end;

procedure TMainForm.wpDataOpen(Sender: TObject; Bookmark: TWordBookmark);
begin
  Event := 'Opening dataset...';
end;

procedure TMainForm.wpBeginPrintRecord(Sender: TObject;
  Bookmark: TWordBookmark);
begin
  Event := 'Printing...';
end;

end.
