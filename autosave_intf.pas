unit autosave_intf;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  Controls,
  //LCL
  LCLType,
  //IDEIntf
  MenuIntf, ToolbarIntf, IDECommands;

procedure Register;

implementation

uses autosave_const, autosave_settings, autosave_settingsfrm, autosave_main;

procedure IDEMenuSectionClicked(Sender: TObject);
begin
  SettingsFrm := TSettingsFrm.Create(nil);
  try
    if SettingsFrm.ShowModal = mrOk then
    begin
      if AutoSave.Timer.Interval <> Settings.AutoSaveInteval then
      begin
        AutoSave.Timer.StopTimer;
        AutoSave.Timer.Interval := Settings.AutoSaveInteval*1000;
        AutoSave.Timer.StartTimer;
      end;
    end;
  finally
    SettingsFrm.Free;
    SettingsFrm := nil;
  end;
end;

procedure Register;
var
  IDEShortCutX: TIDEShortCut;
  IDECommandCategory: TIDECommandCategory;
  IDECommand: TIDECommand;
begin
  IDEShortCutX := IDEShortCut(VK_A, [ssShift, ssCtrl], VK_UNKNOWN, []);
  IDECommandCategory := IDECommandList.FindCategoryByName('FileMenu');
  if IDECommandCategory <> nil then
  begin
    IDECommand := RegisterIDECommand(IDECommandCategory, 'AutoSave', rsAutoSave, IDEShortCutX, nil, @IDEMenuSectionClicked);
    if IDECommand <> nil then
      RegisterIDEButtonCommand(IDECommand);
  end;
  RegisterIDEMenuCommand(itmFileOpenSave, 'AutoSave', rsAutoSave, nil, @IDEMenuSectionClicked, IDECommand);
end;

initialization
  AutoSave := TAutoSave.Create;

finalization
  FreeAndNil(AutoSave);

end.

