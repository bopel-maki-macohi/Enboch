package enboch;

import enboch.data.PaycheckData;
import enboch.util.DebugString;
import enboch.util.api.GamejoltAPI;
import enboch.util.controls.Controls;
import flixel.FlxG;

using StringTools;

class Paycheck
{
	public static var totalPay:Int = 0;
	public static var earned:Int = 0;

	public static var game:PaycheckData = null;

	public static final defaultGameData:PaycheckData = {
		totalPay: 0,
		keybinds: [],
		firstTime: true,
		trophies: [],
		gj_username: null,
		gj_usertoken: null,
		settings: {}
	};

	public static function stringGameData()
	{
		var nonoes:Array<String> = [];

		if (!debug)
		{
			nonoes.push('gj_username');
			nonoes.push('gj_usertoken');
		}

		return '\n' + DebugString.generateBasedOnData(game, nonoes);
	}

	public static function load()
	{
		FlxG.save.bind('EndlessRobotWatcher', 'Maki');

		if (game == null)
			game = defaultGameData;

		if (FlxG.save.data.game == null)
			FlxG.save.data.game = game;
		else
			game = FlxG.save.data.game;

		trace(stringGameData());

		game.keybinds ??= [];

		for (control in Controls.keys)
			control.loadFromSave();

		game.settings ??= {};
		game.settings.screenshotFlash ??= true;
		game.settings.menuBGVideo ??= true;
		game.settings.characterPulse ??= true;

		totalPay = game.totalPay;

		FlxG.stage.application.onExit.remove(save);
		FlxG.stage.application.onExit.add(save, false, 1000);
	}

	public static function clear()
	{
		save();
		FlxG.save.erase();

		var trophies:Array<Int> = game.trophies;

		game = null;
		load();

		game.trophies = trophies;

		FlxG.resetGame();
	}

	public static function save(?i:Int)
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
		FlxG.save.flush();

		trace(stringGameData());
	}

	public static function getPayed(basePay:Int, percentage:Float = 1)
	{
		var paycheck = Math.round(basePay * percentage);

		earned += paycheck;
		totalPay += paycheck;
	}
}
