package videoManagers;

import flixel.FlxG;
import hxvlc.flixel.FlxVideoSprite;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

class DesktopVideo extends FlxTypedSpriteGroup<FlxSprite>
{
	var video:FlxVideoSprite;

	public var finishCallback:Null<Void->Void> = null;

	override public function new(videoPath:String)
	{
		super();

		video = new FlxVideoSprite();

		if (video == null)
		{
			finishVideo();
			return;
		}

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
			trace('DesktopVideo Error : $msg');
			finishVideo();
		});

		video.bitmap.onEndReached.add(finishVideo);

		if (video.load(videoPath, []) && video.play())
			onVideoReady();
	}

	public function pauseVideo()
	{
		if (video != null)
			video.pause();
	}

	public function resumeVideo()
	{
		if (video != null)
			video.resume();
	}

	public function restartVideo()
	{
		if (video != null)
		{
			video.bitmap.time = 0;
			video.resume();
		}
	}

	public function finishVideo()
	{
		if (video != null)
			remove(video);

		if (finishCallback != null)
			finishCallback();
	}

	public function onVideoReady()
	{
		FlxG.sound.onVolumeChange.add(onVolumeChanged);
		onVolumeChanged(FlxG.sound.muted ? 0 : FlxG.sound.volume);
	}

	public function onVolumeChanged(volume:Float)
	{
		if (video != null)
			video.bitmap.volume = volume;
	}

	override function destroy()
	{
		FlxG.sound.onVolumeChange.remove(onVolumeChanged);
		finishVideo();

		super.destroy();
	}
}
