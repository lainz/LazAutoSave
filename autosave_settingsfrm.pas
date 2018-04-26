unit autosave_settingsfrm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Spin, StdCtrls,
  ButtonPanel;

type

  { TSettingsFrm }

  TSettingsFrm = class(TForm)
    bpSettings: TButtonPanel;
    cbEnableAutoSave: TCheckBox;
    lbInterval: TLabel;
    lbSec: TLabel;
    spAutoSaveInterval: TSpinEdit;
    procedure cbEnableAutoSaveChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
  private
    procedure LoadSettings;
    procedure SaveSettings;
  public

  end;

var
  SettingsFrm: TSettingsFrm;

implementation
uses autosave_const, autosave_settings;
{$R *.lfm}

{ TSettingsFrm }

procedure TSettingsFrm.FormCreate(Sender: TObject);
begin
  cbEnableAutoSave.Caption := rsSettings_cbEnableAutoSave_Caption;
  lbInterval.Caption := rsSettings_lbInterval_Caption;
  lbSec.Caption := rsSettings_lbSec_Caption;
  bpSettings.OKButton.Caption := rsSettings_OKButton_Caption;
  bpSettings.CancelButton.Caption := rsSettings_CancelButton_Caption;
  LoadSettings;
end;

procedure TSettingsFrm.cbEnableAutoSaveChange(Sender: TObject);
begin
  spAutoSaveInterval.Enabled := cbEnableAutoSave.Checked;
end;

procedure TSettingsFrm.LoadSettings;
begin
  cbEnableAutoSave.Checked := Settings.EnableAutoSave;
  spAutoSaveInterval.Value := Settings.AutoSaveInteval;
  spAutoSaveInterval.Enabled := cbEnableAutoSave.Checked;
end;

procedure TSettingsFrm.SaveSettings;
begin
  Settings.EnableAutoSave := cbEnableAutoSave.Checked;
  Settings.AutoSaveInteval := spAutoSaveInterval.Value;
  Settings.Save;
end;

procedure TSettingsFrm.OKButtonClick(Sender: TObject);
begin
  SaveSettings;
end;

end.

