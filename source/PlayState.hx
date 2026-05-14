package;

import flixel.graphics.FlxGraphic;
import flixel.math.FlxRandom;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxState;

class PlayState extends FlxState
{
	var bg:FlxSprite;

	var robot:FlxSprite;
	var robo:String = 'blank';
	var robotAssetCache:Array<FlxGraphic> = [];

	var desk:FlxSprite;

	var robotState:Int = 0;
	var robotStateText:FlxText;

	var rngList:Array<Int> = [0, 0, 0];
	var encryptedRng:Array<String> = RNGCodeEncrypt.encrypt([0, 0, 0]);

	function makeRNGList()
	{
		rngList = [FlxG.random.int(0, 10), FlxG.random.int(0, 10), FlxG.random.int(0, 10)];
		encryptedRng = RNGCodeEncrypt.encrypt(rngList);
		trace('new rng: ${(#if debug rngList #else encryptedRng #end).join('')}');
	}

	var rngListText:FlxText;

	var robotStateChangeTimer:FlxTimer;

	var robotKillTimer:FlxTimer;

	override public function create()
	{
		super.create();

		robotAssetCache = [
			FlxG.bitmap.add('$robo/$robo-0'.getPath('robotImage')),
			FlxG.bitmap.add('$robo/$robo-1'.getPath('robotImage')),
			FlxG.bitmap.add('$robo/$robo-2'.getPath('robotImage')),
			FlxG.bitmap.add('$robo/$robo-3'.getPath('robotImage')),
		];

		for (asset in robotAssetCache)
		{
			if (asset == null)
				robotAssetCache.remove(asset);
		}

		bg = new FlxSprite(0, 0, 'bg'.getPath(image));
		robot = new FlxSprite(0, 0);
		desk = new FlxSprite(0, 0, 'desk'.getPath(image));

		bg.screenCenter();
		desk.screenCenter();

		add(bg);
		add(robot);
		add(desk);

		add(robotStateText = new FlxText(0, 0, 0, '', 16));
		add(rngListText = new FlxText(0, 16, 0, '', 16));

		robotStateChangeCheck(null);

		resetRSCT();

		robotKillTimer = new FlxTimer();
	}

	function resetRSCT()
	{
		if (robotStateChangeTimer != null)
			return;

		robotStateChangeTimer = new FlxTimer();
		robotStateChangeTimer.start(5, robotStateChangeCheck, 0);
	}

	function robotStateChangeCheck(t:FlxTimer)
	{
		if (t != null)
			switch (rngList[0])
			{
				case 0, 3, 6, 9:
					if (robotState == 0)
						robotState = (rngList[2] < 10) ? 1 : 2;
				case 1, 4, 7, 10:
					if (robotState == 1)
						robotState = (rngList[2] < 10) ? 2 : 1;
				case 2, 5, 8:
					if (robotState == 2)
					{
						robotState = 3; // ur dead lmao
						robotKillTimer.start(rngList[1], jumpscare);
					}
			}

		makeRNGList();

		if (robotAssetCache[robotState] != null)
		{
			robot.loadGraphic(robotAssetCache[robotState]);
			robot.screenCenter();
		}
	}

	function jumpscare(t:FlxTimer)
	{
		robotStateChangeTimer.cancel();
		robotStateChangeTimer.destroy();
		robotStateChangeTimer = null;

		trace('u dead');
		FlxG.switchState(() -> new DeadState());
		// FlxG.resetState();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		robotStateText.text = '$robotState';

		rngListText.text = '${encryptedRng.join('')}';
	}
}
