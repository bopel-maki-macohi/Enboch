import utilShitsie.DebugString;
import flixel.util.FlxStringUtil;
import utilShitsie.api.GamejoltAPI;
import utilShitsie.controls.Controls;
import flixel.FlxG;

using StringTools;

typedef PaycheckData =
{
	totalPay:Int,
	keybinds:Map<String, Array<String>>,

	trophies:Array<Int>,
	firstTime:Bool,

	gd_username:String,
	gd_usertoken:String,
}

class Paycheck
{
	public static var totalPay:Int = 0;
	public static var earned:Int = 0;

	public static var game:PaycheckData = {
		totalPay: 0,
		keybinds: ['accept' => ['ENTER'], 'screenshot' => ['F3'],],
		trophies: [],
		firstTime: true,
		gd_username: null,
		gd_usertoken: null,
	};

	public static function stringGameData()
	{
		return DebugString.generateBasedOnData(game, [
			#if debug
			'gd_username', //
			'gd_usertoken',
			#end
		]);
	}

	public static function load()
	{
		FlxG.save.bind('EndlessRobotWatcher', 'Maki');

		if (FlxG.save.data.game == null)
			FlxG.save.data.game = game;
		else
			game = FlxG.save.data.game;

		totalPay = game.totalPay;

		FlxG.stage.application.onExit.add(i ->
		{
			save();
		}, false, 1000);

		trace(stringGameData());
	}

	public static function save()
	{
		var keybinds:Map<String, Array<String>> = [];

		for (key in Controls.keys)
			keybinds.set(key.id, key.keyList);

		game = {
			totalPay: totalPay,
			keybinds: keybinds,

			trophies: [], // tba
			firstTime: false,

			gd_username: GamejoltAPI.username,
			gd_usertoken: GamejoltAPI.usertoken,
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
