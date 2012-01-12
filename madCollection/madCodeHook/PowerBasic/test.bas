' ***************************************************************
'  SystemAPI                 version:  1.0   ·  date: 2003-06-15
'  -------------------------------------------------------------
'  demo to show a special mode (9x only) system wide API hooking
'  -------------------------------------------------------------
'  Copyright (C) 1999 - 2003 www.madshi.net, All Rights Reserved
' ***************************************************************

' 2003-06-15 1.0  initial release

' ***************************************************************
' modified and translated into power basic by jk
' ***************************************************************

#COMPILE DLL "c:\windows\system\test.dll"
'***********************************************************************************************
' madCHook.dll must be in your system directory !!!
'***********************************************************************************************

#INCLUDE "win32api.inc"
#INCLUDE "madCHook.inc"

' ***************************************************************

' variable for the "next hook", which we then call in the callback function
' it must have *exactly* the same parameters and calling convention as the
' original function
' besides, it's also the parameter that you need to undo the code hook again

GLOBAL CreateProcessNextHook AS DWORD

' this function is our hook callback function, which will (system wide!) receive
' all calls to the original CreateProcess function, as soon as we've hooked it
' the hook function must have *exactly* the same parameters and calling
' convention as the original function

FUNCTION CreateProcessHookProc (lpApplicationName AS ASCIIZ, _
                                lpCommandLine AS ASCIIZ, _
                                lpProcessAttributes AS SECURITY_ATTRIBUTES, _
                                lpThreadAttributes AS SECURITY_ATTRIBUTES,  _
                                BYVAL bInheritHandles AS LONG, _
                                BYVAL dwCreationFlags AS DWORD, _
                                lpEnvironment AS DWORD, _
                                lpCurrentDirectory AS ASCIIZ, _
                                lpStartupInfo AS STARTUPINFO, _
                                lpProcessInformation AS PROCESS_INFORMATION) AS LONG
'***********************************************************************************************
' hook function
'***********************************************************************************************
LOCAL result AS LONG


  ' this function will be called from every process that calls CreateProcess
  ' some processes might have imported kernel32.dll, but NOT user32.dll
  ' and in such a process we can't call MessageBox, because it's in user32.dll
  ' as a result that means, you should only call APIs of kernel32.dll in your
  ' callback function, because only this dll is loaded in really every process
  ' but for our demo we are ignorant and do what we should not do namely call
  ' a non-kernel32.dll API in our system wide hook callback function

  IF MessageBox(0, lpCommandLine, byval 0, %MB_YESNO OR %MB_ICONQUESTION) <> %IDYES THEN

    ' well, the user decided that the CreateProcess call should not be executed
    ' so we need to set up a correct LastError value

    SetLastError(%ERROR_ACCESS_DENIED)
    FUNCTION = %false
  ELSE
    ' the user decided to let the CreateProcess call happen, so we do it
    ' if we would call CreateProcess here, we would end up calling ourselves again
    ' so we call "CreateProcessNextHook" of course

    CALL DWORD CreateProcessNextHook USING CreateProcess(lpApplicationName, lpCommandLine, _
                                     lpProcessAttributes, lpThreadAttributes, _
                                     bInheritHandles, dwCreationFlags, _
                                     lpEnvironment, lpCurrentDirectory, _
                                     lpStartupInfo, lpProcessInformation) TO result
    FUNCTION = result
    CALL renewhook(CreateProcessNextHook)
  END IF


END FUNCTION


' ***************************************************************


FUNCTION LIBMAIN(BYVAL hInstance   AS LONG, _
                 BYVAL fwdReason   AS LONG, _
                 BYVAL lpvReserved AS LONG) EXPORT AS LONG
'**********************************************************************************************

  SELECT CASE fwdReason

    CASE %DLL_PROCESS_ATTACH
      CALL HookAPI("kernel32.dll", "CreateProcessA", CODEPTR(CreateProcessHookProc), CreateProcessNextHook, 0)
      LIBMAIN = 1                       'success!
      EXIT FUNCTION
    CASE %DLL_PROCESS_DETACH
      CALL UnhookAPI(CreateProcessNextHook)
      LIBMAIN = 1                       'success!
      EXIT FUNCTION
    CASE %DLL_THREAD_ATTACH
      LIBMAIN = 1                       'success!
      EXIT FUNCTION
    CASE %DLL_THREAD_DETACH
      LIBMAIN = 1                       'success!
      EXIT FUNCTION
  END SELECT

END FUNCTION


'***********************************************************************************************
'***********************************************************************************************
