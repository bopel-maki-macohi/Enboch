package enboch.util.video;

import enboch.data.VideoSettings;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import openfl.events.NetStatusEvent;
import openfl.media.SoundTransform;
import openfl.media.Video;
import openfl.net.NetConnection;
import openfl.net.NetStream;

class WebVideo extends FlxSprite implements IVideo<Video>
{
	public var video:Video;
	public var settings:VideoSettings;

	var netStream:NetStream;

	override function set_alpha(alpha:Float):Float
	{
		if (video != null)
			video.alpha = alpha;

		return this.alpha;
	}

	public function new(settings:VideoSettings)
	{
		super();

		this.settings = settings;

		makeGraphic(2, 2, FlxColor.TRANSPARENT);

		if (!settings.actuallyLoad)
		{
			if (settings.onPlay != null)
				settings.onPlay();

			finishVideo();
			return;
		}

		video = new Video();
		video.x = video.y = 0;
		video.alpha = 0;

		FlxG.game.addChild(video);

		var netConnection:NetConnection = new NetConnection();
		netConnection.connect(null);

		netStream = new NetStream(netConnection);
		netStream.client = {onMetaData: onMeta};
		netConnection.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);

		netStream.play(settings.filePath.makePath(AssetLibraryPathType.video));

		if (settings.shouldLoop)
		{
			#if (js && html5)
			@:privateAccess {
				if (netStream?.__video != null)
					netStream.__video.loop = true;
			}
			#end
		}
	}

	public function startVideo()
	{
		VideoManager.onVideoStart.dispatch();

		if (netStream != null)
			netStream.play(settings.filePath.makePath(AssetLibraryPathType.video));
	}

	public function restartVideo()
	{
		VideoManager.onVideoRestart.dispatch();

		if (netStream != null)
			netStream.seek(0);
	}

	public function pauseVideo()
	{
		VideoManager.onVideoPaused.dispatch();

		if (netStream != null)
			netStream.pause();
	}

	public function resumeVideo()
	{
		VideoManager.onVideoResume.dispatch();

		if (netStream != null)
			netStream.resume();
	}

	public function finishVideo()
	{
		if (settings.shouldLoop)
			return;

		if (!settings.killOnEnd)
			return;

		VideoManager.onVideoFinished.dispatch();

		netStream.dispose();

		if (video != null)
			FlxG.stage.removeChild(video);
	}

	var videoAvailable:Bool = false;
	var frameTimer:Float = 0;

	static final FRAME_RATE:Float = 60;

	public override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (frameTimer >= (1 / FRAME_RATE))
		{
			frameTimer = 0;
			// TODO: We just draw the video buffer to the sprite 60 times a second.
			// Can we copy the video buffer instead somehow?
			pixels.draw(video);
		}

		if (videoAvailable)
			frameTimer += elapsed;
	}

	function onMeta(data:Dynamic)
	{
		if (video == null)
			return;

		video.attachNetStream(netStream);

		videoAvailable = true;

		video.width = FlxG.width;
		video.height = FlxG.height;

		FlxG.sound.onVolumeChange.add(onVolumeChanged);
		onVolumeChanged(FlxG.sound.muted ? 0 : FlxG.sound.volume);

		makeGraphic(Std.int(video.width), Std.int(video.height), FlxColor.TRANSPARENT);
	}

	function onVolumeChanged(volume:Float):Void
	{
		netStream.soundTransform = new SoundTransform(volume);
	}

	function onNetStatus(event:NetStatusEvent)
	{
		trace(event.info.code);

		switch (event.info.code)
		{
			case 'NetStream.Play.Start': //
				if (settings.onPlay != null)
					settings.onPlay();

			case 'NetStream.Play.Complete': finishVideo();
		}
	}
}
