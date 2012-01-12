{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvAppEvent.PAS, released on 2002-07-04.

The Initial Developers of the Original Code are: Fedor Koshevnikov, Igor Pavluk and Serge Korolev
Copyright (c) 1997, 1998 Fedor Koshevnikov, Igor Pavluk and Serge Korolev
Copyright (c) 2001,2002 SGB Software
All Rights Reserved.

Contributor(s):
  Hofi

Last Modified: 2004-10-07

Changes:
2004-10-07:
  * Added by Hofi
      TJvAppEvents
        property CancelDispatch
          gives a chance to break event dispatching in a particular event handler.

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}
// $Id: JvAppEvent.pas 11867 2008-08-17 19:30:33Z jfudickar $

unit JvAppEvent;

{$I jvcl.inc}

interface

uses
  {$IFDEF UNITVERSIONING}
  JclUnitVersioning,
  {$ENDIF UNITVERSIONING}
  Windows, Messages,
  SysUtils, Classes, Controls, Graphics, Forms, ActnList,
  JvTypes, JvComponentBase;

const
  DefHintColor = clInfoBk;
  DefHintPause = 500;
  DefHintShortPause = DefHintPause div 10;
  DefHintHidePause = DefHintPause * 5;



type
  TJvAppEvents = class(TJvComponent)
  private
    FChained: Boolean;
    FHintColor: TColor;
    FHintPause: Integer;
    FShowHint: Boolean;
    FCanvas: TCanvas;
    FUpdateFormatSettings: Boolean;
    FCancelDispatch: Boolean;
    FHintShortPause: Integer;
    FHintHidePause: Integer;
    FShowMainForm: Boolean;
    FHintShortCuts: Boolean;
    FMouseDragImmediate: Boolean;
    FMouseDragThreshold: Integer;
    FOnActionExecute: TActionEvent;
    FOnActionUpdate: TActionEvent;
    FOnShortCut: TShortCutEvent;
    FUpdateMetricSettings: Boolean;
    FBiDiMode: TBiDiMode;
    FBiDiKeyboard: string;
    FNonBiDiKeyboard: string;
    FOnPaintIcon: TNotifyEvent;
    FOnActivate: TNotifyEvent;
    FOnDeactivate: TNotifyEvent;
    FOnException: TExceptionEvent;
    FOnIdle: TIdleEvent;
    FOnHelp: THelpEvent;
    FOnHint: TNotifyEvent;
    FOnMessage: TMessageEvent;
    FOnMinimize: TNotifyEvent;
    FOnRestore: TNotifyEvent;
    FOnShowHint: TShowHintEvent;
    FOnSettingsChanged: TNotifyEvent;
    FOnActiveControlChange: TNotifyEvent;
    FOnActiveFormChange: TNotifyEvent;
    procedure UpdateAppProps;
    function GetCanvas: TCanvas;
    function GetHintColor: TColor;
    function GetHintPause: Integer;
    function GetShowHint: Boolean;
    procedure SetHintColor(Value: TColor);
    procedure SetHintPause(Value: Integer);
    procedure SetShowHint(Value: Boolean);
    function GetUpdateFormatSettings: Boolean;
    procedure SetUpdateFormatSettings(Value: Boolean);
    function GetHintShortPause: Integer;
    function GetHintHidePause: Integer;
    function GetShowMainForm: Boolean;
    procedure SetHintShortPause(Value: Integer);
    procedure SetHintHidePause(Value: Integer);
    procedure SetShowMainForm(Value: Boolean);
    function GetHintShortCuts: Boolean;
    procedure SetHintShortCuts(Value: Boolean);
    function GetMouseDragImmediate: Boolean;
    function GetMouseDragThreshold: Integer;
    procedure SetMouseDragImmediate(Value: Boolean);
    procedure SetMouseDragThreshold(Value: Integer);
    function GetUpdateMetricSettings: Boolean;
    procedure SetUpdateMetricSettings(Value: Boolean);
    function GetBiDiMode: TBiDiMode;
    procedure SetBiDiMode(Value: TBiDiMode);
    function GetBiDiKeyboard: string;
    function GetNonBiDiKeyboard: string;
    procedure SetBiDiKeyboard(const Value: string);
    procedure SetNonBiDiKeyboard(const Value: string);
  protected
    procedure Loaded; override;
    procedure PaintIcon; virtual;
    procedure SettingsChanged; dynamic;
    function MessageHook(var Msg: TMessage): Boolean; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Canvas: TCanvas read GetCanvas; { for painting the icon }
    procedure CancelDispatch;
  published
    property Chained: Boolean read FChained write FChained default True;
    property HintColor: TColor read GetHintColor write SetHintColor default DefHintColor;
    property HintPause: Integer read GetHintPause write SetHintPause default DefHintPause;
    property ShowHint: Boolean read GetShowHint write SetShowHint default True;
    property UpdateFormatSettings: Boolean read GetUpdateFormatSettings
      write SetUpdateFormatSettings default True;
    property HintShortPause: Integer read GetHintShortPause write SetHintShortPause
      default DefHintShortPause;
    property HintHidePause: Integer read GetHintHidePause write SetHintHidePause
      default DefHintHidePause;
    property ShowMainForm: Boolean read GetShowMainForm write SetShowMainForm
      default True;
    property HintShortCuts: Boolean read GetHintShortCuts write SetHintShortCuts
      default True;
    property UpdateMetricSettings: Boolean read GetUpdateMetricSettings
      write SetUpdateMetricSettings default True;
    property BiDiMode: TBiDiMode read GetBiDiMode write SetBiDiMode
      default bdLeftToRight;
    property BiDiKeyboard: string read GetBiDiKeyboard write SetBiDiKeyboard;
    property NonBiDiKeyboard: string read GetNonBiDiKeyboard write SetNonBiDiKeyboard;
    property MouseDragImmediate: Boolean read GetMouseDragImmediate
      write SetMouseDragImmediate default True;
    property MouseDragThreshold: Integer read GetMouseDragThreshold
      write SetMouseDragThreshold default 5;
    property OnActionExecute: TActionEvent read FOnActionExecute write FOnActionExecute;
    property OnActionUpdate: TActionEvent read FOnActionUpdate write FOnActionUpdate;
    property OnShortCut: TShortCutEvent read FOnShortCut write FOnShortCut;
    property OnActivate: TNotifyEvent read FOnActivate write FOnActivate;
    property OnDeactivate: TNotifyEvent read FOnDeactivate write FOnDeactivate;
    property OnException: TExceptionEvent read FOnException write FOnException;
    property OnIdle: TIdleEvent read FOnIdle write FOnIdle;
    property OnHelp: THelpEvent read FOnHelp write FOnHelp;
    property OnHint: TNotifyEvent read FOnHint write FOnHint;
    property OnMinimize: TNotifyEvent read FOnMinimize write FOnMinimize;
    property OnPaintIcon: TNotifyEvent read FOnPaintIcon write FOnPaintIcon;
    property OnRestore: TNotifyEvent read FOnRestore write FOnRestore;
    property OnShowHint: TShowHintEvent read FOnShowHint write FOnShowHint;
    property OnMessage: TMessageEvent read FOnMessage write FOnMessage;
    property OnSettingsChanged: TNotifyEvent read FOnSettingsChanged write FOnSettingsChanged;
    property OnActiveControlChange: TNotifyEvent read FOnActiveControlChange write FOnActiveControlChange;
    property OnActiveFormChange: TNotifyEvent read FOnActiveFormChange write FOnActiveFormChange;
  end;

{$IFDEF UNITVERSIONING}
const
  UnitVersioning: TUnitVersionInfo = (
    RCSfile: '$URL: https://jvcl.svn.sourceforge.net/svnroot/jvcl/branches/JVCL3_37_PREPARATION/run/JvAppEvent.pas $';
    Revision: '$Revision: 11867 $';
    Date: '$Date: 2008-08-17 21:30:33 +0200 (dim., 17 août 2008) $';
    LogPath: 'JVCL\run'
  );
{$ENDIF UNITVERSIONING}

implementation


type
  TJvAppEventList = class(TObject)
  private
    FAppEvents: TList;
    FHooked: Boolean;
    FOnActivate: TNotifyEvent;
    FOnDeactivate: TNotifyEvent;
    FOnException: TExceptionEvent;
    FOnIdle: TIdleEvent;
    FOnHelp: THelpEvent;
    FOnHint: TNotifyEvent;
    FOnMessage: TMessageEvent;
    FOnMinimize: TNotifyEvent;
    FOnRestore: TNotifyEvent;
    FOnShowHint: TShowHintEvent;
    FOnActiveControlChange: TNotifyEvent;
    FOnActiveFormChange: TNotifyEvent;
    FOnActionExecute: TActionEvent;
    FOnActionUpdate: TActionEvent;
    FOnShortCut: TShortCutEvent;
    procedure AddEvents(App: TJvAppEvents);
    procedure RemoveEvents(App: TJvAppEvents);
    procedure ClearEvents;
  protected
    procedure DoActivate(Sender: TObject);
    procedure DoDeactivate(Sender: TObject);
    procedure DoException(Sender: TObject; E: Exception);
    procedure DoIdle(Sender: TObject; var Done: Boolean);
    procedure DoHint(Sender: TObject);
    procedure DoMinimize(Sender: TObject);
    procedure DoRestore(Sender: TObject);
    function DoHelp(Command: Word; Data: {$IFDEF CLR} TObject {$ELSE} Longint {$ENDIF};
      var CallHelp: Boolean): Boolean;
    procedure DoMessage(var Msg: TMsg; var Handled: Boolean);
    procedure DoShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure DoShowHint(var HintStr: THintString; var CanShow: Boolean;
      var HintInfo: THintInfo);
    procedure DoActiveControlChange(Sender: TObject);
    procedure DoActiveFormChange(Sender: TObject);
    procedure DoActionExecute(Action: TBasicAction; var Handled: Boolean);
    procedure DoActionUpdate(Action: TBasicAction; var Handled: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
  end;

//=== { TJvAppEventList } ====================================================

constructor TJvAppEventList.Create;
begin
  inherited Create;
  FAppEvents := TList.Create;
end;

destructor TJvAppEventList.Destroy;
begin
  ClearEvents;
  FAppEvents.Free;
  inherited Destroy;
end;

procedure TJvAppEventList.ClearEvents;
begin
  if FHooked then
  begin
    // Application might get destroyed and set to nil before our finalization is called
    if Assigned(Application) then
    begin
      Application.OnActivate := nil;
      Application.OnDeactivate := nil;
      Application.OnException := nil;
      Application.OnIdle := nil;
      Application.OnHelp := nil;
      Application.OnHint := nil;
      Application.OnMessage := nil;
      Application.OnMinimize := nil;
      Application.OnRestore := nil;
      Application.OnShowHint := nil;
      Application.OnActionExecute := nil;
      Application.OnActionUpdate := nil;
      Application.OnShortCut := nil;
    end;

    // Screen might get destroyed and set to nil before our finalization is called
    if Assigned(Screen) then
    begin
      Screen.OnActiveControlChange := nil;
      Screen.OnActiveFormChange := nil;
    end;
  end;
end;

procedure TJvAppEventList.AddEvents(App: TJvAppEvents);
begin
  if (App <> nil) and (FAppEvents.IndexOf(App) = -1) then
  begin
    FAppEvents.Add(App);
    if not (csDesigning in App.ComponentState) and (FAppEvents.Count = 1) then
    begin
      FOnActivate := Application.OnActivate;
      FOnDeactivate := Application.OnDeactivate;
      FOnException := Application.OnException;
      FOnIdle := Application.OnIdle;
      FOnHelp := Application.OnHelp;
      FOnHint := Application.OnHint;
      FOnMessage := Application.OnMessage;
      FOnMinimize := Application.OnMinimize;
      FOnRestore := Application.OnRestore;
      FOnShowHint := Application.OnShowHint;
      FOnActionExecute := Application.OnActionExecute;
      FOnActionUpdate := Application.OnActionUpdate;
      FOnShortCut := Application.OnShortCut;
      Application.OnActionExecute := DoActionExecute;
      Application.OnActionUpdate := DoActionUpdate;
      Application.OnShortCut := DoShortCut;
      Application.OnActivate := DoActivate;
      Application.OnDeactivate := DoDeactivate;
      Application.OnException := DoException;
      Application.OnIdle := DoIdle;
      Application.OnHelp := DoHelp;
      Application.OnHint := DoHint;
      Application.OnMessage := DoMessage;
      Application.OnMinimize := DoMinimize;
      Application.OnRestore := DoRestore;
      Application.OnShowHint := DoShowHint;
      if Screen <> nil then
      begin
        FOnActiveControlChange := Screen.OnActiveControlChange;
        FOnActiveFormChange := Screen.OnActiveFormChange;
        Screen.OnActiveControlChange := DoActiveControlChange;
        Screen.OnActiveFormChange := DoActiveFormChange;
      end;
      FHooked := True;
    end;
  end;
end;

procedure TJvAppEventList.RemoveEvents(App: TJvAppEvents);
begin
  if FAppEvents.IndexOf(App) >= 0 then
    FAppEvents.Remove(App);
  if not (csDesigning in App.ComponentState) and (FAppEvents.Count = 0) then
    ClearEvents;
end;

procedure TJvAppEventList.DoActivate(Sender: TObject);
var
  I: Integer;
begin
  for I := FAppEvents.Count - 1 downto 0 do
  begin
    TJvAppEvents(FAppEvents[I]).FCancelDispatch := False;
    if Assigned(TJvAppEvents(FAppEvents[I]).FOnActivate) then
      TJvAppEvents(FAppEvents[I]).FOnActivate(Sender);
    if not TJvAppEvents(FAppEvents[I]).Chained or
     TJvAppEvents(FAppEvents[I]).FCancelDispatch then
      Exit;
  end;
  if Assigned(FOnActivate) then
    FOnActivate(Sender);
end;

procedure TJvAppEventList.DoDeactivate(Sender: TObject);
var
  I: Integer;
begin
  for I := FAppEvents.Count - 1 downto 0 do
  begin
    TJvAppEvents(FAppEvents[I]).FCancelDispatch := False;
    if Assigned(TJvAppEvents(FAppEvents[I]).FOnDeactivate) then
      TJvAppEvents(FAppEvents[I]).FOnDeactivate(Sender);
    if not TJvAppEvents(FAppEvents[I]).Chained or
     TJvAppEvents(FAppEvents[I]).FCancelDispatch then
      Exit;
  end;
  if Assigned(FOnDeactivate) then
    FOnDeactivate(Sender);
end;

procedure TJvAppEventList.DoException(Sender: TObject; E: Exception);
var
  I: Integer;
  Handled: Boolean;
begin
  Handled := False;
  for I := FAppEvents.Count - 1 downto 0 do
  begin
    TJvAppEvents(FAppEvents[I]).FCancelDispatch := False;
    if Assigned(TJvAppEvents(FAppEvents[I]).FOnException) then
    begin
      TJvAppEvents(FAppEvents[I]).FOnException(Sender, E);
      Handled := True;
    end;
    if not TJvAppEvents(FAppEvents[I]).Chained or
     TJvAppEvents(FAppEvents[I]).FCancelDispatch then
    begin
      if not Handled then
        Application.ShowException(E);
      Exit;
    end;
  end;
  if Assigned(FOnException) then
  begin
    FOnException(Sender, E);
    Handled := True;
  end;
  if not Handled then
    Application.ShowException(E);
end;

procedure TJvAppEventList.DoIdle(Sender: TObject; var Done: Boolean);
var
  I: Integer;
begin
  for I := FAppEvents.Count - 1 downto 0 do
  begin
    TJvAppEvents(FAppEvents[I]).FCancelDispatch := False;
    if Assigned(TJvAppEvents(FAppEvents[I]).FOnIdle) then
      TJvAppEvents(FAppEvents[I]).FOnIdle(Sender, Done);
    if not TJvAppEvents(FAppEvents[I]).Chained or
     TJvAppEvents(FAppEvents[I]).FCancelDispatch then
      Exit;
  end;
  if Assigned(FOnIdle) then
    FOnIdle(Sender, Done);
end;


function TJvAppEventList.DoHelp(Command: Word; Data: {$IFDEF CLR} TObject {$ELSE} Longint {$ENDIF};
  var CallHelp: Boolean): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := FAppEvents.Count - 1 downto 0 do
  begin
    TJvAppEvents(FAppEvents[I]).FCancelDispatch := False;
    if Assigned(TJvAppEvents(FAppEvents[I]).FOnHelp) then
      Result := TJvAppEvents(FAppEvents[I]).FOnHelp(Command, Data, CallHelp);
    if not TJvAppEvents(FAppEvents[I]).Chained or
     TJvAppEvents(FAppEvents[I]).FCancelDispatch then
      Exit;
  end;
  if Assigned(FOnHelp) then
    Result := FOnHelp(Command, Data, CallHelp);
end;



procedure TJvAppEventList.DoHint(Sender: TObject);
var
  I: Integer;
begin
  for I := FAppEvents.Count - 1 downto 0 do
  begin
    TJvAppEvents(FAppEvents[I]).FCancelDispatch := False;
    if Assigned(TJvAppEvents(FAppEvents[I]).FOnHint) then
      TJvAppEvents(FAppEvents[I]).FOnHint(Sender);
    if not TJvAppEvents(FAppEvents[I]).Chained or
     TJvAppEvents(FAppEvents[I]).FCancelDispatch then
      Exit;
  end;
  if Assigned(FOnHint) then
    FOnHint(Sender);
end;


procedure TJvAppEventList.DoMessage(var Msg: TMsg; var Handled: Boolean);
var
  I: Integer;
begin
  for I := FAppEvents.Count - 1 downto 0 do
  begin
    TJvAppEvents(FAppEvents[I]).FCancelDispatch := False;
    if Assigned(TJvAppEvents(FAppEvents[I]).FOnMessage) then
      TJvAppEvents(FAppEvents[I]).FOnMessage(Msg, Handled);
    if not TJvAppEvents(FAppEvents[I]).Chained or Handled or
     TJvAppEvents(FAppEvents[I]).FCancelDispatch then
      Exit;
  end;
  if Assigned(FOnMessage) then
    FOnMessage(Msg, Handled);
end;



procedure TJvAppEventList.DoMinimize(Sender: TObject);
var
  I: Integer;
begin
  for I := FAppEvents.Count - 1 downto 0 do
  begin
    TJvAppEvents(FAppEvents[I]).FCancelDispatch := False;
    if Assigned(TJvAppEvents(FAppEvents[I]).FOnMinimize) then
      TJvAppEvents(FAppEvents[I]).FOnMinimize(Sender);
    if not TJvAppEvents(FAppEvents[I]).Chained or
     TJvAppEvents(FAppEvents[I]).FCancelDispatch then
      Exit;
  end;
  if Assigned(FOnMinimize) then
    FOnMinimize(Sender);
end;

procedure TJvAppEventList.DoRestore(Sender: TObject);
var
  I: Integer;
begin
  for I := FAppEvents.Count - 1 downto 0 do
  begin
    TJvAppEvents(FAppEvents[I]).FCancelDispatch := False;
    if Assigned(TJvAppEvents(FAppEvents[I]).FOnRestore) then
      TJvAppEvents(FAppEvents[I]).FOnRestore(Sender);
    if not TJvAppEvents(FAppEvents[I]).Chained or
     TJvAppEvents(FAppEvents[I]).FCancelDispatch then
      Exit;
  end;
  if Assigned(FOnRestore) then
    FOnRestore(Sender);
end;

procedure TJvAppEventList.DoShowHint(var HintStr: THintString; var CanShow: Boolean;
  var HintInfo: THintInfo);
var
  I: Integer;
begin
  for I := FAppEvents.Count - 1 downto 0 do
  begin
    TJvAppEvents(FAppEvents[I]).FCancelDispatch := False;
    if Assigned(TJvAppEvents(FAppEvents[I]).FOnShowHint) then
      TJvAppEvents(FAppEvents[I]).FOnShowHint(HintStr, CanShow, HintInfo);
    if not TJvAppEvents(FAppEvents[I]).Chained or
     TJvAppEvents(FAppEvents[I]).FCancelDispatch then
      Exit;
  end;
  if Assigned(FOnShowHint) then
    FOnShowHint(HintStr, CanShow, HintInfo);
end;

procedure TJvAppEventList.DoActiveControlChange(Sender: TObject);
var
  I: Integer;
begin
  for I := FAppEvents.Count - 1 downto 0 do
  begin
    TJvAppEvents(FAppEvents[I]).FCancelDispatch := False;
    if Assigned(TJvAppEvents(FAppEvents[I]).FOnActiveControlChange) then
      TJvAppEvents(FAppEvents[I]).FOnActiveControlChange(Sender);
    if not TJvAppEvents(FAppEvents[I]).Chained or
     TJvAppEvents(FAppEvents[I]).FCancelDispatch then
      Exit;
  end;
  if Assigned(FOnActiveControlChange) then
    FOnActiveControlChange(Sender);
end;

procedure TJvAppEventList.DoActiveFormChange(Sender: TObject);
var
  I: Integer;
begin
  for I := FAppEvents.Count - 1 downto 0 do
  begin
    TJvAppEvents(FAppEvents[I]).FCancelDispatch := False;
    if Assigned(TJvAppEvents(FAppEvents[I]).FOnActiveFormChange) then
      TJvAppEvents(FAppEvents[I]).FOnActiveFormChange(Sender);
    if not TJvAppEvents(FAppEvents[I]).Chained or
     TJvAppEvents(FAppEvents[I]).FCancelDispatch then
      Exit;
  end;
  if Assigned(FOnActiveFormChange) then
    FOnActiveFormChange(Sender);
end;

procedure TJvAppEventList.DoActionExecute(Action: TBasicAction;
  var Handled: Boolean);
var
  I: Integer;
begin
  for I := FAppEvents.Count - 1 downto 0 do
  begin
    TJvAppEvents(FAppEvents[I]).FCancelDispatch := False;
    if Assigned(TJvAppEvents(FAppEvents[I]).FOnActionExecute) then
      TJvAppEvents(FAppEvents[I]).FOnActionExecute(Action, Handled);
    if not TJvAppEvents(FAppEvents[I]).Chained or Handled or
     TJvAppEvents(FAppEvents[I]).FCancelDispatch then
      Exit;
  end;
  if Assigned(FOnActionExecute) then
    FOnActionExecute(Action, Handled);
end;

procedure TJvAppEventList.DoActionUpdate(Action: TBasicAction;
  var Handled: Boolean);
var
  I: Integer;
begin
  for I := FAppEvents.Count - 1 downto 0 do
  begin
    TJvAppEvents(FAppEvents[I]).FCancelDispatch := False;
    if Assigned(TJvAppEvents(FAppEvents[I]).FOnActionUpdate) then
      TJvAppEvents(FAppEvents[I]).FOnActionUpdate(Action, Handled);
    if not TJvAppEvents(FAppEvents[I]).Chained or Handled or
     TJvAppEvents(FAppEvents[I]).FCancelDispatch then
      Exit;
  end;
  if Assigned(FOnActionUpdate) then
    FOnActionUpdate(Action, Handled);
end;


procedure TJvAppEventList.DoShortCut(var Msg: TWMKey; var Handled: Boolean);
var
  I: Integer;
begin
  for I := FAppEvents.Count - 1 downto 0 do
  begin
    TJvAppEvents(FAppEvents[I]).FCancelDispatch := False;
    if Assigned(TJvAppEvents(FAppEvents[I]).FOnShortCut) then
      TJvAppEvents(FAppEvents[I]).FOnShortCut(Msg, Handled);
    if not TJvAppEvents(FAppEvents[I]).Chained or Handled or
     TJvAppEvents(FAppEvents[I]).FCancelDispatch then
      Exit;
  end;
  if Assigned(FOnShortCut) then
    FOnShortCut(Msg, Handled);
end;



//=== { TJvAppEvents } =======================================================

var
  AppList: TJvAppEventList = nil;

constructor TJvAppEvents.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if AppList = nil then
    AppList := TJvAppEventList.Create;

  FChained := True;
  FHintColor := DefHintColor;
  FHintPause := DefHintPause;
  FShowHint := True;
  FCancelDispatch := False;
  FHintShortPause := DefHintShortPause;
  FHintHidePause := DefHintHidePause;
  FShowMainForm := True;
  FHintShortCuts := True;
  FMouseDragImmediate := True;
  FMouseDragThreshold := 5;
  FUpdateFormatSettings := True;
  FUpdateMetricSettings := True;
  FBiDiMode := bdLeftToRight;
  if not (csDesigning in ComponentState) then
    Application.HookMainWindow(MessageHook);
  AppList.AddEvents(Self);
end;

destructor TJvAppEvents.Destroy;
begin
  if not (csDesigning in ComponentState) then
    Application.UnhookMainWindow(MessageHook);
  if (Self <> nil) and (AppList <> nil) then
    AppList.RemoveEvents(Self);
  inherited Destroy;
  // (rom) destroy Canvas AFTER inherited Destroy
  FCanvas.Free;
end;

procedure TJvAppEvents.Loaded;
begin
  inherited Loaded;
  UpdateAppProps;
end;

function TJvAppEvents.GetCanvas: TCanvas;
begin
  if FCanvas = nil then
    FCanvas := TCanvas.Create;
  Result := FCanvas;
end;

procedure TJvAppEvents.CancelDispatch;
begin
  FCancelDispatch := True;
end;



procedure TJvAppEvents.PaintIcon;
var
  PS: TPaintStruct;
begin
  BeginPaint(Application.Handle, PS);
  try
    FreeAndNil(FCanvas);
    FCanvas := TCanvas.Create;
    try
      Canvas.Handle := PS.hDC;
      Canvas.Brush.Color := clBackground;
      if PS.fErase then
        Canvas.FillRect(PS.rcPaint);
      if Assigned(FOnPaintIcon) then
        FOnPaintIcon(Self);
    finally
      FreeAndNil(FCanvas);
    end;
  finally
    EndPaint(Application.Handle, PS);
  end;
end;

procedure TJvAppEvents.SettingsChanged;
begin
  if Assigned(FOnSettingsChanged) then
    FOnSettingsChanged(Self);
end;

function TJvAppEvents.MessageHook(var Msg: TMessage): Boolean;
begin
  Result := False;
  case Msg.Msg of
    WM_WININICHANGE:
      begin
        try
          SettingsChanged;
        except
          Application.HandleException(Self);
        end;
      end;
    WM_PAINT:
      if Assigned(FOnPaintIcon) and IsIconic(Application.Handle) then
      begin
        PaintIcon;
        Result := True;
      end;
  end;
end;



function TJvAppEvents.GetHintColor: TColor;
begin
  if csDesigning in ComponentState then
    Result := FHintColor
  else
    Result := Application.HintColor;
end;

function TJvAppEvents.GetHintPause: Integer;
begin
  if csDesigning in ComponentState then
    Result := FHintPause
  else
    Result := Application.HintPause;
end;

function TJvAppEvents.GetShowHint: Boolean;
begin
  if csDesigning in ComponentState then
    Result := FShowHint
  else
    Result := Application.ShowHint;
end;

procedure TJvAppEvents.SetHintColor(Value: TColor);
begin
  FHintColor := Value;
  if not (csDesigning in ComponentState) then
    Application.HintColor := Value;
end;

procedure TJvAppEvents.SetHintPause(Value: Integer);
begin
  FHintPause := Value;
  if not (csDesigning in ComponentState) then
    Application.HintPause := Value;
end;

procedure TJvAppEvents.SetShowHint(Value: Boolean);
begin
  FShowHint := Value;
  if not (csDesigning in ComponentState) then
    Application.ShowHint := Value;
end;

function TJvAppEvents.GetUpdateFormatSettings: Boolean;
begin
  if not (csDesigning in ComponentState) then
    Result := Application.UpdateFormatSettings
  else
    Result := FUpdateFormatSettings;
end;

procedure TJvAppEvents.SetUpdateFormatSettings(Value: Boolean);
begin
  FUpdateFormatSettings := Value;
  if not (csDesigning in ComponentState) then
    Application.UpdateFormatSettings := Value;
end;

function TJvAppEvents.GetHintShortPause: Integer;
begin
  if csDesigning in ComponentState then
    Result := FHintShortPause
  else
    Result := Application.HintShortPause;
end;

function TJvAppEvents.GetHintHidePause: Integer;
begin
  if csDesigning in ComponentState then
    Result := FHintHidePause
  else
    Result := Application.HintHidePause;
end;

function TJvAppEvents.GetShowMainForm: Boolean;
begin
  if csDesigning in ComponentState then
    Result := FShowMainForm
  else
    Result := Application.ShowMainForm;
end;

procedure TJvAppEvents.SetHintShortPause(Value: Integer);
begin
  FHintShortPause := Value;
  if not (csDesigning in ComponentState) then
    Application.HintShortPause := Value;
end;

procedure TJvAppEvents.SetHintHidePause(Value: Integer);
begin
  FHintHidePause := Value;
  if not (csDesigning in ComponentState) then
    Application.HintHidePause := Value;
end;

procedure TJvAppEvents.SetShowMainForm(Value: Boolean);
begin
  FShowMainForm := Value;
  if not (csDesigning in ComponentState) then
    Application.ShowMainForm := Value;
end;






function TJvAppEvents.GetUpdateMetricSettings: Boolean;
begin
  if csDesigning in ComponentState then
    Result := FUpdateMetricSettings
  else
    Result := Application.UpdateMetricSettings;
end;

procedure TJvAppEvents.SetUpdateMetricSettings(Value: Boolean);
begin
  FUpdateMetricSettings := Value;
  if not (csDesigning in ComponentState) then
    Application.UpdateMetricSettings := Value;
end;



function TJvAppEvents.GetHintShortCuts: Boolean;
begin
  if csDesigning in ComponentState then
    Result := FHintShortCuts
  else
    Result := Application.HintShortCuts;
end;

function TJvAppEvents.GetMouseDragImmediate: Boolean;
begin
  if (csDesigning in ComponentState) or (Mouse = nil) then
    Result := FMouseDragImmediate
  else
    Result := Mouse.DragImmediate;
end;

function TJvAppEvents.GetMouseDragThreshold: Integer;
begin
  if (csDesigning in ComponentState) or (Mouse = nil) then
    Result := FMouseDragThreshold
  else
    Result := Mouse.DragThreshold;
end;

procedure TJvAppEvents.SetMouseDragImmediate(Value: Boolean);
begin
  FMouseDragImmediate := Value;
  if not (csDesigning in ComponentState) and (Mouse <> nil) then
    Mouse.DragImmediate := Value;
end;

procedure TJvAppEvents.SetMouseDragThreshold(Value: Integer);
begin
  FMouseDragThreshold := Value;
  if not (csDesigning in ComponentState) and (Mouse <> nil) then
    Mouse.DragThreshold := Value;
end;

procedure TJvAppEvents.SetHintShortCuts(Value: Boolean);
begin
  FHintShortCuts := Value;
  if not (csDesigning in ComponentState) then
    Application.HintShortCuts := Value;
end;



function TJvAppEvents.GetBiDiMode: TBiDiMode;
begin
  if csDesigning in ComponentState then
    Result := FBiDiMode
  else
    Result := Application.BiDiMode;
end;

procedure TJvAppEvents.SetBiDiMode(Value: TBiDiMode);
begin
  FBiDiMode := Value;
  if not (csDesigning in ComponentState) then
    Application.BiDiMode := Value;
end;

function TJvAppEvents.GetBiDiKeyboard: string;
begin
  if csDesigning in ComponentState then
    Result := FBiDiKeyboard
  else
    Result := Application.BiDiKeyboard;
end;

function TJvAppEvents.GetNonBiDiKeyboard: string;
begin
  if csDesigning in ComponentState then
    Result := FNonBiDiKeyboard
  else
    Result := Application.NonBiDiKeyboard;
end;

procedure TJvAppEvents.SetBiDiKeyboard(const Value: string);
begin
  FBiDiKeyboard := Value;
  if not (csDesigning in ComponentState) then
    Application.BiDiKeyboard := Value;
end;

procedure TJvAppEvents.SetNonBiDiKeyboard(const Value: string);
begin
  FNonBiDiKeyboard := Value;
  if not (csDesigning in ComponentState) then
    Application.NonBiDiKeyboard := Value;
end;



procedure TJvAppEvents.UpdateAppProps;
begin
  if not (csDesigning in ComponentState) then
  begin
    Application.HintColor := FHintColor;
    Application.HintPause := FHintPause;
    Application.ShowHint := FShowHint;
    Application.HintShortPause := FHintShortPause;
    Application.HintHidePause := FHintHidePause;
    Application.ShowMainForm := FShowMainForm;
    Application.HintShortCuts := FHintShortCuts;
    Application.UpdateFormatSettings := FUpdateFormatSettings;
    Application.UpdateMetricSettings := FUpdateMetricSettings;
    Application.BiDiMode := FBiDiMode;
    Application.BiDiKeyboard := FBiDiKeyboard;
    Application.NonBiDiKeyboard := FNonBiDiKeyboard;
    Mouse.DragImmediate := FMouseDragImmediate;
    Mouse.DragThreshold := FMouseDragThreshold;
  end;
end;

initialization
  {$IFDEF UNITVERSIONING}
  RegisterUnitVersion(HInstance, UnitVersioning);
  {$ENDIF UNITVERSIONING}

finalization
  AppList.Free;
  {$IFDEF UNITVERSIONING}
  UnregisterUnitVersion(HInstance);
  {$ENDIF UNITVERSIONING}

end.

