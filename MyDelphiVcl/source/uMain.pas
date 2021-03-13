unit uMain;

interface

uses
  PythonEngine,Winapi.Windows,System.SysUtils,inifiles;

function PyInit_MyDelphiVCL: PPyObject; cdecl;

implementation

uses
  WrapDelphi, MyWrapDelphiVCL;

var
  gEngine : TPythonEngine;
  gModule : TPythonModule;
  gDelphiWrapper : TPyDelphiWrapper;
  //�ҲթҦb��m
  APath:string;

// This must match the pattern "PyInit_[ProjectName]"
// So if the project is named DelphiVCL then
//   the function must be PyInit_DelphiVCL
function PyInit_MyDelphiVCL: PPyObject;
var
  DllPath,DllName,RegVersion,PythonHome:string;
  UseLastDLL:boolean;
  //�]�wpython�ҲհѼ�
  procedure DoLoadDLL;
  begin

    if not UseLastDLL then begin
      gEngine.DllPath:= DllPath;
      gEngine.PythonHome:= DllPath;
      gEngine.DllName:=DllName;
      gEngine.RegVersion := RegVersion;
    end;
    gEngine.UseLastKnownVersion:=UseLastDLL;
  end;
  //���oDLL �Ҧb���|
  procedure getPath;
  var
    Buffer:array [0..255] of char;
    tmpstr:String;
  begin
      GetModuleFileName(HInstance, Buffer, SizeOf(Buffer));
      tmpstr:=ExtractFilePath(Buffer);
      APath:=tmpstr;
  end;
  //���J�]�w�Ѽ�
  procedure loadconfig;
  var
    fn:string;
    ini:TInifile;
  begin
    getPath;
    fn:= Apath+'config.ini';
    ini := TInifile.Create(fn);
    try
      DllPath:=ini.ReadString('Data','PythonDLL','');
      DllName:=ini.ReadString('Data','PythonDLLName','python39.dll');
      RegVersion:= ini.ReadString('Data','PythonRegVersion','3.6');
      RegVersion:= ini.ReadString('Data','PythonRegVersion','3.6');
      UseLastDLL:= ini.ReadBool('Data','UseLastKnownVersion',True);
    finally
      ini.Free
    end;
  end;
begin
  try
    gEngine := TPythonEngine.Create(nil);
    gEngine.AutoFinalize := false;
    loadconfig;
    DoLoadDLL();
    gModule := TPythonModule.Create(nil);
    gModule.Engine := gEngine;
    // This must match the ProjectName and the function name pattern
    gModule.ModuleName := 'MyDelphiVCL';

    gDelphiWrapper := TPyDelphiWrapper.Create(nil);
    gDelphiWrapper.Engine := gEngine;
    gDelphiWrapper.Module := gModule;

    gEngine.LoadDll;
  except
  end;
  Result := gModule.Module;
end;

initialization
  gEngine := nil;
  gModule := nil;
  gDelphiWrapper := nil;
finalization
  if assigned(gModule) then
    gModule.Free;
  if assigned(gEngine) then
    gEngine.Free;
  if assigned(gDelphiWrapper) then
    gDelphiWrapper.Free;
end.


