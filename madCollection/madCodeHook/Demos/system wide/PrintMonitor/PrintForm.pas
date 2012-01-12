unit PrintForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, CommCtrl;

type
  TFPrintMonitor = class(TForm)
    LogLV: TListView;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure HandlePrintNotification(var Message: TMessage); message WM_USER + 777;
  public
    { Public-Deklarationen }
  end;

var FPrintMonitor: TFPrintMonitor;

implementation

{$R *.dfm}

uses madCodeHook;

type
  // this is what we our dll sends us
  TPrintNotification = record
    process : array [0..MAX_PATH] of char;
    api     : array [0..MAX_PATH] of char;
    params  : array [0..MAX_PATH] of char;
    result  : array [0..MAX_PATH] of char;
  end;

procedure TFPrintMonitor.HandlePrintNotification(var Message: TMessage);
// you got mail! add the received message to our listview
begin
  // was it really a message from our dll?
  if Message.lParam = $777 then
    // yes it was, so extract the information and add it to our listview
    with TPrintNotification(pointer(Message.wParam)^), LogLV.Items.Add do begin
      Caption := TimeToStr(Now);
      SubItems.Add(ExtractFileName(process));
      SubItems.Add(api);
      SubItems.Add(params);
      SubItems.Add(result);
      MakeVisible(false);
    end;
end;

procedure IpcPrintMessageCallback(name: pchar; messageBuf: pointer; messageLen: dword;
                                  answerBuf: pointer; answerLen: dword); stdcall;
begin
  // forward the ipc message to the form
  SendMessage(FPrintMonitor.Handle, WM_USER + 777, integer(messageBuf), $777);
end;

procedure TFPrintMonitor.FormCreate(Sender: TObject);
begin
  // create an ipc message queue, so that our hook dll can contact us
  if not CreateIpcQueue(pchar('PrintMonitor' + IntToStr(GetCurrentSessionId)),
                        IpcPrintMessageCallback) then begin
    // ooops, we have no ipc queue! probably another instance is already up
    MessageBox(0, 'please don''t start me twice', 'information...', MB_ICONINFORMATION);
    ExitProcess(0);
  end;
  // the main work is done by our dll
  // which we inject into all processes in our session
  if not InjectLibrary(CURRENT_SESSION or SYSTEM_PROCESSES, 'HookPrintAPIs.dll') then begin
    // if you want your stuff to run in under-privileges user accounts, too,
    // you have to do write a little service for the NT family
    // an example for that can be found in the "HookProcessTermination" demo
    MessageBox(0, 'only users with administrator privileges can run this demo',
               'information...', MB_ICONINFORMATION);
    ExitProcess(0);
  end;
end;

procedure TFPrintMonitor.FormDestroy(Sender: TObject);
begin
  // don't leave the dll there, if our log window exits
  UninjectLibrary(CURRENT_SESSION or SYSTEM_PROCESSES, 'HookPrintAPIs.dll');
end;

procedure TFPrintMonitor.FormKeyPress(Sender: TObject; var Key: Char);
// escape -> close
begin
  if Key = #27 then begin
    Key := #0;
    Close;
  end;
end;

end.
