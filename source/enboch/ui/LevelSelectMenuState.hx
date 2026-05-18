package enboch.ui;

import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.util.FlxStringUtil;
import flixel.addons.transition.FlxTransitionableState;
import enboch.utilShitsie.Define;
import lime.app.Application;
import enboch.utilShitsie.api.GamejoltAPI;
import enboch.utilShitsie.controls.Controls;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;
import enboch.utilShitsie.EnboState;

class LevelSelectMenuState extends EnboState
{
	public var textGrp:FlxTypedSpriteGroup<FlxText>;

	var entries:Array<String> = ['Drowned', 'Skeleton', 'Guardian',];

	var camFollow:FlxObject;

	var curSelect:Int = 0;

	var swagShitMoneyMoney:FlxText;

	override function create()
	{
		transIn = null;
		super.create();

		add(textGrp = new FlxTypedSpriteGroup<FlxText>());

		canSelect = false;

		FlxTimer.wait((1 + entries.length * .1), () ->
		{
			canSelect = true;
		});

		for (i => entry in entries)
		{
			if (entry == '' || entry == null)
				continue;

			var newText = new FlxText(0, 0, 0, entry, 64);
			newText.ID = i;

			newText.screenCenter(X);
			var oldX = newText.x;
			newText.x = -newText.width * 2;
			FlxTween.tween(newText, {x: oldX}, 1, {
				ease: FlxEase.sineInOut,
				startDelay: i * .1,
			});

			textGrp.add(newText);
		}

		add(camFollow = new FlxObject(640));
		FlxG.camera.follow(camFollow, LOCKON, 0.1);

		swagShitMoneyMoney = new FlxText(0, 0, 0, 'TOTAL MONEY: $' + '${FlxStringUtil.formatMoney(Paycheck.totalPay, false, false)}', 16);
		swagShitMoneyMoney.scrollFactor.set();
		add(swagShitMoneyMoney);

		swagShitMoneyMoney.screenCenter(X);
		
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

			FlxTimer.wait((1 + entries.length * .1), () ->
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

		FlxG.sound.play('ui/ui_scroll'.makePath(audio));
	}

	function selectThingy()
	{
		var selection = entries[curSelect];

		FlxG.sound.play('ui/ui_select'.makePath(audio));

		PlayState.character = selection.toLowerCase();
		FlxG.switchState(() -> new PlayState());
	}
}
