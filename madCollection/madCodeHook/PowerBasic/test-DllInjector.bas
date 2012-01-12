' ***************************************************************
'  DllInjector               version:  1.0   ·  date: 2003-06-15
'  -------------------------------------------------------------
'  tool to inject/uninject dlls system wide or user wide
'  -------------------------------------------------------------
'  Copyright (C) 1999 - 2003 www.madshi.net, All Rights Reserved
' ***************************************************************

' 2003-06-15 1.0  initial release

' ***************************************************************
' modified and translated into power basic by jk
' ***************************************************************

#COMPILE EXE

#INCLUDE "win32api.inc"
#INCLUDE "madCHook.inc"

' ***************************************************************


FUNCTION PBMAIN
'***********************************************************************************************
' main
'***********************************************************************************************
LOCAL res AS LONG
   res = InjectLibrary(%ALL_SESSIONS OR %SYSTEM_PROCESSES, "c:\windows\system\test.dll", 7000)
'   res = InjectLibrary(%current_user or %current_process, "c:\windows\system\test.dll", 7000)
'   res = InjectLibrary(%current_user, "c:\windows\system\test.dll", 7000)

MSGBOX STR$(res)

   res = UninjectLibrary(%ALL_SESSIONS OR %SYSTEM_PROCESSES, "c:\windows\system\test.dll", 7000)
'   res = UninjectLibrary(%current_user OR %current_process, "c:\windows\system\test.dll", 7000)
'   res = UninjectLibrary(%current_user, "c:\windows\system\test.dll", 7000)

END FUNCTION


'***********************************************************************************************
'***********************************************************************************************
