package utilShitsie;

import sys.io.File;
import openfl.display.PNGEncoderOptions;
import openfl.display.BitmapData;
import openfl.utils.ByteArray;
import flixel.FlxG;
import flixel.FlxBasic;

class ScreenshotPlugin extends FlxBasic
{
	public static function init()
	{
		#if !debug
		trace('Screenshotting is debug only right now');
		return;
		#end

		FlxG.plugins.addPlugin(new ScreenshotPlugin());
	}

	public function new()
	{
		super();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.F3)
		{
			var data = BitmapData.fromImage(FlxG.stage.window.readPixels());
			var screenshot:ByteArray = data.encode(data.rect, new PNGEncoderOptions());

			var date = Date.now().getTime() / 1000;

			File.saveBytes('screenshot-$date', screenshot);

			trace('Took screenshot: $date');
		}
	}
}
