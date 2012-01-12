{$DEFINE ForLev}
{$DEFINE EtvAutoInc} (* Calc autoincremental fields at client *)
{$DEFINE SAW} (* Option for Sybase SQL AnyWare *)

{$DEFINE InsDelPopupMenuControls} (* Insert and Delete record by PopupMenu
   and Ctrl+GrayPlus, Ctrl+GrayMinus from EtvDBControl's PopupMenu *)
{ DEFINE NavVisiblePopupMenuControls} (* First, previos, next, last - visible
  in EtvDBControl's PopupMenu (ShortCuts work always, it define only Visible) *)

{$DEFINE BDE_IS_USED} (* BDE is used
                         if you don't use with options take note of
                         OtherQueryClass from EtvOther unit *)

{ DEFINE DBCLIENT_IS_USED} (* DbClient is used *)

{ DEFINE TTableUseEtvComponentEditor} (* Etv dataset componentEditor
                                         (popupmenu in designer) to TTable *)
{ DEFINE TQueryUseEtvComponentEditor} (* Etv dataset componentEditor
                                         (popupmenu in designer) to TQuery *)


{ ---------------------------------------------------- }

{$IFDEF VER120}
  {$DEFINE Delphi4}
{$ENDIF}

{$IFDEF VER130}
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
{$ENDIF}

