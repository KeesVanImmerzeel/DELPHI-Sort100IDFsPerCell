unit uSort100IDFsPerCell;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uError, {uProgramSettings,} Vcl.StdCtrls,
  uTabstractESRIgrid, uTSingleESRIgrid, LargeArrays, SHELLAPI, Vcl.ExtCtrls,
  AVGRIDIO, FileCtrl, Dutils;

const
  nrOfIDFs = 100;

type
  TMainForm = class(TForm)
    Button1: TButton;
    LargeRealArray1: TLargeRealArray;
    LabeledEditInputDir: TLabeledEdit;
    LabeledEditOutputDir: TLabeledEdit;
    LabeledEditIDFnamePrefix: TLabeledEdit;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure LabeledEditInputDirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LabeledEditOutputDirClick(Sender: TObject);
    procedure LabeledEditIDFnamePrefixChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  TidfArray = Array[1..nrOfIDFs] of TSingleESRIgrid;

var
  MainForm: TMainForm;
  idfArray: TidfArray;

implementation

{$R *.dfm}

procedure DeleteDir(const DirName: string);
var
  Path: string;
  F: TSearchRec;
begin
  Path:= DirName + '\*.*';
  if FindFirst(Path, faAnyFile, F) = 0 then begin
    try
      repeat
        if (F.Attr and faDirectory <> 0) then begin
          if (F.Name <> '.') and (F.Name <> '..') then begin
            DeleteDir(DirName + '\' + F.Name);
          end;
        end
        else
          DeleteFile(DirName + '\' + F.Name);
      until FindNext(F) <> 0;
    finally
      FindClose(F);
    end;
  end;
  RemoveDir(DirName);
end;

procedure TMainForm.Button1Click(Sender: TObject);
const
  SelectedPercentages: array[1..9] of integer = ( 1, 5, 10, 15, 50, 75, 90, 95, 100 );
var
  fName, fldrName, idfFilePrefix, s: String;
  iResult, iIdfNr, iRow, iCol, nrRows, NrCols: Integer;
  i, j, n: Integer;
  aValue: Double;
begin
  fldrName := LabeledEditInputDir.text;
  idfFilePrefix := LabeledEditIDFnamePrefix.Text;
  //Initialiseer array met idf's
  for iIdfNr := 1 to nrOfIDFs do begin
    fName := fldrName + '\' + idfFilePrefix + intToStr( iIdfNr ) + '.idf';
    WriteToLogFile( 'Initialise idf #, :' + intToStr( iIdfNr ) + ': ' + fName );
    idfArray[ iIdfNr ] := TSingleESRIgrid.InitialiseFromIDFfile( fName, iResult, self );
  end;

  //Sorteer waarden per cel
  nrRows := idfArray[ 1 ].NRows;
  nrCols := idfArray[ 1 ].NCols;
  LargeRealArray1 := TLargeRealArray.Create( nrOfIDFs, self );
  for i := 1 to nrRows do begin
    for j := 1 to nrCols do begin
      //Zet waarden in LargeRealArray1 en vermenigvuldig met 100
      for iIdfNr := 1 to nrOfIDFs do begin
        LargeRealArray1[ iIdfNr ] := idfArray[ iIdfNr ][i,j] * 100;
      end;
      //Sorteer deze array
      LargeRealArray1.Sort( Ascending );
      //Zet resultaat terug in idf's
      for iIdfNr := 1 to nrOfIDFs do begin
        idfArray[ iIdfNr ][i,j] := LargeRealArray1[ iIdfNr ];
      end;
    end;
  end;

  //Schrijf array met idf's weg als integer grids
  fldrName := LabeledEditOutputDir.text;
  s := fldrName + '\info';
  DeleteDir( s );
  //ShowMessage( fldrName );
  //n := length( SelectedPercentages );
  n := 100;

  for i := 1 to n do begin
    // iIdfNr := SelectedPercentages[ i ];
    iIdfNr := i;
    s := fldrName + '\'+ idfFilePrefix + intToStr( iIdfNr );
    // showmessage( s );
    DeleteDir( s );
    idfArray[ iIdfNr ].SaveAsInteger( s );
    idfArray[ iIdfNr ].ExportToASC(s+'.asc');
  end;

  ShowMessage( 'Gereed.' );

end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  aDir: String;
begin
  InitialiseLogFile;
  InitialiseGridIO;

  aDir := fini.ReadString('Files', 'idfDir','c:\');
  if DirectoryExists( aDir ) then
    LabeledEditInputDir.text := aDir
  else
    LabeledEditInputDir.text := 'c:\';
  aDir := fini.ReadString('Files', 'OutputDir','c:\');
  if DirectoryExists( aDir ) then
    LabeledEditOutputDir.text := aDir
  else
    LabeledEditOutputDir.text := 'c:\';
  LabeledEditIDFnamePrefix.Text := fini.ReadString( 'Settings', 'idfFilePrefix', 'dh1_' )
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
FinaliseLogFile;
end;

procedure TMainForm.LabeledEditIDFnamePrefixChange(Sender: TObject);
begin
  fini.WriteString( 'Settings', 'idfFilePrefix', LabeledEditIDFnamePrefix.Text );
end;

procedure TMainForm.LabeledEditInputDirClick(Sender: TObject);
var
  aDir: String;
begin
  aDir := LabeledEditInputDir.text;
  if SelectDirectory( aDir, [], 0) then begin
    LabeledEditInputDir.text := ExpandFileName( aDir );
    fini.WriteString('Files','idfDir',LabeledEditInputDir.text);
  end;
end;

procedure TMainForm.LabeledEditOutputDirClick(Sender: TObject);
var
  aDir: String;
begin
  aDir := LabeledEditOutputDir.text;
  if SelectDirectory( aDir, [], 0) then begin
    LabeledEditOutputDir.text := ExpandFileName( aDir );
    fini.WriteString('Files','OutputDir',LabeledEditOutputDir.text);
  end;
end;

end.
