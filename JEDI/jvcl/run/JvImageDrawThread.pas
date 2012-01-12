{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvImageRotate.PAS, released on 2001-02-28.

The Initial Developer of the Original Code is S�bastien Buysse [sbuysse att buypin dott com]
Portions created by S�bastien Buysse are Copyright (C) 2001 S�bastien Buysse.
All Rights Reserved.

Contributor(s):
Michael Beck [mbeck att bigfoot dott com].
Extracted from JvImageThread and saved to a new unit by Peter Th�rnqvist

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}
// $Id: JvImageDrawThread.pas 11400 2007-06-28 21:24:06Z ahuser $

unit JvImageDrawThread;

{$I jvcl.inc}

interface

uses
  {$IFDEF UNITVERSIONING}
  JclUnitVersioning,
  {$ENDIF UNITVERSIONING}
  Windows,
  Classes;

type
  TJvImageDrawThread = class(TThread)
  private
    FTag: Integer;
    FDelay: Cardinal;
    FOnDraw: TNotifyEvent;
  protected
    procedure Draw;
    procedure Execute; override;
  public
    property Tag: Integer read FTag write FTag;
    property Delay: Cardinal read FDelay write FDelay;
    property OnDraw: TNotifyEvent read FOnDraw write FOnDraw;
    property Terminated;
  end;

{$IFDEF UNITVERSIONING}
const
  UnitVersioning: TUnitVersionInfo = (
    RCSfile: '$URL: https://jvcl.svn.sourceforge.net/svnroot/jvcl/branches/JVCL3_37_PREPARATION/run/JvImageDrawThread.pas $';
    Revision: '$Revision: 11400 $';
    Date: '$Date: 2007-06-28 23:24:06 +0200 (jeu., 28 juin 2007) $';
    LogPath: 'JVCL\run'
  );
{$ENDIF UNITVERSIONING}

implementation


procedure TJvImageDrawThread.Draw;
begin
  if not Terminated and Assigned(FOnDraw) then
    FOnDraw(Self);
end;

procedure TJvImageDrawThread.Execute;
begin
  try
    while not Terminated do
    begin
      Sleep(FDelay);
      Synchronize(Draw);
    end;
  except
    // ignore exception
  end;
end;

{$IFDEF UNITVERSIONING}
initialization
  RegisterUnitVersion(HInstance, UnitVersioning);

finalization
  UnregisterUnitVersion(HInstance);
{$ENDIF UNITVERSIONING}

end.
