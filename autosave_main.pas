unit autosave_main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, ExtCtrls,
  // LazUtils
  LazFileUtils,
  //IDEIntf
  IDECommands, ProjectIntf, LazIDEIntf;

type

  { TThreadTimer }

  TThreadTimer = class(TThread)
   private
     FTime: QWORD;
     FInterval: Integer;
     FOnTimer: TNotifyEvent;
     FEnabled: Boolean;
     procedure DoOnTimer;
   protected
     procedure Execute; override;
   public
     constructor Create;
     destructor Destroy; override;
   public
     property OnTimer: TNotifyEvent read FOnTimer write FOnTimer;
     property Interval: Integer read FInterval write FInterval;
     property Enabled: Boolean read FEnabled write FEnabled;
     procedure StopTimer;
     procedure StartTimer;
   end;

  { TAutoSave }

  TAutoSave = class(TObject)
  private
    FTimer: TThreadTimer;
    procedure OnTimer(Sender: TObject);
  public
    constructor Create;
    destructor Destroy; override;
  public
    property Timer: TThreadTimer read FTimer;
  end;

var
  AutoSave: TAutoSave = nil;


implementation
uses autosave_settings, autosave_const;

{ TThreadTimer }

constructor TThreadTimer.Create;
begin
  inherited Create(True);
  FreeOnTerminate := True;
  FEnabled := False;
end;

destructor TThreadTimer.Destroy;
begin
  //
  inherited Destroy;
end;

procedure TThreadTimer.DoOnTimer;
begin
  if Assigned(FOnTimer) then
    FOnTimer(Self);
end;

procedure TThreadTimer.Execute;
begin
  while not Terminated do
  begin
    Sleep(10);
    if (GetTickCount64 - FTime > FInterval) and (FEnabled) and (not Application.Terminated) then
    begin
      FTime := GetTickCount64;
      Synchronize(@DoOnTimer);
    end;
  end;
end;

procedure TThreadTimer.StopTimer;
begin
  FEnabled := False;
end;

procedure TThreadTimer.StartTimer;
begin
  FTime := GetTickCount64;
  FEnabled := True;
  if Self.Suspended then
    Start;
end;

{ TAutoSave }

procedure TAutoSave.OnTimer(Sender: TObject);
begin
  if Settings = nil then
  begin
    if LazarusIDE <> nil then //wait until IDE startup
    begin
      Settings := TSettings.Create(AppendPathDelim(LazarusIDE.GetPrimaryConfigPath) + cAutoSaveConfigFile);
      FTimer.StopTimer;
      FTimer.Interval := Settings.AutoSaveInteval*1000;
      FTimer.StartTimer;
    end;
  end
  else
  begin
    if Settings.EnableAutoSave then
      LazarusIDE.DoSaveAll([sfDoNotSaveVirtualFiles, sfCanAbort, sfQuietUnitCheck]);
  end;
end;

constructor TAutoSave.Create;
begin
  FTimer := TThreadTimer.Create;
  FTimer.FreeOnTerminate := True;
  FTimer.Interval := 100;
  FTimer.OnTimer := @OnTimer;
  FTimer.StartTimer;
end;

destructor TAutoSave.Destroy;
begin
  FTimer.StopTimer;
  FTimer.Terminate;
  if Settings <> nil then
    Settings.Free;
  inherited;
end;

end.

