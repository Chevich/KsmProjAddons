' ***************************************************************
'  ProcessFunc               version:  1.0   ·  date: 2003-06-15
'  -------------------------------------------------------------
'  simple demo to show process wide function hooking
'  -------------------------------------------------------------
'  Copyright (C) 1999 - 2003 www.madshi.net, All Rights Reserved
' ***************************************************************

' 2003-06-15 1.0  initial release

' ***************************************************************
' translated into power basic by jk
' ***************************************************************

#COMPILE EXE

#INCLUDE "win32api.inc"
#INCLUDE "madCHook.inc"


DECLARE FUNCTION SomeFunc(str1 AS ASCIIZ, str2 AS ASCIIZ) AS STRING


'***********************************************************************************************


FUNCTION SomeFunc(str1 AS ASCIIZ, str2 AS ASCIIZ) AS STRING
'***********************************************************************************************
' SomeFunc appends the 2 string parameters and returns the result
'***********************************************************************************************

  FUNCTION = str1+str2


END FUNCTION


'***********************************************************************************************

' variable for the "next hook", which we then call in the callback function
' it must have *exactly* the same parameters and calling convention as the
' original function
' besides, it's also the parameter that you need to undo the code hook again

GLOBAL SomeFuncNextHook AS DWORD

' this function is our hook callback function, which will receive
' all calls to the original SomeFunc function, as soon as we've hooked it
' the hook function must have *exactly* the same parameters and calling
' convention as the original function


FUNCTION SomeFuncHookProc(str1 AS ASCIIZ, str2 AS ASCIIZ) AS STRING
'***********************************************************************************************
' hook function
'***********************************************************************************************
LOCAL result AS STRING

  ' manipulate the input parameters

  str1 = "blabla"
  str2 = UCASE$(str2)

  ' now call the original function


    CALL DWORD SomeFuncNextHook USING SomeFunc(str1, str2) TO result
    FUNCTION = result


END FUNCTION


'***********************************************************************************************


FUNCTION PBMAIN
'***********************************************************************************************
' main
'***********************************************************************************************

  ' call the original unhooked function and display the result

  MessageBox(0, SomeFunc("str1", "str2"), "str1+str2", 0)

  ' now we install our hook on the function ...

  HookCode(CODEPTR(SomeFunc), CODEPTR(SomeFuncHookProc), SomeFuncNextHook, 0)

  ' now we install our hook on the function ...
  ' the to-be-hooked function must fulfill 2 rules
  ' (1) the asm code it must be at least 6 bytes long
  ' (2) there must not be a jump into the 2-6th byte anywhere in the code
  ' if these rules are not fulfilled the hook is not installed
  ' because otherwise we would risk "wild" crashes

  MessageBox(0, SomeFunc("str1", "str2"), "str1+str2", 0)

  ' we like clean programming, don't we?
  ' so we cleanly unhook again

  UnhookCode(SomeFuncNextHook)


END FUNCTION


'***********************************************************************************************
'***********************************************************************************************
