' ***************************************************************
'  madCHook.pas              version:  2.0   ·  date: 2003-08-10
'  -------------------------------------------------------------
'  API hooking, code hooking
'  -------------------------------------------------------------
'  Copyright (C) 1999 - 2003 www.madshi.net, All Rights Reserved
' ***************************************************************
' translated into power basic by jk (might have some bugs, not
' tested in every detail, maybe some "byval" are missing)
' ***************************************************************

' 2003-08-10 2.0  (1) HookCode parameters changed -> only one flags parameter
'                 (2) (Un)InjectLibrary: user/session/system wide injection!
'                 (3) InjectLibrary2 replaced by InjectLibrary (auto detect)
'                 (4) static lib for Microsoft C++ added
'                 (5) CreateIpcQueue + SendIpcMessage + DestroyIpcQueue added
'                 (6) AmSystemProcess + AmUsingInputDesktop added
'                 (7) GetCurrentSessionId + GetInputSessionId added
'                 (8) GetCallingModule function added
'                 (9) ProcessIdToFileName added
'                 (a) Create/OpenGlobalMutex + Event + FileMapping added
'                 (b) WideToAnsi + AnsiToWide functions added
'                 (c) RenewHook function added
'                 (d) madCodeHook.dll -> madCHook.dll (8.3 dos name logic)
'                 (e) UnhookAPI added (= UnhookCode, added just for the look)
'                 (f) AddAccessForEveryone added
' 2002-10-17 1.3f InjectLibrary2(W) was not stdcall (dumb me)
' 2002-10-03 1.3e (1) InjectLibraryW added
'                 (2) InjectLibrary2(W) added for use in CreateProcess(W) hooks
' 2002-09-22 1.3d CreateProcessExW added
' 2002-03-24 1.3c CollectHooks/FlushHooks speed up mixture initialization
' 2002-02-24 1.3b LPSTARTUPINFO -> LPSTARTUPINFOA
' 2002-01-21 1.3a ProcessHandleToId exported
' 2001-07-08 1.3  new functions (1) AllocMemEx & FreeMemEx
'                               (2) CopyFunction
'                               (3) CreateRemoteThread and
'                               (4) InjectLibrary added
' 2001-04-20 1.2a you can now force HookCode/API to use the mixture mode
' 2001-04-16 1.2  new function CreateProcessEx -> dll injecting


' ***************************************************************




' ***************************************************************
' Constants
' ***************************************************************

  ' by default madCodeHook counts how many times any thread is currently
  ' running inside of your callback function
  ' this way unhooking can be safely synchronized to that counter
  ' sometimes you don't need/want this counting to happen, e.g.
  ' (1) if you don't plan to ever unhook, anyway
  ' (2) if the counting performance drop is too high for your taste
  ' (3) if you want to unhook from inside the hook callback function
  ' in those cases you can set the flag "DONT_COUNT"
  %DONT_COUNT = &H00000001

  ' madCodeHook implements two different API hooking methods
  ' the mixture mode is the second best method, it's only used if the main
  ' hooking method doesn't work for whatever reason (e.g. API code structure)
  ' normally madCodeHook chooses automatically which mode to use
  ' you can force madCodeHook to use the mixture mode by specifying this flag:
  %MIXTURE_MODE = &H00000002

  ' under win9x you can hook code system wide, if it begins > &H80000000
  ' or if the code section of the to-be-hooked dll is shared
  ' the callback function is in this case automatically copied to shared memory
  ' use only kernel32 APIs in such a system wide hook callback function (!!)
  ' if you want an easier way and/or a NT family compatible way to hook code
  ' system wide, please use InjectLibrary(ALL_SESSIONS) instead of these flags:
  %SYSTEM_WIDE_9X            = &H00000004
  %ACCEPT_UNKNOWN_TARGETS_9X = &H00000008


' hook any code or a specific API
DECLARE FUNCTION HookCode LIB "madCHook.DLL" ALIAS "HookCode" _
                  (BYVAL code            AS DWORD, _
                   BYVAL lpcallbackFunc  AS DWORD, _
                   nextHook              AS DWORD, _
                   BYVAL flags           AS DWORD) AS LONG 'returns true/false

DECLARE FUNCTION HookAPI LIB "madCHook.DLL" ALIAS "HookAPI" _
                 (module                AS ASCIIZ, _
                  api                   AS ASCIIZ, _
                  BYVAL lpcallbackFunc  AS DWORD, _
                  nextHook              AS DWORD, _
                  BYVAL flags           AS DWORD) AS LONG 'returns true/false

' some firewall/antivirus programs kill our hooks, so we need to renew them
DECLARE FUNCTION RenewHook LIB "madCHook.DLL" ALIAS "RenewHook" _
                 (nextHook AS DWORD) AS LONG          'returns true/false

' unhook again
DECLARE FUNCTION UnhookCode LIB "madCHook.DLL" ALIAS "UnhookCode" _
                 (nextHook AS DWORD) AS LONG          'returns true/false

DECLARE FUNCTION UnhookAPI LIB "madCHook.DLL" ALIAS "UnhookAPI" _
                 (nextHook AS DWORD) AS LONG          'returns true/false


' putting all your "HookCode/API" calls into a "CollectHooks".."FlushHooks"
' frame can eventually speed up the installation of the hooks

DECLARE SUB CollectHooks LIB "madCHook.DLL" ALIAS "CollectHooks"
DECLARE SUB   FlushHooks LIB "madCHook.DLL" ALIAS "FlushHooks"

' ***************************************************************
' same as CreateProcess
' additionally the dll "loadLibrary" is injected into the newly created process
' the dll is loaded right before the entry point of the exe module is called


DECLARE FUNCTION CreateProcessEx LIB "madCHook.DLL" ALIAS "CreateProcessEx" _
                 (lpApplicationName AS ASCIIZ, _
                  lpCommandLine AS ASCIIZ, _
                  lpProcessAttributes AS SECURITY_ATTRIBUTES, _
                  lpThreadAttributes AS SECURITY_ATTRIBUTES, _
                  BYVAL bInheritHandles AS LONG, _
                  BYVAL dwCreationFlags AS DWORD, _
                  lpEnvironment AS ANY, _
                  lpCurrentDirectory AS ASCIIZ, _
                  lpStartupInfo AS STARTUPINFO, _
                  lpProcessInformation AS PROCESS_INFORMATION, _
                  loadLibrary AS ASCIIZ) AS LONG       'returns true/false


' ***************************************************************
' memory allocation in the specified processes (shared memory in win9x)
' if the processHandle is 0, the memory is allocated or freed in the shared
' area (in win9x) or in our own process (in winNT)

DECLARE FUNCTION AllocMemEx LIB "madCHook.DLL" ALIAS "AllocMemEx" _
                 (BYVAL iSIZE         AS DWORD, _
                  BYVAL processHandle AS DWORD) AS LONG 'returns pointer to memory

DECLARE FUNCTION  FreeMemEx LIB "madCHook.DLL" ALIAS "FreeMemEx" _
                 (pMem                AS DWORD, _
                 BYVAL processHandle  AS DWORD) AS LONG 'returns true/false

' ***************************************************************
' copy (and relocate) any function to a new location in any process
' if the processHandle is 0, the function is copied to shared area (in win9x)
' or to another memory location in our own process (in winNT)
' don't forget to free the function with FreeMemEx, if you don't it anymore

DECLARE FUNCTION CopyFunction LIB "madCHook.DLL" ALIAS "CopyFunction" _
                      (pFunction                  AS DWORD, _
                       BYVAL processHandle        AS DWORD, _
                       BYVAL acceptUnknownTargets AS LONG, _
                       buffer                     AS DWORD) AS LONG 'returns true/false


' ***************************************************************
' like CreateRemoteThread, but 3 changes:
' (1) this one also works perfectly in win9x!!
' (2) this one also works on other sessions in winNt
' (3) the DACL of the current thread is copied in winNt (if threadAttr = nil)

DECLARE FUNCTION CreateRemoteThreadEx LIB "madCHook.DLL" ALIAS "CreateRemoteThreadEx" _
                (BYVAL hProcess        AS DWORD, _
                 lpThreadAttributes    AS SECURITY_ATTRIBUTES, _
                 BYVAL dwStackSize     AS DWORD, _
                 BYVAL lpStartAddress  AS DWORD, _
                 lpParameter           AS ANY, _
                 BYVAL dwCreationFlags AS DWORD, _
                 lpThreadId AS DWORD)  AS DWORD       'returns handle of created thread



' ***************************************************************

' this is how your remote function must look like
' FUNCTION TRemoteExecuteFunction (params AS DWORD) AS LONG 'returns true/false

' executes the specified function in the context of another process
' this works only if the function follows some specific rules
' e.g. it must not use global variables, nor Delphi private functions
' only win32 APIs are allowed
' don't use Delphi strings, since they end up in local Delphi function calls
' if "size" > 0, the "params" block will be copied to the other process
' after the remote function is finished, the "params" block is copied back
' so you can use the "params" block for both "in" and "out" parameters
' if "size" = 0, the "params" value is just given into the remote function
DECLARE FUNCTION RemoteExecute LIB "madCHook.DLL" ALIAS "RemoteExecute" _
                       (BYVAL processHandle     AS DWORD, _
                        pTRemoteExecuteFunction AS DWORD, _
                        funcResult              AS DWORD, _
                        params                  AS DWORD , _
                        BYVAL iSIZE             AS DWORD) AS LONG 'returns true/false


' ***************************************************************
' Constant
' ***************************************************************

  ' (un)inject the specified dll into (from) all current and future processes
  ' these flags can be used for both UninjectLibrary + InjectLibrary
  %ALL_SESSIONS     = &H0FFFFFFED  ' apps of all sessions
  %CURRENT_SESSION  = &H0FFFFFFEC  ' apps of current session
  %CURRENT_USER     = &H0FFFFFFEB  ' apps of current user

  ' the following flags may only be used in combination with the first 3 flags
  %SYSTEM_PROCESSES = &H00000010  ' include this flag to include system processes + services
  %CURRENT_PROCESS  = &H00000008  ' exclude this flag to exclude injection into yourself

' same as LoadLibrary, but this one is able to load the library into any process
DECLARE FUNCTION InjectLibrary LIB "madCHook.DLL" ALIAS "InjectLibraryA" _
                 (BYVAL processHandleorflags  AS DWORD, _
                  libFileName         AS ASCIIZ, _
                  BYVAL iTIMEOUT      AS DWORD) AS LONG 'returns true/false

' same as InjectLibrary(CURRENT_SESSION, ...), but you can choose the session
DECLARE FUNCTION InjectLibrarySession LIB "madCHook.DLL" ALIAS "InjectLibrarySessionA" _
                (BYVAL session         AS DWORD, _
                 BYVAL systemProcesses AS LONG, _
                 libFileName           AS ASCIIZ, _
                 BYVAL iTIMEOUT        AS DWORD) AS LONG 'returns true/false


' ***************************************************************
' Constant
' ***************************************************************

  ' stop the "virus" injection effect (can be used for UninjectLibrary only)
  %STOP_VIRUS = &HFFFFFFFA

' same as FreeLibrary, but is able to free the library from any process
DECLARE FUNCTION UninjectLibrary LIB "madCHook.DLL" ALIAS "UninjectLibraryA" _
                 (BYVAL processHandleorflags AS DWORD, _
                  libFileName         AS ASCIIZ, _
                  BYVAL iTIMEOUT      AS DWORD) AS LONG 'returns true/false

' same as UninjectLibrary(CURRENT_SESSION, ...), but you can choose the session
DECLARE FUNCTION UninjectLibrarySession LIB "madCHook.DLL" ALIAS "UninjectLibrarySessionA" _
                 (BYVAL session         AS DWORD, _
                  BYVAL systemProcesses AS LONG, _
                  libFileName           AS ASCIIZ, _
                  BYVAL iTIMEOUT        AS DWORD) AS LONG 'returns true/false

' ***************************************************************

' which processId belongs to the specified process handle?
' undocumented function, works in all windows 32 bit systems
DECLARE FUNCTION ProcessHandleToId LIB "madCHook.DLL" ALIAS "ProcessHandleToId" _
                 (BYVAL processHandle AS DWORD) AS DWORD 'returns id


' find out what file the specified process was executed from
' the file name buffer must have a size of MAX_PATH characters (or more)
DECLARE FUNCTION ProcessIdToFileName LIB "madCHook.DLL" ALIAS "ProcessIdToFileName" _
                 (BYVAL processId AS DWORD, _
                  fileName        AS ASCIIZ) AS LONG  'returns true/false

' ***************************************************************

' is the current process a service/system process?  (win9x -> always false)
DECLARE FUNCTION AmSystemProcess LIB "madCHook.DLL" ALIAS "AmSystemProcess" _
                 AS LONG 'returns true/false external 'madCHook.dll';

' is the current thread's desktop the input desktop?  (win9x -> always true)
' only in that case you should show messages boxes or other GUI stuff
' but please note that in XP fast user switching AmUsingInputDesktop may
' return true, although the current session is currently not visible
' XP fast user switching is implemented by using terminal server logic
' so each fast user session has its own window station and input desktop
DECLARE FUNCTION AmUsingInputDesktop LIB "madCHook.DLL" ALIAS "AmUsingInputDesktop" _
                 AS LONG 'returns true/false external 'madCHook.dll';

' the following two functions can be used to get the session id of the
' current session and of the input session
' each terminal server (or XP fast user switching) session has its own id
' the "input session" is the one currently shown on the physical screen
DECLARE FUNCTION GetCurrentSessionId LIB "madCHook.DLL" ALIAS "GetCurrentSessionId" _
                 AS LONG 'returns id
DECLARE FUNCTION GetInputSessionId LIB "madCHook.DLL" ALIAS "GetInputSessionId" _
                 AS LONG 'returns id

' ***************************************************************

' which module called me? works only if your function has a stack frame
DECLARE FUNCTION GetCallingModule LIB "madCHook.DLL" ALIAS "GetCallingModule" _
                 AS LONG 'returns module handletrue/false


' ***************************************************************
' global  =  normal  +  "access for everyone"  +  "non session specific"

DECLARE FUNCTION CreateGlobalMutex LIB "madCHook.DLL" ALIAS "CreateGlobalMutex" _
                 (iNAME AS ASCIIZ) AS LONG 'returns handle

DECLARE FUNCTION   OpenGlobalMutex LIB "madCHook.DLL" ALIAS "OpenGlobalMutex" _
                   (iNAME AS ASCIIZ) AS LONG 'returns handle

DECLARE FUNCTION CreateGlobalEvent LIB "madCHook.DLL" ALIAS "CreateGlobalEvent" _
                 (iNAME        AS ASCIIZ, _
                  manual       AS LONG, _
                  initialState AS LONG) AS LONG 'returns handle

DECLARE FUNCTION   OpenGlobalEvent LIB "madCHook.DLL" ALIAS "OpenGlobalEvent" _
                   (iNAME AS ASCIIZ) AS LONG 'returns handle

DECLARE FUNCTION CreateGlobalFileMapping LIB "madCHook.DLL" ALIAS "CreateGlobalFileMapping" _
                 (iNAME       AS ASCIIZ, _
                  BYVAL iSIZE AS DWORD) AS LONG 'returns handle

DECLARE FUNCTION   OpenGlobalFileMapping LIB "madCHook.DLL" ALIAS "OpenGlobalFileMapping" _
                   (iNAME        AS ASCIIZ, _
                    BYVAL iWRITE AS LONG) AS LONG 'returns handle

' ***************************************************************

' convert strings ansi <-> wide
' the result buffer must have a size of MAX_PATH characters (or more)
' please use these functions in nt wide API hook callback functions
' because the OS' own functions seem to confuse nt in hook callback functions

'***********************************************************************************************
'***********************************************************************************************
'procedure AnsiToWide (ansi AS ASCIIZ; wide: pwidechar); STDCALL; external 'madCHook.dll';
'procedure WideToAnsi (wide: pwidechar; ansi AS ASCIIZ); STDCALL; external 'madCHook.dll';
'***********************************************************************************************
'***********************************************************************************************


' ***************************************************************
' ipc (inter process communication) message services
' in contrast to SendMessage the following functions don't crash NT services

  ' this is how you get notified about incoming ipc messages
  ' you have to write a function which fits to this type definition
  ' and then you give it into "CreateIpcQueue"
  ' your callback function will then be called for each incoming message
  ' CAUTION: each ipc message is handled by a seperate thread, as a result
  '          your callback will be called by a different thread each time

'  FUNCTION TIpcCallback    (iNAME            AS ASCIIZ, _
'                            messageBuf       AS DWORD, _
'                            BYVAL messageLen AS DWORD, _
'                            answerBuf        AS DWORD, _
'                            BYVAL answerLen  AS DWORD) AS LONG
'

' create an ipc queue
' please choose a unique ipc name to avoid conflicts with other programs
' only one ipc queue with the same name can be open at the same time
' so if 2 programs try to create the same ipc queue, the second call will fail
DECLARE FUNCTION CreateIpcQueue LIB "madCHook.DLL" ALIAS "CreateIpcQueue" _
                 (ipc       AS ASCIIZ, _
                  pCALLBACK AS DWORD) AS LONG 'returns true/false


' send an ipc message to whomever has created the ipc queue (doesn't matter)
' if you only fill the first 3 parameters, SendIpcMessage returns at once
' if you fill the next two parameters, too, SendIpcMessage will
' wait for an answer of the ipc queue owner
' you can further specify how long you're willing to wait for the answer
' and whether you want SendIpcMessage to handle messages while waiting
DECLARE FUNCTION SendIpcMessage LIB "madCHook.DLL" ALIAS "SendIpcMessage" _
                 (ipc                  AS ASCIIZ, _
                  messageBuf           AS DWORD, _
                  BYVAL messageLen     AS DWORD, _
                  answerBuf            AS DWORD, _
                  BYVAL answerLen      AS DWORD, _
                  BYVAL answerTimeOut  AS DWORD, _
                  BYVAL handleMessages AS LONG) AS LONG 'returns true/false


' destroy the ipc queue again
' when the queue owning process quits, the ipc queue is automatically deleted
' only the queue owning process can destroy the queue
DECLARE FUNCTION DestroyIpcQueue LIB "madCHook.DLL" ALIAS "DestroyIpcQueue" _
                 (ipc AS ASCIIZ) AS LONG 'returns true/false

' ***************************************************************
