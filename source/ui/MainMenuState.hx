package ui;

import utilShitsie.api.GamejoltAPI;
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

	var entries:Array<String> = [
		'Play',
		// 'Trophies',
		// 'Options',
		'',
		((GamejoltAPI.authenticated) ? 'Gamejolt Logout' : 'Gamejolt Login'),
	];

	var camFollow:FlxObject;

	var curSelect:Int = 0;

	override function create()
	{
		super.create();

		add(textGrp = new FlxTypedSpriteGroup<FlxText>());

		for (i => entry in entries)
		{
			var newText = new FlxText(0, 0, 0, entry, 64);
			newText.ID = i;

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
		if (Controls.accept.justPressed)
			selectThingy();
	}

	function changeSelect(selection:Int)
	{
		curSelect += selection;

		if (entries[curSelect] == null || entries[curSelect] == '')
		{
			if (selection < 0)
				curSelect--;
			if (selection > 0)
				curSelect++;
		}

		if (curSelect < 0)
			curSelect = entries.length - 1;

		if (curSelect > entries.length - 1)
			curSelect = 0;

		FlxG.sound.play('ui_scroll'.makePath(audio));
	}

	function selectThingy()
	{
		var selection = entries[curSelect];

		FlxG.sound.play('ui_select'.makePath(audio));
		switch (selection.toLowerCase())
		{
			case 'levels', 'play':
				FlxG.switchState(() -> new PlayState());

			case 'trophies':
				FlxG.switchState(() -> new TrophiesMenuState());

			case 'gamejolt login':
				FlxG.switchState(() -> new GamejoltLoginState());

			case 'gamejolt logout':
				FlxG.sound.play('gamejolt_logout'.makePath(audio));
				GamejoltAPI.logout(() ->
				{
					FlxG.resetState();
				});
		}
	}
}
