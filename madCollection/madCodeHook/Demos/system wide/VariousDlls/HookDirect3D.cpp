// ***************************************************************
//  HookDirect3D.dll          version:  1.0a  ·  date: 2006-05-21
//  -------------------------------------------------------------
//  turns all Direct3D 7-9 games to wireframe mode
//  -------------------------------------------------------------
//  Copyright (C) 1999 - 2006 www.madshi.net, All Rights Reserved
// ***************************************************************

// 2006-05-21 1.0a hooks stopped working when d3d dlls got unloaded & reloaded
// 2004-08-15 1.0  initial release

// thanks to Maciej Donotek for his help

// ***************************************************************

#include <windows.h>
#include "madCHook.h"

// ***************************************************************

#define D3DFILL_WIREFRAME 2
#define D3DFILL_SOLID     3
#define D3DRS_FILLMODE    8

const GUID IID_IDirect3D7 = { 0xf5049e77,0x4861,0x11d2, { 0xa4,0x7,0x0,0xa0,0xc9,0x6,0x29,0xa8 } };

// ***************************************************************

PVOID GetInterfaceMethod(PVOID intf, DWORD methodIndex)
{
  return *(PVOID*)(*(DWORD*)intf + methodIndex * 4);
}

// ***************************************************************
// Direct3D7

HRESULT (WINAPI *DirectDrawCreateExNext) (PVOID guid, IUnknown** directDraw, PVOID iid, PVOID unkOuter);
HRESULT (WINAPI      *CreateDevice7Next) (PVOID self, PVOID classId, PVOID surface, PVOID* device);
HRESULT (WINAPI    *SetRenderState7Next) (PVOID self, DWORD stateType, DWORD state);

HRESULT WINAPI SetRenderState7Callback(PVOID self, DWORD stateType, DWORD state)
{
  if (stateType == D3DRS_FILLMODE) {
    if (state == D3DFILL_WIREFRAME) state = D3DFILL_SOLID;
    else                            state = D3DFILL_WIREFRAME;
  }
  return SetRenderState7Next(self, stateType, state);
}

HRESULT WINAPI CreateDevice7Callback(PVOID self, PVOID classId, PVOID surface, PVOID* device)
{
  HRESULT result = CreateDevice7Next(self, classId, surface, device);
  if ( !result ) {
    if ( !SetRenderState7Next )
      HookCode(GetInterfaceMethod(*device, 20), SetRenderState7Callback, (PVOID*) &SetRenderState7Next);
    else
      RenewHook((PVOID*) &SetRenderState7Next);
    if ( device && *device )
      SetRenderState7Next(*device, D3DRS_FILLMODE, D3DFILL_WIREFRAME);
  }
  return result;
}

HRESULT WINAPI DirectDrawCreateExCallback(PVOID guid, IUnknown** directDraw, PVOID iid, PVOID unkOuter)
{
  HRESULT result = DirectDrawCreateExNext(guid, directDraw, iid, unkOuter);
  IUnknown* d3d7;
  if ( !result ) {
    if ( !CreateDevice7Next ) {
      if ( !(*directDraw)->QueryInterface(IID_IDirect3D7, (PVOID*) &d3d7) ) {
        HookCode(GetInterfaceMethod(d3d7, 4), CreateDevice7Callback, (PVOID*) &CreateDevice7Next);
        d3d7->Release();
      }
    } else
      RenewHook((PVOID*) &CreateDevice7Next);
  }
  return result;
}

BOOL HookDirect3D7()
{
  return HookAPI("ddraw.dll", "DirectDrawCreateEx", DirectDrawCreateExCallback, (PVOID*) &DirectDrawCreateExNext);
}

// ***************************************************************
// Direct3D8

PVOID   (WINAPI *Direct3DCreate8Next) (DWORD sdkVersion);
HRESULT (WINAPI   *CreateDevice8Next) (PVOID self, DWORD adapter, DWORD devType, HWND wnd, DWORD flags, PVOID params, PVOID* device);
HRESULT (WINAPI *SetRenderState8Next) (PVOID self, DWORD stateType, DWORD state);

HRESULT WINAPI SetRenderState8Callback(PVOID self, DWORD stateType, DWORD state)
{
  if (stateType == D3DRS_FILLMODE) {
    if (state == D3DFILL_WIREFRAME) state = D3DFILL_SOLID;
    else                            state = D3DFILL_WIREFRAME;
  }
  return SetRenderState8Next(self, stateType, state);
}

HRESULT WINAPI CreateDevice8Callback(PVOID self, DWORD adapter, DWORD devType, HWND wnd, DWORD flags, PVOID params, PVOID* device)
{
  HRESULT result = CreateDevice8Next(self, adapter, devType, wnd, flags, params, device);
  if ( !result ) {
    if ( !SetRenderState8Next )
      HookCode(GetInterfaceMethod(*device, 50), SetRenderState8Callback, (PVOID*) &SetRenderState8Next);
    else
      RenewHook((PVOID*) &SetRenderState8Next);
    if ( device && *device )
      SetRenderState8Next(*device, D3DRS_FILLMODE, D3DFILL_WIREFRAME);
  }
  return result;
}

PVOID WINAPI Direct3DCreate8Callback(DWORD sdkVersion)
{
  PVOID result = Direct3DCreate8Next(sdkVersion);
  if ( result )
    if ( !CreateDevice8Next )
      HookCode(GetInterfaceMethod(result, 15), CreateDevice8Callback, (PVOID*) &CreateDevice8Next);
    else
      RenewHook((PVOID*) &CreateDevice8Next);
  return result;
}

BOOL HookDirect3D8()
{
  return HookAPI("d3d8.dll", "Direct3DCreate8", Direct3DCreate8Callback, (PVOID*) &Direct3DCreate8Next);
}

// ***************************************************************
// Direct3D9

PVOID   (WINAPI *Direct3DCreate9Next) (DWORD sdkVersion);
HRESULT (WINAPI   *CreateDevice9Next) (PVOID self, DWORD adapter, DWORD devType, HWND wnd, DWORD flags, PVOID params, PVOID* device);
HRESULT (WINAPI *SetRenderState9Next) (PVOID self, DWORD stateType, DWORD state);

HRESULT WINAPI SetRenderState9Callback(PVOID self, DWORD stateType, DWORD state)
{
  if (stateType == D3DRS_FILLMODE) {
    if (state == D3DFILL_WIREFRAME) state = D3DFILL_SOLID;
    else                            state = D3DFILL_WIREFRAME;
  }
  return SetRenderState9Next(self, stateType, state);
}

HRESULT WINAPI CreateDevice9Callback(PVOID self, DWORD adapter, DWORD devType, HWND wnd, DWORD flags, PVOID params, PVOID* device)
{
  HRESULT result = CreateDevice9Next(self, adapter, devType, wnd, flags, params, device);
  if ( !result ) {
    if ( !SetRenderState9Next )
      HookCode(GetInterfaceMethod(*device, 57), SetRenderState9Callback, (PVOID*) &SetRenderState9Next);
    else
      RenewHook((PVOID*) &SetRenderState9Next);
    if ( device && *device )
      SetRenderState9Next(*device, D3DRS_FILLMODE, D3DFILL_WIREFRAME);
  }
  return result;
}

PVOID WINAPI Direct3DCreate9Callback(DWORD sdkVersion)
{
  PVOID result = Direct3DCreate9Next(sdkVersion);
  if ( result )
    if ( !CreateDevice9Next )
      HookCode(GetInterfaceMethod(result, 16), CreateDevice9Callback, (PVOID*) &CreateDevice9Next);
    else
      RenewHook((PVOID*) &CreateDevice9Next);
  return result;
}

BOOL HookDirect3D9()
{
  return HookAPI("d3d9.dll", "Direct3DCreate9", Direct3DCreate9Callback, (PVOID*) &Direct3DCreate9Next);
}

// ***************************************************************

BOOL WINAPI DllMain(HANDLE hModule, DWORD fdwReason, LPVOID lpReserved)
{
  if (fdwReason == DLL_PROCESS_ATTACH) {
    // InitializeMadCHook is needed only if you're using the static madCHook.lib
    InitializeMadCHook();

    HookDirect3D7();
    HookDirect3D8();
    HookDirect3D9();

  } else if (fdwReason == DLL_PROCESS_DETACH)
    // FinalizeMadCHook is needed only if you're using the static madCHook.lib
    FinalizeMadCHook();

  return true;
}
