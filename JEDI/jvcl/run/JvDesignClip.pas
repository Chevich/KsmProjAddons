{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvDesingClip.pas, released on 2005-08-21.

The Initial Developer of the Original Code is Scott J Miles
Portions created by Scott J Miles are Copyright (C) 2005 Scott J Miles.
All Rights Reserved.

Contributor(s): Olivier Sannier (JVCL Integration)

You may retrieve the latest version of this file at the Project JEDI's JVCL
home page, located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}
// $Id: JvDesignClip.pas 11755 2008-03-10 17:03:24Z ahuser $
unit JvDesignClip;

{$I jvcl.inc}

interface

uses
  {$IFDEF UNITVERSIONING}
  JclUnitVersioning,
  {$ENDIF UNITVERSIONING}
  Windows, Classes;

type
  TJvDesignComponentClipboard = class(TObject)
  protected
    Stream: TMemoryStream;
    procedure Close;
    procedure Open;
    procedure ReadError(Reader: TReader; const Msg: string; var Handled: Boolean);
  public
    function GetComponent: TComponent;
    procedure CloseRead;
    procedure CloseWrite;
    procedure OpenRead;
    procedure OpenWrite;
    procedure SetComponent(InComponent: TComponent);
  end;

function DesignLoadComponentFromBinaryStream(InStream: TStream;
  InComponent: TComponent; InOnError: TReaderError): TComponent;
procedure DesignSaveComponentToBinaryStream(InStream: TStream; InComponent: TComponent);
procedure DesignCopyStreamFromClipboard(InFmt: Cardinal; InS: TStream);
procedure DesignCopyStreamToClipboard(InFmt: Cardinal; InS: TStream);

{$IFDEF UNITVERSIONING}
const
  UnitVersioning: TUnitVersionInfo = (
    RCSfile: '$URL: https://jvcl.svn.sourceforge.net/svnroot/jvcl/branches/JVCL3_37_PREPARATION/run/JvDesignClip.pas $';
    Revision: '$Revision: 11755 $';
    Date: '$Date: 2008-03-10 18:03:24 +0100 (lun., 10 mars 2008) $';
    LogPath: 'JVCL\run'
  );
{$ENDIF UNITVERSIONING}

implementation

uses
  SysUtils, Clipbrd,
  JvDesignUtils;

var
  CF_COMPONENTSTREAM: UINT;

procedure DesignSaveComponentToBinaryStream(InStream: TStream; InComponent: TComponent);
var
  MS: TMemoryStream;
  SZ: Int64;
begin
  MS := TMemoryStream.Create;
  try
    MS.WriteComponent(InComponent);
    MS.Position := 0;
    SZ := MS.Size;
    InStream.Write(SZ, SizeOf(SZ));
    InStream.CopyFrom(MS, SZ);
  finally
    MS.Free;
  end;
end;

function DesignLoadComponentFromBinaryStream(InStream: TStream;
  InComponent: TComponent; InOnError: TReaderError): TComponent;
var
  MS: TMemoryStream;
  SZ: Int64;
begin
  InStream.Read(SZ, SizeOf(SZ));
  MS := TMemoryStream.Create;
  try
    MS.CopyFrom(InStream, SZ);
    MS.Position := 0;
    with TReader.Create(MS, 4096) do
    try
      OnError := InOnError;
      Result := ReadRootComponent(InComponent);
    finally
      Free;
    end;
  finally
    MS.Free;
  end;
end;

procedure DesignCopyStreamToClipboard(InFmt: Cardinal; InS: TStream);
var
  HMem: THandle;
  PMem: Pointer;
begin
  InS.Position := 0;
  HMem := GlobalAlloc(GHND or GMEM_DDESHARE, InS.Size);
  if HMem <> 0 then
  begin
    PMem := GlobalLock(HMem);
    if PMem <> nil then
    begin
      InS.Read(PMem^, InS.Size);
      InS.Position := 0;
      GlobalUnlock(HMem);
      Clipboard.Open;
      try
        Clipboard.SetAsHandle(InFmt, HMem);
      finally
        Clipboard.Close;
      end;
    end
    else
    begin
      GlobalFree(HMem);
      OutOfMemoryError;
    end;
  end else
    OutOfMemoryError;
end;

procedure DesignCopyStreamFromClipboard(InFmt: Cardinal; InS: TStream);
var
  HMem: THandle;
  PMem: Pointer;
begin
  HMem := Clipboard.GetAsHandle(InFmt);
  if HMem <> 0 then
  begin
    PMem := GlobalLock(HMem);
    if PMem <> nil then
    begin
      InS.Write(PMem^, GlobalSize(HMem));
      InS.Position := 0;
      GlobalUnlock(HMem);
    end;
  end;
end;

//=== { TJvDesignComponentClipboard } ========================================

procedure TJvDesignComponentClipboard.Close;
begin
  Stream.Free;
  Clipboard.Close;
end;

procedure TJvDesignComponentClipboard.CloseRead;
begin
  Close;
end;

procedure TJvDesignComponentClipboard.CloseWrite;
begin
  DesignCopyStreamToClipboard(CF_COMPONENTSTREAM, Stream);
  Close;
end;

function TJvDesignComponentClipboard.GetComponent: TComponent;
begin
  if Stream.Position < Stream.Size then
    Result := DesignLoadComponentFromBinaryStream(Stream, nil, ReadError)
  else
    Result := nil;
end;

procedure TJvDesignComponentClipboard.Open;
begin
  Clipboard.Open;
  Stream := TMemoryStream.Create;
end;

procedure TJvDesignComponentClipboard.OpenRead;
begin
  Open;
  DesignCopyStreamFromClipboard(CF_COMPONENTSTREAM, Stream);
end;

procedure TJvDesignComponentClipboard.OpenWrite;
begin
  Open;
end;

procedure TJvDesignComponentClipboard.ReadError(Reader: TReader;
  const Msg: string; var Handled: Boolean);
begin
  Handled := True;
end;

procedure TJvDesignComponentClipboard.SetComponent(InComponent: TComponent);
begin
  DesignSaveComponentToBinaryStream(Stream, InComponent);
end;

initialization
  { The following string should not be localized }
  CF_COMPONENTSTREAM := RegisterClipboardFormat('Delphi Components');
  {$IFDEF UNITVERSIONING}
  RegisterUnitVersion(HInstance, UnitVersioning);
  {$ENDIF UNITVERSIONING}

finalization
  {$IFDEF UNITVERSIONING}
  UnregisterUnitVersion(HInstance);
  {$ENDIF UNITVERSIONING}

end.

