package utilShitsie.trophies;

import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.graphics.FlxGraphic;
import flixel.FlxG;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.display.DisplayObject;
import openfl.display.Sprite;

class TrophyToastHolder extends Sprite
{
	override public function new()
	{
		super();

		mouseEnabled = false;
	}

	public static function displayToastFor(trophy:Int)
	{
		if (Main.trophyToast == null)
			return;

		Main.trophyToast.displayToast(trophy);
	}

	public function displayToast(trophy:Int)
	{
		var trophyToast = new TrophyToast(trophy);

		trophyToast.y = FlxG.height - trophyToast.height;

		@:privateAccess
		for (child in __children)
			child.y -= trophyToast.height;

		addChild(trophyToast);
	}
}
