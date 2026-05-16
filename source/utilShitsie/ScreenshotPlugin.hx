package utilShitsie;

import utilShitsie.controls.Controls;
import flixel.util.FlxTimer;
import flixel.util.FlxSignal;
#if sys
import sys.io.File;
#end
import openfl.display.PNGEncoderOptions;
import openfl.display.BitmapData;
import openfl.utils.ByteArray;
import flixel.FlxG;
import flixel.FlxBasic;

class ScreenshotPlugin extends FlxBasic
{
	public static function init()
	{
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
			FlxTimer.wait(.1, function()
			{
				var data = BitmapData.fromImage(FlxG.stage.window.readPixels());
				var screenshot:ByteArray = data.encode(data.rect, new PNGEncoderOptions());

				var date = Date.now().getTime() / 1000;

				#if sys
				File.saveBytes('content/screenshot-$date.png', screenshot);

				trace('Took screenshot: $date');
				#end

				postScreenshot.dispatch();
			});
		}
	}
}
