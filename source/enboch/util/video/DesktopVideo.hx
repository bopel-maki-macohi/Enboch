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
		initVid();

		attemptVidLoad();
		#else
		VideoManager.onVideoPlayError.dispatch(this, 'NOT_HXVLC');
		trace('NOT_HXVLC');

		finishVideo();
		#end
	}

	#if hxvlc
	function initVid()
	{
		video = new FlxVideoSprite(0, 0);
		video.makeGraphic(FlxG.width, FlxG.height, 0x00000000);
		video.updateHitbox();
		video.screenCenter();
		add(video);

		video.bitmap.onOpening.add(function():Void
		{
			if (video.bitmap != null)
				video.bitmap.rate = settings.playbackRate;
		});

		video.bitmap.onEncounteredError.add(function(msg:String):Void
		{
			trace('Video error: $msg');
			finishVideo();
		});

		video.bitmap.onEndReached.add(finishVideo);
	}

	function attemptVidLoad()
	{
		if (video != null)
			performVidLoad();
		else
		{
			VideoManager.onVideoPlayError.dispatch(this, 'NULL_VIDEO');
			trace('NULL_VIDEO');

			finishVideo();
		}
	}

	function performVidLoad()
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

	function loadVideo()
	{
		var opts:Array<String> = [];

		opts.push('input-repeat=${((settings.shouldLoop) ? Std.string(FlxMath.MAX_VALUE_INT) : '0')}');

		return video.load(settings.filePath.makePath(AssetLibraryPathType.video), opts);
	}

	var videoScaledUp:Bool = false;

	function videoFormatSetup()
	{
		if (video.bitmap != null && video.bitmap.bitmapData != null)
		{
			videoScaledUp = true;

			video.scale.set(FlxG.width / video.bitmap.bitmapData.width, FlxG.height / video.bitmap.bitmapData.height);
			video.updateHitbox();
			video.screenCenter();

			// trace('${video.width}x${video.height}');

			if (video.width != FlxG.width)
				videoFormatSetup();
		}
	}

	function playVideo():Bool
	{
		if (video == null)
			return false;

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

		VideoManager.onVideoResume.dispatch();
		video.resume();
	}

	public function restartVideo()
	{
		if (video == null)
			return;

		VideoManager.onVideoRestart.dispatch();

		removeVideo();
		initVid();
		attemptVidLoad();
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

		removeVideo();

		super.destroy();
	}

	function removeVideo()
	{
		if (video == null)
			return;

		remove(video);

		video.stop();
		video.destroy();
	}
	#end

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		#if hxvlc
		if (video != null)
			if (!videoScaledUp)
				videoFormatSetup();
		#end
	}
}
