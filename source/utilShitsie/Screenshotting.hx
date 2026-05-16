package utilShitsie;

import sys.io.File;
import openfl.display.PNGEncoderOptions;
import openfl.display.BitmapData;
import openfl.utils.ByteArray;
import flixel.FlxG;
import flixel.FlxBasic;

class Screenshotting extends FlxBasic
{
	public static function init()
	{
		FlxG.plugins.addPlugin(new Screenshotting());
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

        if (FlxG.keys.justPressed.F3)
        {
            var data = BitmapData.fromImage(FlxG.stage.window.readPixels());
            var screenshot:ByteArray = data.encode(data.rect, new PNGEncoderOptions());

            File.saveBytes('screenshot-${Date.now().getTime() / 1000}', screenshot);
        }
	}
}
