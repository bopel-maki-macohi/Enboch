package utilShitsie.video;

#if hxvlc
import flixel.FlxG;
import hxvlc.flixel.FlxVideoSprite;

class DesktopVideo extends FlxVideoSprite
{
	public var looping:Bool = false;

	public function new(settings:VideoSettings)
	{
		super();

		trace(settings);
		this.looping = settings.shouldLoop;

		makeGraphic(FlxG.width, FlxG.height, 0x00000000);
		updateHitbox();
		screenCenter();

		bitmap.onEncounteredError.add(function(msg:String):Void
		{
			trace('Video error: $msg');
			finishVideo();
		});

		bitmap.onEndReached.add(finishVideo);

		bitmap.onFormatSetup.add(function():Void
		{
			if (bitmap != null && bitmap.bitmapData != null)
			{
				final scale:Float = Math.min(FlxG.width / bitmap.bitmapData.width, FlxG.height / bitmap.bitmapData.height);

				setGraphicSize(bitmap.bitmapData.width * scale, bitmap.bitmapData.height * scale);
				updateHitbox();
				screenCenter();
			}
		});

		if (video != null)
		{
			if (load(settings.filePath, ['input-repeat=' + ((!settings.shouldLoop) ? '1' : '65545')]) && play())
			{
				if (settings.onPlay != null)
					settings.onPlay();

				trace('PLAYING');
			}
			else
			{
				if (settings.onPlayError != null)
					settings.onPlayError('COULDNT_PLAY');
				trace('COULDNT_PLAY');

				finishVideo();
			}
		}
		else
		{
			if (settings.onPlayError != null)
				settings.onPlayError('NULL_VIDEO');
			trace('NULL_VIDEO');

			finishVideo();
		}
	}

	function finishVideo()
	{
		if (looping)
		{
			play();
			return;
		}

		stop();
		destroy();
	}
}
#end
