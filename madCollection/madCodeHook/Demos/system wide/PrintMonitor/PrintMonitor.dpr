// ***************************************************************
//  PrintMonitor              version:  1.0   ·  date: 2003-06-15
//  -------------------------------------------------------------
//  monitor all important print APIs system wide
//  -------------------------------------------------------------
//  Copyright (C) 1999 - 2003 www.madshi.net, All Rights Reserved
// ***************************************************************

// 2003-06-15 1.0  initial release

program PrintMonitor;

{$R printer.res}
{$R ..\..\needAdminRights.res}

uses
  Forms,
  PrintForm in 'PrintForm.pas' {FPrintMonitor};

// ***************************************************************

begin
  Application.Initialize;
  Application.CreateForm(TFPrintMonitor, FPrintMonitor);
  Application.Run;
end.
