library MyDelphiVCL;

uses
  SysUtils,
  Classes,
  uMain in 'source\uMain.pas',
  MyWrapToPyrthon in 'source\MyWrapToPyrthon.pas';

{$I Definition.Inc}

exports
  //�I�s��Ʀ��T�w�榡�ݭnPyInit_+�ҲզW��
  PyInit_MyDelphiVCL;
{$IFDEF MSWINDOWS}
//�sĶ�᪺���ɦW��
//pyd�O��L�y���g��python��Ʈw
{$E pyd}
{$ENDIF}
{$IFDEF LINUX}
{$SONAME 'MyDelphiVCL'}

{$ENDIF}

begin
end.

