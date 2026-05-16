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
	public static final BGBITMAP_PADDING:Int = 16;

	override public function new(trophy:Int)
	{
		super();

		mouseEnabled = false;

		var toastBitmapGraphic:FlxGraphic = FlxGraphic.fromAssetKey('trophies/$trophy'.makePath(image));
		var toastBitmap:Bitmap = new Bitmap(toastBitmapGraphic.bitmap);

		var toastBGBitmapGraphic:FlxGraphic = FlxGraphic.fromRectangle(toastBitmapGraphic.width + BGBITMAP_PADDING,
			toastBitmapGraphic.height + BGBITMAP_PADDING, FlxColor.BLACK);
		var toastBGBitmap:Bitmap = new Bitmap(toastBGBitmapGraphic.bitmap);

		addChild(toastBGBitmap);
		addChild(toastBitmap);

		toastBGBitmap.y = 0;
		toastBitmap.y = toastBGBitmap.y + BGBITMAP_PADDING / 2;

		toastBitmap.x = toastBGBitmap.x + BGBITMAP_PADDING / 2;

		FlxTween.tween(toastBitmap, {alpha: 0}, 1, {
			startDelay: 1,
			onUpdate: t ->
			{
				toastBGBitmap.alpha = toastBitmap.alpha;
			},
			onComplete: t ->
			{
				toastBitmapGraphic.destroy();
				toastBGBitmapGraphic.destroy();

				toastBGBitmap.bitmapData?.dispose();
				toastBitmap.bitmapData?.dispose();

				toastBGBitmap = null;
				toastBitmap = null;

				this.parent.removeChild(this);
			},
		});
	}
}
