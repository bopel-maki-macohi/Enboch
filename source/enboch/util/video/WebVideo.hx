package enboch.util.video;

import enboch.data.VideoSettings;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.math.FlxPoint;
import openfl.events.NetStatusEvent;
import openfl.media.Video;
import openfl.net.NetConnection;
import openfl.net.NetStream;

class WebVideo extends FlxBasic
{
	public var video:Video;

	var netStream:NetStream;

	public var alpha(get, set):Float;

	var _alpha:Float = 1.0;

	function get_alpha():Float
	{
		if (video == null)
			return _alpha;

		return video.alpha;
	}

	function set_alpha(alpha:Float):Float
	{
		if (video == null)
			return _alpha = alpha;

		return video.alpha = alpha;
	}

	public var scrollFactor:FlxPoint = new FlxPoint();

	var settings:VideoSettings;

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

		video = new Video();
		video.x = video.y = 0;

		if (settings?.web_back ?? true)
		{
			trace('Dont forget `FlxG.camera.bgColor.alpha`');
			FlxG.stage.addChildAt(video, 0);
		}
		else
			FlxG.stage.addChild(video);

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

	function onMeta(data:Dynamic)
	{
		if (video == null)
			return;

		video.attachNetStream(netStream);

		video.width = FlxG.width;
		video.height = FlxG.height;
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

	public function finishVideo()
	{
		if (settings.shouldLoop)
			return;

		if (!settings.killOnEnd)
			return;

		netStream.dispose();

		if (video != null)
			FlxG.stage.removeChild(video);
	}
}
