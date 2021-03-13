unit MyWrapToPyrthon;

interface
//-------------------------------------------------------------------------
uses
  Classes,
  SysUtils,
  System.UITypes,
  PythonEngine,
  Types,
  WrapDelphi,
  Vcl.Dialogs;
//-------------------------------------------------------------------------
type
  TMyWrapToPyrthon = class(TRegisteredUnit)
  public
    function Name : string; override;
    procedure RegisterWrappers(APyDelphiWrapper : TPyDelphiWrapper); override;
    procedure DefineVars(APyDelphiWrapper : TPyDelphiWrapper); override;
    procedure DefineFunctions(APyDelphiWrapper : TPyDelphiWrapper); override;
  end;
//-------------------------------------------------------------------------
  function MessageDlg_Wrapper( self, args  : PPyObject) : PPyObject; cdecl;
implementation
{ TMyWrapToPyrthon }
//-------------------------------------------------------------------------
//param01 訊息內容
//param02 訊息類型
//param03 按鈕群
//iRetn 按下的按鈕 ,
function MessageDlg_Wrapper( self, args  : PPyObject) : PPyObject; cdecl;
var
  s,iMsg:string;
  strs:TStrings;
  i:integer;
  DlgType:TMsgDlgType;
  iRetn:integer;
  function tranBtns(iStr:String):TMsgDlgButtons;
  var
    _strs:TStringList;
    _i:integer;
    _DlgBtns:TMsgDlgButtons;
  begin
    _strs:=TStringList.Create;
    iStr:=StringReplace(iStr,'(','',[rfReplaceAll]);
    iStr:=StringReplace(iStr,')','',[rfReplaceAll]);
    _strs.Delimiter:=',';
    _strs.DelimitedText:= iStr;
    _DlgBtns:=[];
    for _i := 0 to _strs.Count -1 do
      Include(_DlgBtns,TMsgDlgBtn(StrToInt(_strs[_i])));
    tranBtns:= _DlgBtns;
    _strs.Free;
  end;
begin

  with GetPythonEngine do
    begin
      s:= PyObjectAsString(args);
      strs:=TStringList.Create;
      strs.Clear;
      try
        PyTupleToStrings(args,strs);
        try
          if strs.Count >=3 then begin
            iMsg:=strs[0];
            DlgType:=TMsgDlgType(StrToInt(strs[1]));
            s:= strs[2];
            iRetn:=MessageDlg(strs[0],DlgType,tranBtns(s),0 );
          end;
        except  on e:Exception do
//          raise(e.Message);
        end;

      finally
        strs.Free;
      end;
      Result:= VariantAsPyObject(iRetn);
    end;
end;

//-------------------------------------------------------------------------
procedure TMyWrapToPyrthon.DefineFunctions(APyDelphiWrapper: TPyDelphiWrapper);
begin
  inherited;
  APyDelphiWrapper.RegisterFunction(PAnsiChar('MessageDlg'), MessageDlg_Wrapper,
       PAnsiChar('MessageDlg()'#10 +'call MessageDlg in Vcl.Dialogs'));
end;

procedure TMyWrapToPyrthon.DefineVars(APyDelphiWrapper: TPyDelphiWrapper);
begin
  inherited;
  { Message dialog }
  {TMsgDlgType}
  APyDelphiWrapper.DefineVar('mtWarning',  mtWarning);
  APyDelphiWrapper.DefineVar('mtError',  mtError);
  APyDelphiWrapper.DefineVar('mtInformation',  mtInformation);
  APyDelphiWrapper.DefineVar('mtConfirmation',mtConfirmation);
  APyDelphiWrapper.DefineVar('mtCustom',mtCustom);
  {dialog Buttons}
  APyDelphiWrapper.DefineVar('mbYes',mbYes);
  APyDelphiWrapper.DefineVar('mbNo',mbNo);
  APyDelphiWrapper.DefineVar('mbOK',mbOK);
  APyDelphiWrapper.DefineVar('mbCancel',mbCancel);
  APyDelphiWrapper.DefineVar('mbAbort',mbAbort);
  APyDelphiWrapper.DefineVar('mbRetry',mbRetry);
  APyDelphiWrapper.DefineVar('mbIgnore',mbIgnore);
  APyDelphiWrapper.DefineVar('mbAll',mbAll);
  APyDelphiWrapper.DefineVar('mbNoToAll',mbNoToAll);
  APyDelphiWrapper.DefineVar('mbYesToAll',mbYesToAll);
  APyDelphiWrapper.DefineVar('mbHelp',mbHelp);
  APyDelphiWrapper.DefineVar('mbClose',mbClose);

  {Retun value}
  APyDelphiWrapper.DefineVar('mrNone',  mrNone);
  APyDelphiWrapper.DefineVar('mrOk',  mrOk);
  APyDelphiWrapper.DefineVar('mrCancel',  mrCancel);
  APyDelphiWrapper.DefineVar('mrAbort',  mrAbort);
  APyDelphiWrapper.DefineVar('mrRetry',  mrRetry);
  APyDelphiWrapper.DefineVar('mrIgnore',  mrIgnore);
  APyDelphiWrapper.DefineVar('mrNo',  mrNo);
  APyDelphiWrapper.DefineVar('mrClose',  mrClose);
  APyDelphiWrapper.DefineVar('mrHelp',  mrHelp);
  APyDelphiWrapper.DefineVar('mrTryAgain',  mrTryAgain);
  APyDelphiWrapper.DefineVar('mrContinue',  mrContinue);
  APyDelphiWrapper.DefineVar('mrAll',  mrAll);
  APyDelphiWrapper.DefineVar('mrNoToAll',  mrNoToAll);
  APyDelphiWrapper.DefineVar('mrYesToAll',  mrYesToAll);
end;

function TMyWrapToPyrthon.Name: string;
begin
  Result := 'MyWrapToPyrthon';
end;

procedure TMyWrapToPyrthon.RegisterWrappers(APyDelphiWrapper: TPyDelphiWrapper);
begin
  inherited;

end;

initialization
  RegisteredUnits.Add( TMyWrapToPyrthon.Create );
finalization

end.
