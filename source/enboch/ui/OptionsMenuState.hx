package enboch.ui;

import enboch.utilShitsie.EnboState;
import enboch.utilShitsie.controls.Controls;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;

class OptionsMenuState extends EnboState
{
	public var textGrp:FlxTypedSpriteGroup<FlxText>;

	var entries:Map<String, Void->Void> = [
		'Screenshot Flash' => function()
		{
			Paycheck.game.settings.screenshotFlash = !Paycheck.game.settings.screenshotFlash;
		},
	];

	var entryTexts:Map<String, Void->String> = [
		'Screenshot Flash' => function()
		{
			return 'Screenshot Flash (${(Paycheck.game.settings.screenshotFlash) ? 'On' : 'Off'})';
		},
	];

	var camFollow:FlxObject;

	var curSelect:Int = 0;

	var swagShitMoneyMoney:FlxText;

	override function create()
	{
		transIn = null;
		super.create();

		add(textGrp = new FlxTypedSpriteGroup<FlxText>());

		canSelect = false;

		FlxTimer.wait((1 + [for (key in entries.keys()) key].length * .1), () ->
		{
			canSelect = true;
		});

		var i = 0;
		for (entry => method in entries)
		{
			if (entry == '' || entry == null)
				continue;

			var newText = new FlxText(0, 0, 0, (entryTexts.get(entry) ?? function()
			{
				return entry;
			})(), 32);
			newText.ID = i;

			newText.screenCenter(X);
			var oldX = newText.x;
			newText.x = -newText.width * 2;
			FlxTween.tween(newText, {x: oldX}, 1, {
				ease: FlxEase.sineInOut,
				startDelay: i * .1,
			});

			textGrp.add(newText);
			i++;
		}

		add(camFollow = new FlxObject(640));
		FlxG.camera.follow(camFollow, LOCKON, 0.1);

		changeSelect(0);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		for (text in textGrp.members)
		{
			if (canSelect)
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

		if (Controls.leave.justPressed)
		{
			canSelect = false;
			for (thing in textGrp)
			{
				FlxTween.tween(thing, {x: FlxG.width + thing.width}, 1, {
					startDelay: thing.ID * .1,
					ease: FlxEase.sineInOut,
				});
			}

			FlxTimer.wait((1 + [for (key in entries.keys()) key].length * .1), () ->
			{
				transOut = null;
				FlxG.switchState(() -> new MainMenuState());
			});
		}

		if (Controls.accept.justPressed && canSelect)
			selectThingy();
	}

	var canSelect:Bool = true;

	function changeSelect(selection:Int)
	{
		curSelect += selection;

		var things = [for (thing in entries.keys()) thing];
		var sel = things[curSelect];

		if (sel == null || sel == '')
		{
			if (selection < 0)
				curSelect--;
			if (selection > 0)
				curSelect++;
		}

		if (curSelect < 0)
			curSelect = things.length - 1;

		if (curSelect > things.length - 1)
			curSelect = 0;

		FlxG.sound.play('ui/ui_scroll'.makePath(audio));

		updateTexts();
	}

	function selectThingy()
	{
		var things = [for (thing in entries.keys()) thing];
		var selection = things[curSelect];

		FlxG.sound.play('ui/ui_select'.makePath(audio));

		trace(selection);
		if (entries.get(selection) != null)
			entries.get(selection)();

		updateTexts();
	}

	function updateTexts()
	{
		var things = [for (thing in entries.keys()) thing];

		for (i => text in textGrp.members)
		{
			if (entryTexts.get(things[i]) != null)
				text.text = entryTexts.get(things[i])();
			else
				text.text = things[i];
		}
	}
}
