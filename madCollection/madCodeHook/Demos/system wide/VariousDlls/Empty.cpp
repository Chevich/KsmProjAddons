// ***************************************************************
//  Empty.dll                 version:  1.0   ·  date: 2003-06-15
//  -------------------------------------------------------------
//  just an empty dll to test dll injection
//  -------------------------------------------------------------
//  Copyright (C) 1999 - 2003 www.madshi.net, All Rights Reserved
// ***************************************************************

// 2003-06-15 1.0  initial release

#include <windows.h>

// ***************************************************************

BOOL WINAPI DllMain(HANDLE hModule, DWORD fdwReason, LPVOID lpReserved)
{
  return true;
}
