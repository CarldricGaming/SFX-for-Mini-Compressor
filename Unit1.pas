unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Controls.Presentation, Windows, FMX.ScrollBox, FMX.Memo;

type
  TForm1 = class(TForm)
    StyleBook1: TStyleBook;
    Label1: TLabel;
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    OpenDialog1: TOpenDialog;
    GroupBox2: TGroupBox;
    Edit2: TEdit;
    Button3: TButton;
    GroupBox3: TGroupBox;
    Memo1: TMemo;
    GroupBox4: TGroupBox;
    Edit3: TEdit;
    ClearEditButton1: TClearEditButton;
    ClearEditButton2: TClearEditButton;
    ClearEditButton3: TClearEditButton;
    SearchEditButton1: TSearchEditButton;
    SearchEditButton2: TSearchEditButton;
    Memo2: TMemo;
    procedure Button3Click(Sender: TObject);
    procedure SearchEditButton1Click(Sender: TObject);
    procedure SearchEditButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

const
  LibraryAioFP = 'Aio_FP.dll';

procedure Website(URL: string); stdcall; external LibraryAioFP;
procedure Exec(sExe, sCommandLine: string; wait: Boolean); stdcall; external LibraryAioFP;
function SelDir: string; stdcall; external LibraryAioFP;
function IniRead(Filez, A, B, C: string): string; stdcall; external LibraryAioFP;
function IniCreate(Filez, A, B, C: string): string; stdcall; external LibraryAioFP;
procedure B_PlayMusic(Files: string); stdcall; external LibraryAioFP;
procedure B_PauseMusic; stdcall; external LibraryAioFP;
procedure B_ResumeMusic; stdcall; external LibraryAioFP;
procedure B_StopMusic; stdcall; external LibraryAioFP;

procedure TForm1.Button3Click(Sender: TObject);
var
  Source, Output, SFXFile: string;
  SFXCommand: string;
begin
  Source:= Edit1.Text;
  Output:= Edit2.Text;
  SFXFile:= Edit3.Text;
  if FileExists(Source) then
  begin
    Application.ProcessMessages;
    Sleep(150);

    Exec('SFXMaker.exe','',true);

    Application.ProcessMessages;
    Sleep(150);

    SFXCommand:= 'copy /b "MC.SFX" + "' + Source + '" "' + Output + '\' + SFXFile + '"';

    Memo2.Lines.Add('@echo off');
    Memo2.Lines.Add(SFXCommand);
    Memo2.Lines.SaveToFile('SFX.bat');

    Exec('SFX.bat','',true);

    Application.ProcessMessages;
    Sleep(150);

    Memo1.Lines.SaveToFile(Output + '\records.ini');

    Application.ProcessMessages;
    Sleep(2000);

    DeleteFile('MC.sfx');
    DeleteFile('SFX.bat');

    ShowMessage('SFX was finished.');
  end
  else
    ShowMessage('Failed to start. Try again.');
end;

procedure TForm1.SearchEditButton1Click(Sender: TObject);
var
  PickFolders: string;
begin
  PickFolders:= SelDir;
  if PickFolders <> '' then
    Edit2.Text:= PickFolders
  else
    ShowMessage('Failed to choose folder. Try again.');
end;

procedure TForm1.SearchEditButton2Click(Sender: TObject);
begin
  OpenDialog1.Title:= 'Select your source file';
  OpenDialog1.Filter:= '.arc|*.arc|All Files|*.*';
  if OpenDialog1.Execute then
    if FileExists(OpenDialog1.FileName) then
      Edit1.Text:= OpenDialog1.FileName
    else
      ShowMessage('Failed to pick files. Try again.');
end;

end.
