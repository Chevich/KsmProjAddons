unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, vgdbtree, DB, DBTables, Mask, ToolEdit, vgTreeCm,
  Explorer, ExplrDB, vgCtrls, ExplCtrl, vgTools;

type
  TMainForm = class(TForm)
    dbTree: TvgDBTreeView;
    cmClose: TButton;
    dsTree: TDataSource;
    vgDBTreeCombo1: TvgDBTreeCombo;
    ExplorerRootNode1: TExplorerRootNode;
    ExplorerSource1: TExplorerSource;
    ExplorerTreeView1: TExplorerTreeView;
    ExplorerTreeCombo1: TExplorerTreeCombo;
    ExplorerDBTreeRootNode1: TExplorerDBTreeRootNode;
    procedure cmCloseClick(Sender: TObject);
    procedure dbTreeSetRange(Sender: TObject; DataSet: TDataSet;
      ParentID: string);
    procedure FormShow(Sender: TObject);
    procedure dbTreeProcessBranches(Sender: TObject; Node: TTreeNode;
      var Process: Boolean);
    procedure ExplorerDBTreeRootNode1SetRange(
      ExplorerNodes: TExplorerNodes; DataSet: TDataSet; ParentID: String);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses ADm;

{$R *.DFM}

procedure TMainForm.cmCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.dbTreeSetRange(Sender: TObject; DataSet: TDataSet;
  ParentID: string);
begin
  if ParentID = NullValue then ParentID := '';
  with TTable(dsTree.DataSet) do
  begin
    SetRangeStart;
    dbTree.FieldParentID.AsString := ParentID;
    SetRangeEnd;
    dbTree.FieldParentID.AsString := ParentID;
    ApplyRange;
  end;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  with TTable(dsTree.DataSet) do
  begin
    DatabaseName := ExtractFilePath(ParamStr(0));
    Open;
  end;
end;

procedure TMainForm.dbTreeProcessBranches(Sender: TObject; Node: TTreeNode;
  var Process: Boolean);
begin
  if Assigned(Node) and (Node.Level = 2) then Process := False;
end;

procedure TMainForm.ExplorerDBTreeRootNode1SetRange(
  ExplorerNodes: TExplorerNodes; DataSet: TDataSet; ParentID: String);
begin
  dbTreeSetRange(nil, DataSet, ParentID);
end;

end.
