unit lazautosaveunit;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, ExtCtrls, LazIDEIntF;

const
  AUTOSAVEINTERVAL = 1000; // ms

type

  { TLazAutoSave }

  TLazAutoSave = class(TObject)
  private
    Timer: TTimer;
    procedure OnTimer(Sender: TObject);
  public
    constructor Create;
    destructor Destroy;
  end;

implementation

var
  AutoSave: TLazAutoSave;

{ TLazAutoSave }

procedure TLazAutoSave.OnTimer(Sender: TObject);
begin
  if Assigned(LazarusIDE) then
    LazarusIDE.DoSaveAll([sfDoNotSaveVirtualFiles, sfCanAbort, sfQuietUnitCheck]);
end;

constructor TLazAutoSave.Create;
begin
  Timer := TTimer.Create(nil);
  Timer.Interval := AUTOSAVEINTERVAL;
  Timer.OnTimer := @OnTimer;
end;

destructor TLazAutoSave.Destroy;
begin
  Timer.Enabled := False;
  Timer.Free;
end;

initialization
  AutoSave := TLazAutoSave.Create;

finalization
  FreeAndNil(AutoSave);

end.

