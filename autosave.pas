{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit autosave;

{$warn 5023 off : no warning about unused units}
interface

uses
  autosave_intf, autosave_const, autosave_settingsfrm, autosave_main, 
  autosave_settings, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('autosave_intf', @autosave_intf.Register);
end;

initialization
  RegisterPackage('autosave', @Register);
end.
