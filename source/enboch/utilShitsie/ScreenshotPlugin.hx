package enboch.utilShitsie;

import enboch.utilShitsie.controls.Controls;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSignal;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.PNGEncoderOptions;
import openfl.display.Sprite;
import openfl.utils.ByteArray;

using StringTools;

class ScreenshotPlugin extends FlxBasic
{
	public static function init()
	{
		if (web)
			return;

		FlxG.plugins.addPlugin(new ScreenshotPlugin());
	}

	public function new()
	{
		super();
	}

	public static var preScreenshot:FlxSignal = new FlxSignal();
	public static var postScreenshot:FlxSignal = new FlxSignal();

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (Controls.screenshot.justPressed)
		{
			preScreenshot.dispatch();

			FlxG.state.draw();
			var data = BitmapData.fromImage(FlxG.stage.window.readPixels());
			var screenshot:ByteArray = data.encode(data.rect, new PNGEncoderOptions());

			var date = Date.now().toString().replace('/', '_').replace(':', '-');

			#if sys
			if (!FileSystem.exists('content/screenshots'))
				FileSystem.createDirectory('content/screenshots');

			File.saveBytes('content/screenshots/$date.png', screenshot);
			showFancyPreview(data);
			FlxG.sound.play('screenshot'.makePath(audio));

			// trace('Took screenshot: $date');
			#end

			postScreenshot.dispatch();
		}
	}

	public function showFancyPreview(data:BitmapData)
	{
		var previewSprite:Bitmap = new Bitmap(data);
		FlxG.stage.addChild(previewSprite);

		var flashSprite:Sprite = new Sprite();
		var flashBitmap = new Bitmap(new BitmapData(FlxG.width * 2, FlxG.height * 2, true,
			Paycheck.game.settings?.screenshotFlash ? FlxColor.WHITE : FlxColor.TRANSPARENT));

		flashSprite.mouseEnabled = false;
		flashSprite.addChild(flashBitmap);

		FlxG.stage.addChild(flashSprite);

		var fancyPreviewTween:FlxTween = null;
		var fancyPreviewFlashTween:FlxTween = null;

		fancyPreviewFlashTween = FlxTween.tween(flashSprite, {
			alpha: 0
		}, 1, {
			ease: FlxEase.sineInOut,
			onComplete: t ->
			{
				FlxG.stage.removeChild(flashSprite);
				fancyPreviewFlashTween.destroy();
			}
		});

		fancyPreviewTween = FlxTween.tween(previewSprite, {
			scaleX: 0.2,
			scaleY: 0.2,
			x: 0,
			y: 0
		}, 1, {
			ease: FlxEase.sineInOut
		}).then(FlxTween.tween(previewSprite, {alpha: 0, y: -previewSprite.height}, 1, {
			startDelay: 1,
			onComplete: t ->
			{
				FlxG.stage.removeChild(previewSprite);
				previewSprite.bitmapData.dispose();

				fancyPreviewTween.destroy();
			}
		}));

		function stateTransition()
		{
			fancyPreviewTween.cancel();
			fancyPreviewFlashTween.cancel();

			FlxG.stage.removeChild(previewSprite);
			previewSprite.bitmapData.dispose();

			fancyPreviewTween.destroy();
			fancyPreviewFlashTween.destroy();

			FlxG.signals.postStateSwitch.remove(stateTransition);
		}

		FlxG.signals.postStateSwitch.add(stateTransition);
	}
}
