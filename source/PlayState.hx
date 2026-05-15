package;

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

	var charState:Int = 0;
	var charStateTXT:FlxText;

	var rngList:Array<Int> = [];
	var rngListText:FlxText;
	var encryptedRng:Array<String> = [];

	function makeRNGList()
	{
		rngList = [
			FlxG.random.int(0, 10),
			FlxG.random.int(0, 10),
			FlxG.random.int(0, 10),
			FlxG.random.int(0, 10),
		];
		encryptedRng = RNGCodeEncrypt.encrypt(rngList);
	}

	var stateChangeTmr:FlxTimer;
	var killTmr:FlxTimer;

	override public function create()
	{
		super.create();

		charAssetsList = [
			FlxG.bitmap.add('$char/$char-0'.getPath(image)),
			FlxG.bitmap.add('$char/$char-1'.getPath(image)),
			FlxG.bitmap.add('$char/$char-2'.getPath(image)),
			FlxG.bitmap.add('$char/$char-3'.getPath(image)),
		];

		for (asset in charAssetsList)
		{
			if (asset == null)
				charAssetsList.remove(asset);
		}

		charSpr = new FlxSprite(0, 0);

		addMultiple([
			charSpr,

			#if debug
			charStateTXT = new FlxText(0, 0, 0, '', 16), //
			rngListText = new FlxText(0, 16, 0, '', 16),
			#end
		]);

		stateChangeCheck(null);

		resetRSCT();

		killTmr = new FlxTimer();
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
						killTmr.start(rngList[1], jumpscare);
					}
			}
		}

		makeRNGList();

		if (charAssetsList[charState] != null)
		{
			charSpr.loadGraphic(charAssetsList[charState]);
			charSpr.screenCenter();

			if (charState != prevState)
			{
				charSpr.alpha = 0;
				FlxTween.cancelTweensOf(charSpr);
				FlxTween.tween(charSpr, {alpha: 1}, 1, {ease: FlxEase.quintOut});
			}
		}
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
		charStateTXT.text = '$charState';
		rngListText.text = '${encryptedRng.join('')}';
		#end
	}
}
