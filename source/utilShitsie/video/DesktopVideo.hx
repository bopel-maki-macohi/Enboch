package utilShitsie.video;

import flixel.FlxG;
#if hxCodec
import hxcodec.flixel.FlxVideoSprite;
#end
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

class DesktopVideo extends FlxTypedSpriteGroup<FlxSprite>
{
	override function set_alpha(Value:Float):Float
	{
		#if hxCodec
		if (video != null)
			video.alpha = Value;
		#end

		return super.set_alpha(Value);
	}

	public var looping:Bool;

	#if hxCodec
	var video:FlxVideoSprite;
	#end

	public function new(settings:VideoSettings)
	{
		super();

		#if hxCodec
		video = new FlxVideoSprite();

		if (video != null)
		{
			video.bitmap.onEndReached.add(finishVideo);

			// Resize videos bigger or smaller than the screen.
			video.bitmap.onTextureSetup.add(() ->
			{
				video.setGraphicSize(FlxG.width, FlxG.height);
				video.updateHitbox();
				video.x = 0;
				video.y = 0;
				// video.scale.set(0.5, 0.5);
			});

			video.bitmap.onEncounteredError.add(function()
			{
				trace('Video Error');

				finishVideo();
			});

			video.bitmap.onPlaying.add(function()
			{
				add(video);
			});

			video.play(settings.filePath.makePath(AssetLibraryPathType.video), settings.shouldLoop);
			looping = settings.shouldLoop;

			//   onVideoStarted.dispatch();
		}
		else
		{
			trace('ALERT: Video is null! Could not play video!');
			finishVideo();
		}
		#else
		finishVideo();
		#end
	}

	function finishVideo()
	{
		#if hxCodec
		if (looping)
		{
			video.bitmap.time = 0;
			return;
		}

		video.stop();
		remove(video);

		video.destroy();
		video = null;
		#end
	}
}
