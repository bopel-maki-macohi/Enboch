package;

import utilShitsie.trophies.Trophies;
import ui.MainMenuState;
import utilShitsie.controls.Controls;
import utilShitsie.ScreenshotPlugin;
import utilShitsie.RNGUtil;
import utilShitsie.GraphicUtil;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.effects.FlxFlicker;
import utilShitsie.EnboState;
import flixel.graphics.FlxGraphic;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxSprite;

class PlayState extends EnboState
{
	var charSpr:FlxSprite;

	public static var char:String = 'drowned';

	var charAssetsList:Array<FlxGraphic> = [];

	var charState:Int = -1;
	var debugTXT:FlxText;

	var itemSpr:FlxSprite;
	var itemAssetsList:Array<FlxGraphic> = [];

	var rngList:Array<Int> = [];

	function makeRNGList()
		rngList = RNGUtil.generateRNGList(4);

	var stateChangeTmr:FlxTimer = new FlxTimer();
	var killTmr:FlxTimer = new FlxTimer();

	override public function create()
	{
		super.create();

		Paycheck.earned = 0;

		for (i in 0...4)
		{
			charAssetsList.push(FlxG.bitmap.add('characters/$char/char-phase$i'.makePath(image)));
			itemAssetsList.push(FlxG.bitmap.add('characters/$char/item-phase$i'.makePath(image)));
		}

		GraphicUtil.persistGraphics(charAssetsList);
		GraphicUtil.persistGraphics(itemAssetsList);

		addMultiple([
			charSpr = new FlxSprite(0, 0),
			itemSpr = new FlxSprite(0, 0),

			#if debug
			debugTXT = new FlxText(0, 0, 0, '', 16),
			#end
		]);

		stateChangeCheck(null);

		stateChangeTmr.start(5, stateChangeCheck, 0);
	}

	override function preScreenshot()
	{
		super.preScreenshot();

		#if debug
		if (debugTXT != null)
			debugTXT.visible = false;
		#end
	}

	override function postScreenshot()
	{
		super.postScreenshot();

		#if debug
		if (debugTXT != null)
			debugTXT.visible = true;
		#end
	}

	override function destroy()
	{
		GraphicUtil.destroyGraphics(charAssetsList);
		GraphicUtil.destroyGraphics(itemAssetsList);

		super.destroy();
	}

	function stateChangeCheck(t:FlxTimer)
	{
		var prevState:Int = charState;

		if (charState < 0)
			charState = 0;

		if (itemSpam >= itemSpamMax)
		{
			rngList[0] = 2;
			rngList[1] = 0;
			charState = 2;
		}

		if (t != null)
		{
			switch (rngList[0])
			{
				case 0, 3, 6, 9:
					if (charState == 0)
						charState = (itemSpam >= itemSpamMax) ? 3 : ((rngList[2] < 10) ? 1 : 2);
				case 1, 4, 7, 10:
					if (charState == 1)
						charState = (itemSpam >= itemSpamMax) ? 3 : ((rngList[2] < 10) ? 2 : 1);
				case 2, 5, 8:
					if (charState == 2)
					{
						charState = 3; // ur dead lmao
						killTmr.start(3 + rngList[1], jumpscare);
					}

				case -1:
					if (charState > 0)
						charState--;
			}
		}

		makeRNGList();

		if (charState != prevState)
		{
			if (charAssetsList[charState] != null)
			{
				charSpr.loadGraphic(charAssetsList[charState]);
				charSpr.screenCenter();

				characterFlash();
			}

			if (itemAssetsList[charState] != null)
			{
				itemSpr.loadGraphic(itemAssetsList[charState]);
				itemSpr.screenCenter();
			}
		}

		if (t != null)
		{
			t.reset();

			if (charState < 3 && (t.elapsedLoops % 2 == 0))
			{
				final percentage = ((4 - charState) / 4) - ((itemSpam / itemSpamMax) / 2);

				if (char == 'drowned' && percentage == 1)
					Trophies.DROWNED_PLAY.unlock();

				Paycheck.getPayed(percentage);
			}
		}

		// trace(((4 - charState) / 4));
	}

	function characterFlash()
	{
		charSpr.alpha = 0;
		FlxTween.cancelTweensOf(charSpr);
		FlxTween.tween(charSpr, {alpha: 1}, 1, {ease: FlxEase.quintOut});
	}

	function jumpscare(t:FlxTimer)
	{
		stateChangeTmr.cancel();
		stateChangeTmr.destroy();
		stateChangeTmr = null;

		trace('u dead');
		FlxG.switchState(() -> new DeadState());
		// FlxG.resetState();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		#if debug
		debugTXT.text = '$charState\n${charSpr.alpha}\n${Paycheck.totalPay}\n$itemSpam';
		#end

		if (FlxG.mouse.justPressed)
		{
			itemSpam++;

			if (charSpr.alpha == 1)
				useItem();
		}

		if (Controls.leave.justPressed && charState < 3)
			FlxG.switchState(() -> new MainMenuState());
	}

	function updateItemRNG()
	{
		var itemRNG = RNGUtil.generateRNGList(1);

		rngList[3] = itemRNG[0];
	}

	var itemSpam:Int = 0;
	final itemSpamMax:Int = 200;

	function useItem()
	{
		if (charState > 2 || charState < 1)
			return;

		if (itemSpam > 0)
			itemSpam = 0;

		if (rngList[3] < switch (charState)
			{
				case 2: 5;
				default: 8;
			})
		{
			updateItemRNG();
			return;
		}

		characterFlash();

		rngList[0] = -1;
		stateChangeCheck(stateChangeTmr);
	}
}
