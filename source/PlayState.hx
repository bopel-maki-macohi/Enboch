package;

import flixel.FlxSprite;
import flixel.FlxState;

class PlayState extends FlxState
{
	var bg:FlxSprite;
	var robot:FlxSprite;
	var desk:FlxSprite;

	override public function create()
	{
		super.create();

		bg = new FlxSprite(0, 0, 'assets/images/bg.png');
		robot = new FlxSprite(0, 0, 'assets/images/robot.png');
		desk = new FlxSprite(0, 0, 'assets/images/desk.png');

		add(bg);
		add(robot);
		add(desk);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
