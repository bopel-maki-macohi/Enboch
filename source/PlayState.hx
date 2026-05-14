package;

import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxState;

class PlayState extends FlxState
{
	var bg:FlxSprite;
	var robot:FlxSprite;
	var desk:FlxSprite;

	var robotState:Int = 0;
	var robotStateText:FlxText;

	var robotStateChangeTimer:FlxTimer;
	var robotStateChangeTimerText:FlxText;

	override public function create()
	{
		super.create();

		bg = new FlxSprite(0, 0, 'assets/images/bg.png');
		robot = new FlxSprite(0, 0, 'assets/images/robot.png');
		desk = new FlxSprite(0, 0, 'assets/images/desk.png');

		bg.screenCenter();
		robot.screenCenter();
		desk.screenCenter();

		add(bg);
		add(robot);
		add(desk);

		add(robotStateText = new FlxText(0, 0, 0, '', 16));
		add(robotStateChangeTimerText = new FlxText(0, 16, 0, '', 16));

		robotStateChangeTimer = new FlxTimer().start(10, null, 3);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		robotStateText.text = '$robotState';
		robotStateChangeTimerText.text = '${robotStateChangeTimer.timeLeft}';

	}
}
