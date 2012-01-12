// ***************************************************************
//  HookDirect3D.dll          version:  1.0   ·  date: 2006-05-21
//  -------------------------------------------------------------
//  turns all Direct3D 7-9 games to wireframe mode
//  -------------------------------------------------------------
//  Copyright (C) 1999 - 2006 www.madshi.net, All Rights Reserved
// ***************************************************************

// 2006-05-21 1.0a hooks stopped working when d3d dlls got unloaded & reloaded
// 2004-08-15 1.0  initial release

// thanks to Maciej Donotek for his help

library HookDirect3D;

{$IMAGEBASE $59800000}

uses Windows, madCodeHook;

// ***************************************************************

const D3DFILL_WIREFRAME = 2;
      D3DFILL_SOLID     = 3;
      D3DRS_FILLMODE    = 8;

// ***************************************************************************

function GetInterfaceMethod(const intf; methodIndex: dword) : pointer;
begin
  result := pointer(pointer(dword(pointer(intf)^) + methodIndex * 4)^);
end;

// ***************************************************************************
// Direct3D7

var
  DirectDrawCreateExNext : function (guid, directDraw, iid, unkOuter : pointer) : dword; stdcall = nil;
  CreateDevice7Next      : function (self, classId, surface, device  : pointer) : dword; stdcall = nil;
  SetRenderState7Next    : function (self: pointer; stateType, state : dword  ) : dword; stdcall = nil;

function SetRenderState7Callback(self: pointer; stateType, state: dword) : dword; stdcall;
begin
  if stateType = D3DRS_FILLMODE then
    if state = D3DFILL_WIREFRAME then
         state := D3DFILL_SOLID
    else state := D3DFILL_WIREFRAME;
  result := SetRenderState7Next(self, stateType, state);
end;

function CreateDevice7Callback(self, classId, surface, device: pointer) : dword; stdcall;
begin
  result := CreateDevice7Next(self, classId, surface, device);
  if result = 0 then begin
    if @SetRenderState7Next = nil then
      HookCode(GetInterfaceMethod(device^, 20), @SetRenderState7Callback, @SetRenderState7Next)
    else
      RenewHook(@SetRenderState7Next);
    if (device <> nil) and (pointer(device^) <> nil) then
      SetRenderState7Next(pointer(device^), D3DRS_FILLMODE, D3DFILL_WIREFRAME);
  end;
end;

function DirectDrawCreateExCallback(guid, directDraw, iid, unkOuter: pointer) : dword; stdcall;
const Guid_Direct3D7 : TGuid = '{f5049e77-4861-11d2-a407-00a0c90629a8}';
var d3d7 : IUnknown;
begin
  result := DirectDrawCreateExNext(guid, directDraw, iid, unkOuter);
  if result = 0 then
    if @CreateDevice7Next = nil then begin
      if IUnknown(directDraw^).QueryInterface(Guid_Direct3D7, d3d7) = 0 then
        HookCode(GetInterfaceMethod(d3d7, 4), @CreateDevice7Callback, @CreateDevice7Next)
    end else
      RenewHook(@CreateDevice7Next);
end;

function HookDirect3D7 : boolean;
begin
  result := HookAPI('ddraw.dll', 'DirectDrawCreateEx', @DirectDrawCreateExCallback, @DirectDrawCreateExNext);
end;

// ***************************************************************************
// Direct3D8

var
  Direct3DCreate8Next : function (sdkVersion                                         : dword  ) : dword; stdcall = nil;
  CreateDevice8Next   : function (self, adapter, devType, wnd, flags, params, device : pointer) : dword; stdcall = nil;
  SetRenderState8Next : function (self: pointer; stateType, state                    : dword  ) : dword; stdcall = nil;

function SetRenderState8Callback(self: pointer; stateType, state: dword) : dword; stdcall;
begin
  if stateType = D3DRS_FILLMODE then
    if state = D3DFILL_WIREFRAME then
         state := D3DFILL_SOLID
    else state := D3DFILL_WIREFRAME;
  result := SetRenderState8Next(self, stateType, state);
end;

function CreateDevice8Callback(self, adapter, devType, wnd, flags, params, device: pointer) : dword; stdcall;
begin
  result := CreateDevice8Next(self, adapter, devType, wnd, flags, params, device);
  if result = 0 then begin
    if @SetRenderState8Next = nil then
      HookCode(GetInterfaceMethod(device^, 50), @SetRenderState8Callback, @SetRenderState8Next)
    else
      RenewHook(@SetRenderState8Next);
    if (device <> nil) and (pointer(device^) <> nil) then
      SetRenderState8Next(pointer(device^), D3DRS_FILLMODE, D3DFILL_WIREFRAME);
  end;
end;

function Direct3DCreate8Callback(sdkVersion: dword) : dword; stdcall;
begin
  result := Direct3DCreate8Next(sdkVersion);
  if result <> 0 then
    if @CreateDevice8Next = nil then
      HookCode(GetInterfaceMethod(result, 15), @CreateDevice8Callback, @CreateDevice8Next)
    else
      RenewHook(@CreateDevice8Next);
end;

function HookDirect3D8 : boolean;
begin
  result := HookAPI('d3d8.dll', 'Direct3DCreate8', @Direct3DCreate8Callback, @Direct3DCreate8Next);
end;

// ***************************************************************************
// Direct3D9

var
  Direct3DCreate9Next : function (sdkVersion                                         : dword  ) : dword; stdcall = nil;
  CreateDevice9Next   : function (self, adapter, devType, wnd, flags, params, device : pointer) : dword; stdcall = nil;
  SetRenderState9Next : function (self: pointer; stateType, state                    : dword  ) : dword; stdcall = nil;

function SetRenderState9Callback(self: pointer; stateType, state: dword) : dword; stdcall;
begin
  if stateType = D3DRS_FILLMODE then
    if state = D3DFILL_WIREFRAME then
         state := D3DFILL_SOLID
    else state := D3DFILL_WIREFRAME;
  result := SetRenderState9Next(self, stateType, state);
end;

function CreateDevice9Callback(self, adapter, devType, wnd, flags, params, device: pointer) : dword; stdcall;
begin
  result := CreateDevice9Next(self, adapter, devType, wnd, flags, params, device);
  if result = 0 then begin
    if @SetRenderState9Next = nil then
      HookCode(GetInterfaceMethod(device^, 57), @SetRenderState9Callback, @SetRenderState9Next)
    else
      RenewHook(@SetRenderState9Next);
    if (device <> nil) and (pointer(device^) <> nil) then
      SetRenderState9Next(pointer(device^), D3DRS_FILLMODE, D3DFILL_WIREFRAME);
  end;
end;

function Direct3DCreate9Callback(sdkVersion: dword) : dword; stdcall;
begin
  result := Direct3DCreate9Next(sdkVersion);
  if result <> 0 then
    if @CreateDevice9Next = nil then
      HookCode(GetInterfaceMethod(result, 16), @CreateDevice9Callback, @CreateDevice9Next)
    else
      RenewHook(@CreateDevice9Next);
end;

function HookDirect3D9 : boolean;
begin
  result := HookAPI('d3d9.dll', 'Direct3DCreate9', @Direct3DCreate9Callback, @Direct3DCreate9Next);
end;

// ***************************************************************************

begin
  HookDirect3D7;
  HookDirect3D8;
  HookDirect3D9;
end.
