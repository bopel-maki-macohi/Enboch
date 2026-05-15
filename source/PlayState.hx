package;

import utilShitsie.RNGUtil;
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
	var char:String = 'drowned';

	var charAssetsList:Array<FlxGraphic> = [];

	var charState:Int = -1;
	var debugTXT:FlxText;

	var itemSpr:FlxSprite;
	var itemAssetsList:Array<FlxGraphic> = [];

	var rngList:Array<Int> = [];
	var encryptedRng:Array<String> = [];

	function makeRNGList()
	{
		rngList = RNGUtil.generateRNGList(5);
		updateRNGEncryption();
	}

	function updateRNGEncryption()
	{
		encryptedRng = utilShitsie.RNGCodeEncrypt.encrypt(rngList);
	}

	var stateChangeTmr:FlxTimer;
	var killTmr:FlxTimer;

	override public function create()
	{
		super.create();

		charAssetsList = [];
		itemAssetsList = [];

		for (i in 0...4)
		{
			charAssetsList.push(FlxG.bitmap.add('$char/char-phase$i'.getPath(image)));
			itemAssetsList.push(FlxG.bitmap.add('$char/item-phase$i'.getPath(image)));
		}

		for (graphic in charAssetsList)
			if (graphic != null)
				graphic.persist = true;

		for (graphic in itemAssetsList)
			if (graphic != null)
				graphic.persist = true;

		charSpr = new FlxSprite(0, 0);
		itemSpr = new FlxSprite(0, 0);

		addMultiple([
			charSpr,
			itemSpr,

			#if debug
			debugTXT = new FlxText(0, 0, 0, '', 16),
			#end
		]);

		stateChangeCheck(null);

		resetRSCT();

		killTmr = new FlxTimer();
	}

	override function destroy()
	{
		for (graphic in charAssetsList)
			graphic?.destroy();

		for (graphic in itemAssetsList)
			graphic?.destroy();

		super.destroy();
	}

	function resetRSCT()
	{
		if (stateChangeTmr != null)
			return;

		stateChangeTmr = new FlxTimer();
		stateChangeTmr.start(5, stateChangeCheck, 0);
	}

	function stateChangeCheck(t:FlxTimer)
	{
		var prevState:Int = charState;

		if (charState < 0)
			charState = 0;

		if (t != null)
		{
			switch (rngList[0])
			{
				case 0, 3, 6, 9:
					if (charState == 0)
						charState = (rngList[2] < 10) ? 1 : 2;
				case 1, 4, 7, 10:
					if (charState == 1)
						charState = (rngList[2] < 10) ? 2 : 1;
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
				Paycheck.getPayed(((4 - charState) / 4));
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
		debugTXT.text = '$charState\n${encryptedRng.join('')}\n${charSpr.alpha}\n$itemAbuseCounter\n${Paycheck.totalPay}';
		#end

		if (FlxG.mouse.justPressed && charSpr.alpha == 1)
			useItem();
	}

	var itemAbuseCounter:Int = 0;

	function updateItemRNG()
	{
		var itemRNG = RNGUtil.generateRNGList(2);

		// trace(rngList);

		rngList[3] = itemRNG[0];
		rngList[4] = itemRNG[1];

		// trace(rngList);

		updateRNGEncryption();
	}

	function useItem()
	{
		if (charState > 2)
			return;

		if (charState < 1)
		{
			if (rngList[3] < 2)
				itemAbuseCounter++;
			updateItemRNG();

			return;
		}

		if (rngList[4] < 8)
		{
			updateItemRNG();
			return;
		}

		characterFlash();

		if (itemAbuseCounter > 1 && rngList[3] == 10)
			itemAbuseCounter--;

		rngList[0] = -1;
		stateChangeCheck(stateChangeTmr);
	}
}
