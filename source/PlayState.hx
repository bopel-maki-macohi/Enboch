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

		robotStateText = new FlxText();
		add(robotStateText);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		robotStateText.text = '$robotState';

		robotState = FlxG.random.int(0, 5);
	}
}
