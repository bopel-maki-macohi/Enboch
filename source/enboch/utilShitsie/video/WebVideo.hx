package enboch.utilShitsie.video;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.math.FlxPoint;
import openfl.events.NetStatusEvent;
import openfl.media.Video;
import openfl.net.NetConnection;
import openfl.net.NetStream;

class WebVideo extends FlxBasic
{
	var vid:Video;

	var netStream:NetStream;

	public var alpha(get, set):Float;

	function get_alpha():Float
	{
		return vid.alpha;
	}

	function set_alpha(alpha:Float):Float
	{
		return vid.alpha = alpha;
	}

	public var scrollFactor:FlxPoint = new FlxPoint();

	var settings:VideoSettings;

	public function new(settings:VideoSettings)
	{
		super();

		this.settings = settings;

		vid = new Video();
		vid.x = vid.y = 0;

		if (!settings.actuallyLoad)
		{
			if (settings.onPlay != null)
				settings.onPlay();

			finishVideo();
			return;
		}

		if (settings?.web_back ?? true)
		{
			trace('Dont forget `FlxG.camera.bgColor.alpha`');
			FlxG.stage.addChildAt(vid, 0);
		}
		else
			FlxG.stage.addChild(vid);

		var netConnection:NetConnection = new NetConnection();
		netConnection.connect(null);

		netStream = new NetStream(netConnection);
		netStream.client = {onMetaData: onMeta};
		netConnection.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);

		netStream.play(settings.filePath.makePath(video));

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
		vid.attachNetStream(netStream);

		vid.width = FlxG.width;
		vid.height = FlxG.height;
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

		netStream.dispose();
		FlxG.stage.removeChild(vid);
	}
}
