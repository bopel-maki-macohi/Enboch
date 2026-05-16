package ui;

import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;
import utilShitsie.EnboState;

class MainMenuState extends EnboState
{
	public var textGrp:FlxSpriteGroup;

	var entries:Array<String> = ['Levels', 'Options',];

	override function create()
	{
		super.create();

		add(textGrp = new FlxSpriteGroup());

		for (entry in entries)
		{
			var newText = new FlxText(0, 0, 0, entry, 16);
			newText.ID = textGrp.length;

			textGrp.add(newText);
		}
	}
}
