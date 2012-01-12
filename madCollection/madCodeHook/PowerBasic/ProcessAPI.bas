' ***************************************************************
'  ProcessAPI                version:  1.0   ·  date: 2003-06-15
'  -------------------------------------------------------------
'  simple demo to show process wide API hooking
'  -------------------------------------------------------------
'  Copyright (C) 1999 - 2003 www.madshi.net, All Rights Reserved
' ***************************************************************

' 2003-06-15 1.0  initial release

'***********************************************************************************************
' translated into power basic by jk
' ***************************************************************

#COMPILE EXE

#INCLUDE "win32api.inc"
#INCLUDE "madCHook.inc"

' variable for the "next hook", which we then call in the callback function
' it must have *exactly* the same parameters and calling convention as the
' original function
' besides, it's also the parameter that you need to undo the code hook again

GLOBAL WinExecNextHook AS DWORD

' this function is our hook callback function, which will receive
' all calls to the original WinExec API, as soon as we've hooked it
' the hook function must have *exactly* the same parameters and calling
' convention as the original API


FUNCTION WinExecHookProc(cmdLine AS ASCIIZ, BYVAL showCmd AS LONG) AS LONG
'***********************************************************************************************
' hook function (watch out for "byval", not only the number and types of parameters are decisive
'                but also the passing method !!!)
'***********************************************************************************************
LOCAL result AS LONG

  ' check the input parameters and ask whether the call should be executed

  IF MessageBox(0, cmdLine, "Execute?", %MB_YESNO OR %MB_ICONQUESTION) = %IDYES THEN
    ' it shall be executed, so let's do it

    CALL DWORD WinExecNextHook USING WinExec(cmdLine, showCmd) TO result
    FUNCTION = result
  ELSE
    ' we don't execute the call, but we should at least return a valid value
    FUNCTION = %ERROR_ACCESS_DENIED
  END IF


END FUNCTION


'***********************************************************************************************
'***********************************************************************************************


FUNCTION PBMAIN
'***********************************************************************************************
' main
'***********************************************************************************************
  ' we install our hook on the API...
  ' please note that in this demo the hook only effects our own process!

  CALL HookAPI("kernel32.dll", "WinExec", CODEPTR(WinExecHookProc), WinExecNextHook, 0)
  ' now call the original (but hooked) API
  ' as a result of the hook the user will receive our messageBox etc

  CALL WinExec("notepad.exe", %SW_SHOWNORMAL)
  ' we like clean programming, don't we?
  ' so we cleanly unhook again

  CALL UnhookAPI(WinExecNextHook)


END FUNCTION


'***********************************************************************************************
'***********************************************************************************************
