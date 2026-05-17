package utilShitsie.video;

import flixel.FlxG;
#if hxvlc
import hxvlc.flixel.FlxVideoSprite;
#end
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

class DesktopVideo extends FlxTypedSpriteGroup<FlxSprite>
{
	override function set_alpha(Value:Float):Float
	{
		return super.set_alpha(Value);
	}

	public var looping:Bool;

	#if hxvlc
	var video:FlxVideoSprite;
	#end

	public function new(filePath:String)
	{
		super();

		#if hxvlc
		video.active = false;

		video.bitmap.onEndReached.add(finishVideo);

		video.bitmap.onFormatSetup.add(function():Void
		{
			if (video.bitmap != null && video.bitmap.bitmapData != null)
			{
				final scale:Float = Math.min(FlxG.width / video.bitmap.bitmapData.width, FlxG.height / video.bitmap.bitmapData.height);

				video.setGraphicSize(video.bitmap.bitmapData.width * scale, video.bitmap.bitmapData.height * scale);
				video.updateHitbox();
				video.screenCenter();
			}
		});

		video.bitmap.onEncounteredError.add(function(msg:String):Void
		{
			trace('Video error: $msg');
			finishVideo();
		});

		if (video != null)
		{
			add(video);

			video.load(filePath, []);
			video.play();
		}
		else
		{
			trace('ALERT: Video is null! Could not play cutscene!');
			finishVideo();
		}
		#else
		finishVideo();
		#end
	}

	function finishVideo()
	{
		#if hxvlc
		if (looping)
		{
			video.play();
			return;
		}

		remove(video);
		#end
	}
}
