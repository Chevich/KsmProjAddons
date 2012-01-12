unit XMLMenuTranslation;

 interface

 uses xmldom, XMLDoc, XMLIntf;

 type

   { Forward-Deklarationen }

   IXMLMENUType  = interface;
   IXMLENTRYType = interface;

   { IXMLMENUType }

   IXMLMENUType = interface(IXMLNode)
     ['{8F36F5E2-834F-41D9-918F-9B1A441C9074}']
     { Zugriff auf Eigenschaften }
     function Get_ENTRY: IXMLENTRYType;
     { Methoden & Eigenschaften }
     property ENTRY: IXMLENTRYType read Get_ENTRY;
   end;

   { IXMLENTRYType }

   IXMLENTRYType = interface(IXMLNode)
     ['{AD85CD05-725E-40F8-A8D7-D6EC05FD4360}']
     { Zugriff auf Eigenschaften }
     function Get_CAPTION: WideString;
     function Get_VISIBLE: Integer;
     function Get_ID: Integer;
     function Get_ENTRY: IXMLENTRYType;
     procedure Set_CAPTION(Value: WideString);
     procedure Set_VISIBLE(Value: Integer);
     procedure Set_ID(Value: Integer);
     { Methoden & Eigenschaften }
     property Caption: WideString read Get_CAPTION write Set_CAPTION;
     property Visible: Integer read Get_VISIBLE write Set_VISIBLE;
     property ID: Integer read Get_ID write Set_ID;
     property ENTRY: IXMLENTRYType read Get_ENTRY;
   end;

   { Forward-Deklarationen }

   TXMLMENUType  = class;
   TXMLENTRYType = class;

   { TXMLMENUType }

   TXMLMENUType = class(TXMLNode, IXMLMENUType)
   protected
     { IXMLMENUType }
     function Get_ENTRY: IXMLENTRYType;
   public
     procedure AfterConstruction; override;
   end;

   { TXMLENTRYType }

   TXMLENTRYType = class(TXMLNode, IXMLENTRYType)
   protected
     { IXMLENTRYType }
     function Get_CAPTION: WideString;
     function Get_VISIBLE: Integer;
     function Get_ID: Integer;
     function Get_ENTRY: IXMLENTRYType;
     procedure Set_CAPTION(Value: WideString);
     procedure Set_VISIBLE(Value: Integer);
     procedure Set_ID(Value: Integer);
   public
     procedure AfterConstruction; override;
   end;

   { Globale Funktionen }

 function GetXMLMENU(Doc: IXMLDocument): IXMLMENUType;
 function LoadMENU(const FileName: WideString): IXMLMENUType;
 function NewMENU: IXMLMENUType;

 implementation

 { Globale Funktionen }

 function GetXMLMENU(Doc: IXMLDocument): IXMLMENUType;
 begin
   try
     Result := Doc.GetDocBinding('Template', TXMLMENUType) as IXMLMENUType;
   except
     Result := Doc.GetDocBinding('Error', TXMLMENUType) as IXMLMENUType;
   end;
 end;

 function LoadMENU(const FileName: WideString): IXMLMENUType;
 begin
   Result := LoadXMLDocument(FileName).GetDocBinding('Template', TXMLMENUType) as IXMLMENUType;
 end;

 function NewMENU: IXMLMENUType;
 begin
   Result := NewXMLDocument.GetDocBinding('Template', TXMLMENUType) as IXMLMENUType;
 end;

 { TXMLMENUType }

 procedure TXMLMENUType.AfterConstruction;
 begin
   RegisterChildNode('ENTRY', TXMLENTRYType);
   inherited;
 end;

 function TXMLMENUType.Get_ENTRY: IXMLENTRYType;
 begin
   Result := ChildNodes['ENTRY'] as IXMLENTRYType;
 end;

 { TXMLENTRYType }

 procedure TXMLENTRYType.AfterConstruction;
 begin
   RegisterChildNode('ENTRY', TXMLENTRYType);
   inherited;
 end;

 function TXMLENTRYType.Get_CAPTION: WideString;
 begin
   Result := ChildNodes['NAME'].Text;
 end;

 procedure TXMLENTRYType.Set_CAPTION(Value: WideString);
 begin
   ChildNodes['NAME'].NodeValue := Value;
 end;

 function TXMLENTRYType.Get_VISIBLE: Integer;
 begin
   Result := 1; //ChildNodes['VISIBLE'].NodeValue;
 end;

 procedure TXMLENTRYType.Set_VISIBLE(Value: Integer);
 begin
   //ChildNodes['VISIBLE'].NodeValue := Value;
 end;

 function TXMLENTRYType.Get_ID: Integer;
 begin
   Result := ChildNodes['ID'].NodeValue;
 end;

 procedure TXMLENTRYType.Set_ID(Value: Integer);
 begin
   ChildNodes['ID'].NodeValue := Value;
 end;

 function TXMLENTRYType.Get_ENTRY: IXMLENTRYType;
 begin
   Result := ChildNodes['ENTRY'] as IXMLENTRYType;
 end;

 end.
