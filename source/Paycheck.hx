import enboch.utilShitsie.DebugString;
import enboch.utilShitsie.Define;
import enboch.utilShitsie.api.GamejoltAPI;
import enboch.utilShitsie.controls.Controls;
import flixel.FlxG;

using StringTools;

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
}

class Paycheck
{
	public static var totalPay:Int = 0;
	public static var earned:Int = 0;

	public static var game:PaycheckData = {
		totalPay: 0,
		keybinds: ['accept' => ['ENTER'], 'screenshot' => ['F3'],],
		firstTime: true,
		trophies: [],
		gj_username: null,
		gj_usertoken: null,
		settings: {
			screenshotFlash: true,
		}
	};

	public static function stringGameData()
	{
		var nonoes:Array<String> = [];

		if (!Define.debug)
		{
			nonoes.push('gj_username');
			nonoes.push('gj_usertoken');
		}

		return '\n' + DebugString.generateBasedOnData(game, nonoes);
	}

	public static function load()
	{
		FlxG.save.bind('EndlessRobotWatcher', 'Maki');

		if (FlxG.save.data.game == null)
			FlxG.save.data.game = game;
		else
			game = FlxG.save.data.game;

		trace(stringGameData());

		game.settings ??= {};
		game.settings.screenshotFlash ??= true;

		totalPay = game.totalPay;

		FlxG.stage.application.onExit.add(i ->
		{
			save();
		}, false, 1000);
	}

	public static function save()
	{
		var keybinds:Map<String, Array<String>> = [];

		for (key in Controls.keys)
			keybinds.set(key.id, key.keyList);

		game = {
			totalPay: totalPay,
			keybinds: keybinds,

			trophies: game.trophies,
			firstTime: false,

			gj_username: GamejoltAPI.username,
			gj_usertoken: GamejoltAPI.usertoken,

			settings: game.settings,
		};

		FlxG.save.data.game = game;
		trace(stringGameData());
	}

	public static function getPayed(percentage:Float = 1)
	{
		var paycheck = Math.round(100 * percentage);

		earned += paycheck;
		totalPay += paycheck;
	}
}
