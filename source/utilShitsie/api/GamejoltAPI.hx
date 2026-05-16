package utilShitsie.api;

import macroShit.SecretDataFile;
import flixel.addons.api.FlxGameJolt;

class GamejoltAPI
{
	static var privateKey:String = SecretDataFile.build('api/gamejolt-privateKey'.makePath(secret));

	public static function init()
	{
		FlxGameJolt.init(1070390, '', true);
	}
}
