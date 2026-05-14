package;

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

	var robotStateChangeTimer:Int = 0;
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
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		robotStateText.text = '$robotState';
		robotStateChangeTimerText.text = '$robotStateChangeTimer';

		robotStateChangeTimer -= 1;

		if (robotStateChangeTimer < 0)
			robotStateChangeTimer = 30 * 100;
	}
}
