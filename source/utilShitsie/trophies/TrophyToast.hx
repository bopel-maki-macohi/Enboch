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

class TrophyToast extends Sprite
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

		Main.trophyToast.addToast(trophy);
	}

	public static final BGBITMAP_PADDING:Int = 16;

	public function addToast(trophy:Int)
	{
		var toastHolder:Sprite = new Sprite();
		toastHolder.mouseEnabled = false;

		var toastBitmapGraphic:FlxGraphic = FlxGraphic.fromAssetKey('trophies/$trophy'.makePath(image));
		var toastBitmap:Bitmap = new Bitmap(toastBitmapGraphic.bitmap);

		var toastBGBitmapGraphic:FlxGraphic = FlxGraphic.fromRectangle(toastBitmapGraphic.width + BGBITMAP_PADDING,
			toastBitmapGraphic.height + BGBITMAP_PADDING, FlxColor.BLACK);
		var toastBGBitmap:Bitmap = new Bitmap(toastBGBitmapGraphic.bitmap);

		toastHolder.addChild(toastBGBitmap);
		toastHolder.addChild(toastBitmap);

		shiftChildren(-(toastHolder.height + BGBITMAP_PADDING));

		addChild(toastHolder);

		FlxTween.tween(toastHolder, {alpha: 0}, 1, {
			startDelay: 1,
			onComplete: t ->
			{
				removeChild(toastHolder);
				shiftChildren((toastHolder.height + BGBITMAP_PADDING));

				toastBitmapGraphic.destroy();
				toastBGBitmapGraphic.destroy();

				toastBGBitmap.bitmapData?.dispose();
				toastBitmap.bitmapData?.dispose();

				toastBGBitmap = null;
				toastBitmap = null;
			}
		});
	}

	public function shiftChildren(amount:Float)
	{
		@:privateAccess
		for (child in __children)
			child.y += amount;
	}
}
