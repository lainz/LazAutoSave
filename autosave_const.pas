unit autosave_const;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

const
  cAutoSaveConfigFile = 'autosave_settings.xml';

resourcestring
  rsAutoSave = 'AutoSave options';
  rsSettings_Caption = 'AutoSave options';
  rsSettings_cbEnableAutoSave_Caption = 'Enable AutoSave';
  rsSettings_lbInterval_Caption = 'Interval';
  rsSettings_lbSec_Caption = '(seconds)';
  rsSettings_OKButton_Caption = 'OK';
  rsSettings_CancelButton_Caption = 'Cancel';


implementation

end.

