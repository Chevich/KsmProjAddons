			Etv library 3.0

	DB components library for Borland Delphi 3,4. Shareware


		INSTALATION and TUNNING
		=======================

   1. Installation

     1.1. Installation for Delphi 3 without source code
   Open Delphi. Install design-time package DclEtv.dpl

     1.2. Installation for Delphi 3 with source code
   Open Delphi. Close current project. Compile run-time package RtlEtv.dpk
and put compiled files into directory that is accessible through the PATH.
Open and install design-time package DclEtv.dpk
   After it restart Delphi NECESSARILY.

     1.3. Installation for Delphi 4 without source code
   Open Delphi. Install design-time package DclEtv4.bpl 

     1.4. Installation for Delphi 4 with source code
   Open Delphi. Close current project. Compile run-time package RtlEtv4.dpk
and put compiled files into directory that is accessible through the PATH. 
Open and install design-time package DclEtv4.dpk
   After it restart Delphi NECESSARILY.

   2. Tunning

- Redefinition in EtvOther.pas
- Constants in EtvConst.pas
- Options in Etv.inc (version with source code)

   3. Use of T[DB]DateEdit from RX inside Etv library.
Install package EtvRX in Delphi3 or EtvRx4 in Delphi4. Attach unit
EtvRXAdd to your project.

   4. For representation save lookup values in ReportBuilder install
package EtvPP in Delphi3 or EtvPP4 in Delphi4.

   5. Demostration program is in subdirectory Example. Need define alias 
"EtvExample" for paradox for it directory.


		OVERVIEW
		========

	Components for support lookup information
	-----------------------------------------

TEtvLookField, TEtvDBLookupCombo, TEtvDBGrid and other. 
- Show several fields in the closed LookupComboBox  and in the Grid 
- Set filters on lookup list 
- Multilevel lookup with fixed levels and trees 
- Advanced incremental search with showing of input string. Work with numbers. 
- Call LookupDataset edit form and get values from it 
- Direct edit of KeyField in LookupComboBox and Grid 
- Change search/input clolumn 
- Special lookup fields which support all lookup means 
- Save lookup information for use later on (from lookupResultField and other 
  special properties) 
- Components for show saving lookup information 
- Definition TFont for any line from lookup list 
- Header for lookup list. Show fields names or other user information 
- Automatic choice of input column (for "Number;Text" fields) 
- Work in TDBCtrlGrid 
- Other functions and options 

 
	DBGrid 
	------

Component TEtvDBGrid:  
- Powerful lookup fields (see up), support all EtvLookup possibilities 
- List fields 
- Multiline headers, change amount of header rows by column resize  
- Total row at bottom of grid can show any information such as column sums,
  quantity of record and so on 
- Font and color definition for any cell including edit mode 
- Change visibility and order of fields in special dialog. Some fields may be 
  mark as internal and hide always. 
- Print table or one record in text and graphics mode with title, page setup, 
  numbering, choose fonts, line spacing, and etc. Save to text file. 
- Change keyboard layout 
- Clone records 
- Generation edit window of one record 
- User control substitution for any field types. For example, you may use 
  descendant of TDateEdit from RX library as date editor 
- Other functions and options 


	Query and filter builder, sorting and  search records
	-----------------------------------------------------

  Component TEtvFilter.  
End-user definition queries and filters upon single dataset and group of 
datasets linked as master-detail or differently. Automatic substitution of 
your dataset to the generated query and back. May set filter on your dataset 
in simple cases. Conditions set in the special dialog window, user may easy 
define any extracts of information. Save information to the stream and to disk.
You can make (recommend it) yourself procedure for save information in your 
database or anywhere more and set special variable to one. Simple in use, 
set DataSource and call method Execute.  

  Component TEtvDBSortingCombo. 
Change dataset sorting, including SQL datasets (as TQuery). Definition list 
of sorting. List of available sorting may be:
- property Items, with property SelfList=true.
- List of index  - for TTable and similar datasets or other descendant of 
  TDBDataSet  with TableName property (TEtvQuery have that property)
- Property SortingList of dataset. Etv datasets have that property, you can 
  define it in your datasets.

  Component TEtvFindDlg. 
Seek records by sorting fields, including SQL datasets (as TQuery). Show 
dialog with controls for input values of seek. Use parameters "Case sensitive" 
and "Full coincidence". May find nearest record. Simple in use, set DataSource 
and call method Execute.  


	List fields
	-----------

  TEtvListField, TEtvDBCombo and other. 
Field and components for little fixed lists. Text values from list correspond 
with smallint values in database. For example, "small/middle/large" in 
application, "1/2/3" in database. You describe text values in TEtvListField 
and they are used everywhere.


	Call edit forms mechanism & Base db form 
	----------------------------------------

Direct call edit form for any dataset on current form, transmit values there, 
set dataset position,  return values. For example, it is very convenient for 
edit lookup datasets. 

Describe event "OnEditData" in a dataset allow turn form datasets to their 
edit forms. Components TEtvDBLookupCombo and TEtvDbGrid may use it event, put 
current key value (KeyField.Name and KeyField.Value) there, assign returned 
value and refresh lookup information. Form TFormBase may get, use and back it 
values.  

Base Etv db form TFormBase. Automatic open and refresh using datasets, 
generation page for edit one record, filters and queries definition and set, 
sorting, search and refresh of information, auto width by grid of main dataset,
procedures for quick creation and call, other properties that can appear in 
the Object Inspector at design-time.


	Popup menus
	-----------

	RUN-TIME. 
  Popup menus of dbaware controls contain functions of navigation, clone 
record, other functions. Auto attach to controls without popup menu, good 
work shortcuts. 
  
 Functions for different controls:
- DBGrid/EtvDBGrid - fields visibility, print record, print grid, one 
  record/grid, pick length of fields. 
- DBMemo - copy, insert, select all. 
- DBRichEdit/EtvDBRichEdit - font, basic font, paragraph, search/replace, 
  print, copy, insert, select all. 
- DBImage - copy, insert, load from file, save to file, clear, scale 

	DESIGN-TIME. 

 Popup menu of datasets contains: 
- Browse, edit and other operations with data in designer 
- Copy information to clipboard 
- Pump of label from database remarks.  
- Auto correct 
- Info about dataset and fields 
- Popup menus of dbaware controls contain crossing to dataset, crossing to 
  datafield. EtvDBLookupCombo also contain auto size, crossing to lookup 
  dataset.

 Choose of active TabSheet is added to Popup menu of TEtvPageControl, 
as since it is complicated seldom from other controls.


	Other components and mechanisms
	-------------------------------

	Etv datasets
  
- Edit data in design-time; You may call "Base DB form" and  edit, sort, 
  search data, get extracts of information there.   
- Popup menu in designer consists copy to clipboard, pump of label from 
  database remarks, field auto correct, info about dataset and fields. 
- Check mastersource by insert record, i.e. master record must exist and 
  if one is in insert mode call post. 
- Calc autoincrement fields from Delphi for single user applications. 
- Other properties and events 

	TPageControl+TTabSheet. 

  Turn off data on inactive pages for increase speed. Can turn off dbaware 
control from datasource and detail dataset from master.

	Automatic open/refresh of datasets in run-time. 

  This mechanism may open datasets in datamodules (not all, optionally) by 
project open, open or refresh some datasets represented on a form then one 
become active. 

	TEtvPrinter and auxiliary components. 

  Print in text and graphics mode, output to file, page setup, numbering, 
choose fonts including text mode, line spacing and etc. 

	TEtvRecordCloner 

  Clone records of one dataset or of group of datasets linked as master-detail 
or differently. Confirmation clone and on each detail-dataset, events for 
finish of fill for each record. 

	TEtvDBRichEdit

  Transparent search and replace, i.e. can process from record to record, 
dialog for it. Search and replace again. Popup menu with font, basic font, 
paragraph, search/replace, print, copy, insert, select all. 

   Various functions for design and run time, property and component editors. 


    Controls for db fields & Substitution user controls into the library
    --------------------------------------------------------------------

  During work some of etv components, as TEtvFilter, TEtvFindDlg, TFormBase, 
TEtvDbGrid, create controls (dbaware and not) for different data fields. 
For it are used two functions DBEditForField, EditForField. They call special 
functions for different types of fields, which tune controls on fields, put 
to them popup menu with various functions. You can use that functions for 
yourself. 

  Also you can substitute control of any field type, including controls using 
in grid. It controls will used everywhere in Etv library. For example, you 
can use  component TDBDateEdit from RX library as date edit. For that used 
set of variables - functions CreateOtherXXX and CreateOtherDBXXX. You can 
simply assign required variable to your create function. For TEtvDBGrid you 
must use variable CreateOtherDBGridControls.
  

		Thanks
		======

  Thanks to Alex Plas for assist in development of TForm, Alexander Gerus,
Alex Kogan for interesting ideas. 
        
       
		Contact us
		==========

Etv home page	http://etv.tsx.org
		http://etv.da.ru

Igor Kravchenko	igo@grsmi.unibel.by
		igo@gksm.belpak.grodno.by
Lev Zusman

FidoNet 2:451/5.60
