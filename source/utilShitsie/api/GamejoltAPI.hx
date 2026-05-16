package utilShitsie.api;

import macroShit.SecretDataFile;
import flixel.addons.api.FlxGameJolt;

class GamejoltAPI
{
	static var privateKey:String = SecretDataFile.build('dev/api/gamejolt-privateKey');

	public static function init()
	{
		FlxGameJolt.init(1070390, privateKey);
	}
}
