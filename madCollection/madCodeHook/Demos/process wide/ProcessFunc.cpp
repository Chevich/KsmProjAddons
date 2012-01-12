// ***************************************************************
//  ProcessFunc               version:  1.1   ·  date: 2004-02-29
//  -------------------------------------------------------------
//  simple demo to show process wide function hooking
//  -------------------------------------------------------------
//  Copyright (C) 1999 - 2004 www.madshi.net, All Rights Reserved
// ***************************************************************

// 2004-02-29 1.1  initial release

// ***************************************************************

#include <windows.h>
#include "madCHook.h"

// ***************************************************************

// SomeFunc appends the 2 string parameters and returns the result
LPSTR SomeFunc(LPSTR str1, LPSTR str2)
{
  LPSTR result;

  // call LocalAlloc for the new string
  // we don't care about the memory leak here - hey, it's only a demo  :-)
  result = (LPSTR) LocalAlloc(LPTR, lstrlenA(str1) + lstrlenA(str2) + 1);
  lstrcpyA(result, str1);
  lstrcatA(result, str2);
  return result;
}

// ***************************************************************

// variable for the "next hook", which we then call in the callback function
// it must have *exactly* the same parameters and calling convention as the
// original function
// besides, it's also the parameter that you need to undo the code hook again
LPSTR (*SomeFuncNextHook)(LPSTR str1, LPSTR str2);

// this function is our hook callback function, which will receive
// all calls to the original SomeFunc function, as soon as we've hooked it
// the hook function must have *exactly* the same parameters and calling
// convention as the original function
LPSTR SomeFuncHookProc(LPSTR str1, LPSTR str2)
{
  LPSTR result;

  // manipulate the input parameters
  str1 = "blabla";
  if (!IsBadWritePtr(str2, 5))
    // in MSVC++ 6 our "str2" constant can be written to
    // in later MSVC versions it's write protected...  :-(
    strupr(str2);

  // now call the original function
  result = SomeFuncNextHook(str1, str2);
  // now we can manipulate the result
  return result + 3;
}

// ***************************************************************

int WINAPI WinMain(HINSTANCE hInstance,
                   HINSTANCE hPrevInstance,
                   LPSTR     lpCmdLine,
                   int       nCmdShow)
{
  // InitializeMadCHook is needed only if you're using the static madCHook.lib
  InitializeMadCHook();

  // call the original unhooked function and display the result
  MessageBox(0, SomeFunc("str1", "str2"), "\"str1\" + \"str2\"", 0);
  // now we install our hook on the function ...
  HookCode(SomeFunc, SomeFuncHookProc, (PVOID*) &SomeFuncNextHook);
  // now we install our hook on the function ...
  // the to-be-hooked function must fulfill 2 rules
  // (1) the asm code it must be at least 6 bytes long
  // (2) there must not be a jump into the 2-6th byte anywhere in the code
  // if these rules are not fulfilled the hook is not installed
  // because otherwise we would risk "wild" crashes
  MessageBox(0, SomeFunc("str1", "str2"), "\"str1\" + \"str2\"", 0);
  // we like clean programming, don't we?
  // so we cleanly unhook again
  UnhookCode((PVOID*) &SomeFuncNextHook);

  // FinalizeMadCHook is needed only if you're using the static madCHook.lib
  FinalizeMadCHook();

  return true;
}