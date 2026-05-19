package enboch.util.video;

import enboch.data.VideoSettings;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.math.FlxMath;
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

		VideoManager.initSettings(settings);

		this.settings = settings;

		if (!settings.actuallyLoad)
		{
			VideoManager.onVideoPlay.dispatch(this);

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

		if (video != null)
		{
			if (loadVideo())
			{
				if (!settings.instaStart)
					return;

				if (playVideo())
					VideoManager.onVideoPlay.dispatch(this);
			}
			else
			{
				VideoManager.onVideoPlayError.dispatch(this, 'COULDNT_PLAY');
				trace('COULDNT_PLAY');

				finishVideo();
			}
		}
		else
		{
			VideoManager.onVideoPlayError.dispatch(this, 'NULL_VIDEO');
			trace('NULL_VIDEO');

			finishVideo();
		}
		#else
		VideoManager.onVideoPlayError.dispatch(this, 'NOT_HXVLC');
		trace('NOT_HXVLC');

		finishVideo();
		#end
	}

	#if hxvlc
	function loadVideo()
	{
		var opts:Array<String> = [];

		opts.push('input-repeat=${((settings.shouldLoop) ? Std.string(FlxMath.MAX_VALUE_INT) : '0')}');

		return video.load(settings.filePath.makePath(AssetLibraryPathType.video), opts);
	}

	function videoFormatSetup()
	{
		if (video.bitmap != null && video.bitmap.bitmapData != null)
		{
			final scale:Float = Math.min(FlxG.width / video.bitmap.bitmapData.width, FlxG.height / video.bitmap.bitmapData.height);

			video.setGraphicSize(video.bitmap.bitmapData.width * scale, video.bitmap.bitmapData.height * scale);
			video.updateHitbox();
			video.screenCenter();
		}
	}

	function playVideo():Bool
	{
		if (video == null)
			return false;

		if (!video.bitmap.onFormatSetup.has(videoFormatSetup))
			video.bitmap.onFormatSetup.add(videoFormatSetup);

		return video.play();
	}

	public function startVideo()
	{
		if (video == null)
			return;

		VideoManager.onVideoStart.dispatch();
		playVideo();
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

		video.pause();
		video.bitmap.position = 0;
		video.resume();
	}

	public function finishVideo()
	{
		if (video == null)
			return;

		VideoManager.onVideoFinished.dispatch();

		if (!settings.persist)
			if (settings.killOnEnd)
			{
				remove(video);

				video.stop();
				video.destroy();
			}
	}

	override function destroy()
	{
		if (settings.persist)
			return;

		if (video != null)
		{
			remove(video);

			video.stop();
			video.destroy();
		}

		super.destroy();
	}
	#end
}
