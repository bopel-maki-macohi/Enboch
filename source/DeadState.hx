package;

import utilShitsie.EnboState;
import flixel.FlxG;
import flixel.text.FlxText;

class DeadState extends EnboState
{
	override function create()
	{
		super.create();

		var text = new FlxText(0, 0, 0, 'haha u dead lmao', 16);
		add(text);
		text.screenCenter();
	}

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (FlxG.keys.justReleased.ENTER)
            FlxG.switchState(() -> new PlayState());
    }
}
