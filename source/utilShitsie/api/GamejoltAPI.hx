package utilShitsie.api;

import flixel.FlxG;
import macroShit.SecretDataFile;
import flixel.addons.api.FlxGameJolt as API;

class GamejoltAPI
{
	static var privateKey:String = SecretDataFile.build('dev/api/gamejolt-privateKey');

	public static function init()
	{
		API.verbose = #if debug true #else false #end;
		API.init(1070390, privateKey);

		FlxG.stage.application.onExit.add(l -> close());
	}

	public static function logout()
	{
		close();
	}

	public static function close()
	{
		API.closeSession();
	}

	public static var authenticated(get, never):Bool;

	static function get_authenticated():Bool
	{
		@:privateAccess
		return API.authenticated;
	}
}
