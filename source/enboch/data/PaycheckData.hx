package enboch.data;

typedef PaycheckData =
{
	totalPay:Int,
	keybinds:Map<String, Array<String>>,

	firstTime:Bool,

	trophies:Array<Int>,

	gj_username:String,
	gj_usertoken:String,

	settings:PaycheckSettingsData,
}

typedef PaycheckSettingsData =
{
	?screenshotFlash:Null<Bool>,
	?menuBGVideo:Null<Bool>,
	?characterPulse:Null<Bool>,
}
