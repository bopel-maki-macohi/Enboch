package enboch.utilShitsie.video;

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
		video = new FlxVideoSprite(0, 0);
		video.makeGraphic(FlxG.width, FlxG.height, 0x00000000);
		video.updateHitbox();
		video.screenCenter();
		add(video);

		video.bitmap.onEncounteredError.add(function(msg:String):Void
		{
			trace('Video error: $msg');
			finishVideo();
		});

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

		if (video != null)
		{
			if (video.load(settings.filePath.makePath(AssetLibraryPathType.video), ['input-repeat=' + ((!settings.shouldLoop) ? '1' : '65545')])
				&& video.play())
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
		#else
		if (settings.onPlayError != null)
			settings.onPlayError('NOT_HXVLC');
		trace('NOT_HXVLC');

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

		video.stop();
		remove(video);
		video.destroy();
		#end
	}
}
