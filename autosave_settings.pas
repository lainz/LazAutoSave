unit autosave_settings;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics,
  // LazUtils
  Laz2_XMLCfg, LazFileUtils,
  // IdeIntf
  LazIDEIntf,
  // AutoSave
  autosave_const;

type
  { TSettings }

  TSettings = class
  private
    FXML: TXMLConfig;
    FVersion: Integer;
    FChanged: Boolean;
    FEnableAutoSave: Boolean;
    FAutoSaveInterval: Integer;
  public
    constructor Create(const AFileName: String);
    destructor Destroy; override;
    procedure Load;
    procedure Save;
    procedure LoadDefault;
  published
    property Changed: Boolean read FChanged write FChanged;
    property EnableAutoSave: Boolean read FEnableAutoSave write FEnableAutoSave;
    property AutoSaveInteval: Integer read FAutoSaveInterval write FAutoSaveInterval;
  end;

var
  Settings: TSettings = nil;

implementation

const
  AutoSaveVersion = 1;
  DefAutoSaveInterval = 5;

{ TSettings }

constructor TSettings.Create(const AFileName: String);
begin
  FXML := TXMLConfig.Create(AFileName);
  if FileExists(AFileName) then
    Load
  else
    LoadDefault;
end;

destructor TSettings.Destroy;
begin
  if FChanged then
    Save;
  FXML.Free;
  inherited Destroy;
end;

procedure TSettings.Load;
begin
  FVersion := FXML.GetValue('Version/Value', 0); //future use
  FEnableAutoSave := FXML.GetValue('AutoSave/EnableAutoSave/Value', True);
  FAutoSaveInterval := FXML.GetValue('AutoSave/AutoSaveInterval/Value', DefAutoSaveInterval);
end;

procedure TSettings.Save;
begin
  FXML.SetDeleteValue('Version/Value', AutoSaveVersion, 0);
  FXML.SetDeleteValue('AutoSave/EnableAutoSave/Value', FEnableAutoSave, True);
  FXML.SetDeleteValue('AutoSave/AutoSaveInterval/Value', FAutoSaveInterval, DefAutoSaveInterval);
  FXML.Flush;
  FChanged := False;
end;

procedure TSettings.LoadDefault;
begin
  FEnableAutoSave := True;
  FAutoSaveInterval := DefAutoSaveInterval;
  Save;
end;

end.


