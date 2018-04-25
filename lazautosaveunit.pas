unit lazautosaveunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IDECommands, ExtCtrls, ProjectIntf, Forms, Controls, LazIDEIntF;

const
  AUTOSAVEINTERVAL = 1000; // ms

type

  { TLazAutoSave }

  TLazAutoSave = class(TObject)
  private
    Timer: TTimer;
    FHandlerAdded: boolean;
    FCurProject: TLazProject;
    procedure OnTimer(Sender: TObject);
    function OnProjectOpened(Sender: TObject; AProject: TLazProject): TModalResult;
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
  if not FHandlerAdded then
  begin
    if Assigned(LazarusIDE) then
    begin
      LazarusIDE.AddHandlerOnProjectOpened(@OnProjectOpened);
      FHandlerAdded := True;
    end;
  end;
  if Assigned(FCurProject) and not FCurProject.IsVirtual then  //isvirtual = not saved yet
    IDECommands.ExecuteIDECommand(Self, ecSaveAll);
end;

function TLazAutoSave.OnProjectOpened(Sender: TObject; AProject: TLazProject
  ): TModalResult;
begin
  Result := mrOk;
  FCurProject := AProject;
end;

constructor TLazAutoSave.Create;
begin
  FHandlerAdded := False;
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

