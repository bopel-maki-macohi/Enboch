package enboch.util.video;

import enboch.data.VideoSettings;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
#if hxvlc
import hxvlc.flixel.FlxVideoSprite;
#end

class DesktopVideo extends FlxTypedSpriteGroup<FlxSprite> #if hxvlc implements IVideo<FlxVideoSprite> #end
{
	#if hxvlc
	public var video:FlxVideoSprite;
	#end
	public var settings:VideoSettings;

	public function new(settings:VideoSettings)
	{
		super();

		this.settings = settings;

		if (!settings.actuallyLoad)
		{
			if (settings.onPlay != null)
				settings.onPlay();

			finishVideo();
			return;
		}

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

	#if hxvlc
	public function startVideo()
	{
		if (video == null)
			return;

		VideoManager.onVideoStart.dispatch();
		video.play();
	}

	public function pauseVideo()
	{
		if (video == null)
			return;

		VideoManager.onVideoPaused.dispatch();
		video.pause();
	}

	public function resumeVideo()
	{
		if (video == null)
			return;

		VideoManager.onVideoRestart.dispatch();
		video.resume();
	}

	public function restartVideo()
	{
		if (video == null)
			return;

		VideoManager.onVideoRestart.dispatch();

		video.bitmap.time = 0;
		video.resume();
	}

	public function finishVideo()
	{
		if (video == null)
			return;

		if (settings.shouldLoop)
		{
			VideoManager.onVideoLooped.dispatch();

			video.bitmap.time = 0;
			video.resume();
			return;
		}

		VideoManager.onVideoFinished.dispatch();

		if (settings.killOnEnd)
		{
			video.stop();
			remove(video);
			video.destroy();
		}
	}
	#end
}
