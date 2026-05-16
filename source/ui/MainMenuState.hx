package ui;

import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;
import utilShitsie.EnboState;

class MainMenuState extends EnboState
{
	public var textGrp:FlxTypedSpriteGroup<FlxText>;

	var entries:Array<String> = ['Levels', 'Options',];

	override function create()
	{
		super.create();

		add(textGrp = new FlxTypedSpriteGroup<FlxText>());

		for (entry in entries)
		{
			var newText = new FlxText(0, 0, 0, entry, 16);
			newText.ID = textGrp.length;

			textGrp.add(newText);
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		for (text in textGrp.members)
		{
			text.screenCenter(X);
			text.y = (2 + text.ID) * 64;
		}
	}
}
