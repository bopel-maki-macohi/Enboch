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

	public var looping:Bool = false;

	#if hxvlc
	var video:FlxVideoSprite;
	#end

	public function new(settings:VideoSettings)
	{
		super();

		this.looping = settings.shouldLoop;

		#if hxvlc
		video = new FlxVideoSprite();

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

			video.load(settings.filePath, ['input-repeat=' + ((!settings.shouldLoop) ? '1' : '65545')]);
			video.play();

			if (settings.onPlay != null)
				settings.onPlay();
		}
		else
		{
			trace('ALERT: Video is null! Could not play cutscene!');
			finishVideo();

			if (settings.onPlayError != null)
				settings.onPlayError('NULL_VIDEO');
			trace('NULL_VIDEO');
		}
		#else
		finishVideo();

		if (settings.onPlayError != null)
			settings.onPlayError('NOT_HXVLC');
		trace('NOT_HXVLC');
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
