package ui;

import utilShitsie.controls.Controls;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;
import utilShitsie.EnboState;

class MainMenuState extends EnboState
{
	public var textGrp:FlxTypedSpriteGroup<FlxText>;

	var entries:Array<String> = ['Levels', 'Options',];

	var camFollow:FlxObject;

	var curSelect:Int = 0;

	override function create()
	{
		super.create();

		add(textGrp = new FlxTypedSpriteGroup<FlxText>());

		for (entry in entries)
		{
			var newText = new FlxText(0, 0, 0, entry, 64);
			newText.ID = textGrp.length;

			textGrp.add(newText);
		}

		add(camFollow = new FlxObject(640));
		FlxG.camera.follow(camFollow, LOCKON, 0.1);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		for (text in textGrp.members)
		{
			text.screenCenter(X);
			text.y = text.ID * 128;
			text.color = FlxColor.WHITE;

			if (curSelect == text.ID)
			{
				text.color = FlxColor.YELLOW;
				camFollow.y = text.y;
			}
		}

		if (Controls.ui_up.justPressed)
			changeSelect(-1);
		if (Controls.ui_down.justPressed)
			changeSelect(1);
	}

	function changeSelect(selection:Int)
	{
		curSelect += selection;

		if (curSelect < 0)
			curSelect = entries.length - 1;
		
		if (curSelect > entries.length - 1)
			curSelect = 0;
	}
}
