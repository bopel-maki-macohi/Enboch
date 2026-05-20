package enboch.ui;

import enboch.game.GameConfigSetter;
import enboch.game.PlayState;
import enboch.util.EnboState;
import enboch.util.controls.Controls;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;

class LevelSelectMenuState extends EnboState
{
	public var textGrp:FlxTypedSpriteGroup<FlxText>;

	var entries:Array<String> = 'ui/levelselect/entries'.makePath(text).readFile().splitTextBy();

	var camFollow:FlxObject;

	var curSelect:Int = 0;

	var swagShitMoneyMoney:FlxText;
	var paydayBitch:FlxText;

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

			var newText = new FlxText(0, 0, 0, '$entry', 32);
			newText.ID = i;

			newText.x = -newText.width * 2;
			FlxTween.tween(newText, {x: 0}, 1, {
				ease: FlxEase.sineInOut,
				startDelay: i * .1,
			});

			textGrp.add(newText);
		}

		add(camFollow = new FlxObject(640));
		FlxG.camera.follow(camFollow, LOCKON, 0.1);

		swagShitMoneyMoney = new FlxText(0, 0, FlxG.width, 'PAYCHECK: $' + '${FlxStringUtil.formatMoney(Paycheck.totalPay, false, true)}', 32);
		swagShitMoneyMoney.scrollFactor.set();

		var swagBG = new FlxSprite(swagShitMoneyMoney.x,
			swagShitMoneyMoney.y).makeGraphic(Math.round(swagShitMoneyMoney.width), Math.round(swagShitMoneyMoney.height), FlxColor.BLACK);
		add(swagBG);

		add(swagShitMoneyMoney);

		swagShitMoneyMoney.alpha = 0;

		FlxTween.tween(swagShitMoneyMoney, {alpha: 1}, (1 + entries.length * .1), {
			ease: FlxEase.sineInOut,
		});

		paydayBitch = new FlxText(0, 0, FlxG.width, 'Pay day bitch', 32);
		paydayBitch.scrollFactor.set();

		var payBG = new FlxSprite(paydayBitch.x,
			paydayBitch.y).makeGraphic(Math.round(paydayBitch.width), Math.round(paydayBitch.height), FlxColor.BLACK);
		add(payBG);
		add(paydayBitch);

		paydayBitch.alpha = 0;

		FlxTween.tween(paydayBitch, {alpha: 1}, (1 + entries.length * .1), {
			ease: FlxEase.sineInOut,
		});

		changeSelect(0);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		swagShitMoneyMoney.y = FlxG.height - swagShitMoneyMoney.height;

		for (text in textGrp.members)
		{
			if (canSelect)
				text.x = 0;
			text.y = text.ID * 128;
			text.color = FlxColor.WHITE;

			if (curSelect == text.ID)
			{
				text.color = FlxColor.YELLOW;
				camFollow.y = text.y;
			}
		}

		if (Controls.ui_up.justPressed && canSelect)
			changeSelect(-1);
		if (Controls.ui_down.justPressed && canSelect)
			changeSelect(1);

		if (Controls.leave.justPressed && canSelect)
		{
			canSelect = false;
			for (thing in textGrp)
			{
				FlxTween.tween(thing, {x: FlxG.width + thing.width}, 1, {
					startDelay: thing.ID * .1,
					ease: FlxEase.sineInOut,
				});
			}

			FlxTween.tween(paydayBitch, {alpha: 0}, (1 + entries.length * .1), {
				ease: FlxEase.sineInOut,
			});

			FlxTween.tween(swagShitMoneyMoney, {alpha: 0}, (1 + entries.length * .1), {
				ease: FlxEase.sineInOut,
				onComplete: t ->
				{
					transOut = null;
					FlxG.switchState(() -> new MainMenuState());
				}
			});
		}

		if (Controls.accept.justPressed && canSelect)
			selectThingy();
	}

	var canSelect:Bool = true;

	function changeSelect(selection:Int)
	{
		curSelect += selection;

		if (curSelect < 0)
			curSelect = entries.length - 1;

		if (curSelect > entries.length - 1)
			curSelect = 0;

		if (entries[curSelect] == null || entries[curSelect] == '')
		{
			if (selection < 0)
				changeSelect(-1);
			if (selection > 0)
				changeSelect(1);

			return;
		}

		FlxG.sound.play('ui/ui_scroll'.makePath(audio));

		paydayBitch.text = 'Base Pay: $' + '${GameConfigSetter.getBasePay(entries[curSelect])}';
	}

	function selectThingy()
	{
		var selection = entries[curSelect];

		FlxG.sound.play('ui/ui_select'.makePath(audio));

		PlayState.character = selection.toLowerCase();
		FlxG.switchState(() -> new PlayState());
	}
}
