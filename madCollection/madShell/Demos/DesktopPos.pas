unit DesktopPos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFDesktopSaver = class(TForm)
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FDesktopSaver: TFDesktopSaver;

implementation

{$R *.dfm}

uses madShell, madStrings;

procedure SaveDesktopPositions;
var s1 : string;
    i1 : integer;
    p1 : TPoint;
begin
  with Desktop do
    if IsValid then begin
      s1 := '';
      for i1 := 0 to ItemCount - 1 do begin
        p1 := Items[i1].Position;
        if p1.x <> -1 then
          s1 := s1 + Items[i1].Description + ' ' + IntToStrEx(p1.x, 4) +
                                             '/' + IntToStrEx(p1.y, 4) + #$D#$A;
      end;
      with TFileStream.Create(ShellObj(sfDesktopDir).Path + '\desktop.txt', fmCreate) do
        try
          WriteBuffer(pointer(s1)^, Length(s1));
        finally Free end;
    end;
end;

procedure RestoreDesktopPositions;
var s1, s2 : string;
    i1, i2 : integer;
    p1, p2 : TPoint;
begin
  s1 := ShellObj(sfDesktopDir).Path + '\desktop.txt';
  if GetFileAttributes(pchar(s1)) <> dword(-1) then begin
    with TFileStream.Create(s1, fmOpenRead) do
      try
        SetLength(s1, Size);
        ReadBuffer(pointer(s1)^, Length(s1));
      finally Free end;
    if s1 <> '' then
      with Desktop do
        if IsValid then begin
          i1 := PosStr(#$D#$A, s1);
          i2 := PosStr('/', s1, 1, i1);
          while i1 <> 0 do begin
            if i2 <> 0 then begin
              s2 := Copy(s1, 1, i2 - 6);
              p1.x := StrToIntEx(false, @s1[i2 - 4], 4);
              p1.y := StrToIntEx(false, @s1[i2 + 1], 4);
              for i2 := 0 to ItemCount - 1 do
                if Items[i2].Description = s2 then begin
                  p2 := Items[i2].Position;
                  if int64(p1) <> int64(p2) then
                    Items[i2].SetPosition(p1);
                end;
            end;
            Delete(s1, 1, i1 + 1);
            i1 := PosStr(#$D#$A, s1);
            i2 := PosStr('/', s1, 1, i1);
          end;
        end;
  end;
end;

procedure TFDesktopSaver.Button1Click(Sender: TObject);
begin
  SaveDesktopPositions;
end;

procedure TFDesktopSaver.Button2Click(Sender: TObject);
begin
  RestoreDesktopPositions;
end;

end.
