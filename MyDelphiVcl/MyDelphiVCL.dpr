library MyDelphiVCL;

uses
  SysUtils,
  Classes,
  uMain in 'source\uMain.pas',
  MyWrapToPyrthon in 'source\MyWrapToPyrthon.pas';

{$I Definition.Inc}

exports
  //呼叫函數有固定格式需要PyInit_+模組名稱
  PyInit_MyDelphiVCL;
{$IFDEF MSWINDOWS}
//編譯後的附檔名為
//pyd是其他語言寫的python函數庫
{$E pyd}
{$ENDIF}
{$IFDEF LINUX}
{$SONAME 'MyDelphiVCL'}

{$ENDIF}

begin
end.

