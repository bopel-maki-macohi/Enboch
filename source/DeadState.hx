package;

import flixel.text.FlxText;
import flixel.FlxState;

class DeadState extends FlxState
{
	override function create()
	{
		super.create();

		var text = new FlxText(0, 0, 0, 'haha u dead lmao', 16);
		add(text);
		text.screenCenter();
	}
}
