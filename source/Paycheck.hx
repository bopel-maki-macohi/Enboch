import flixel.FlxG;

typedef PaycheckData =
{
	totalPay:Int,
}

class Paycheck
{
	public static var totalPay:Int = 0;

	public static var game:PaycheckData = {
		totalPay: 0
	};

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
		});

        trace(game);
	}

	public static function save()
	{
		game = {
			totalPay: totalPay,
		};

		FlxG.save.data.game = game;
	}

	public static function getPayed(percentage:Float = 1)
	{
		totalPay += Math.round(100 * percentage);
	}
}
