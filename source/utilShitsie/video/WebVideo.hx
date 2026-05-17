package utilShitsie.video;

import openfl.events.NetStatusEvent;
import openfl.net.NetConnection;
import openfl.net.NetStream;
import flixel.FlxG;
import openfl.media.Video;
import flixel.FlxBasic;

class WebVideo extends FlxBasic
{
	var vid:Video;

	var netStream:NetStream;

	public var looping:Bool = false;

	public var vidPath:String = '';

	public function new(vidPath:String)
	{
		super();

		this.vidPath = vidPath;

		vid = new Video();
		vid.x = vid.y = 0;
		FlxG.addChildBelowMouse(vid);

		var netConnection:NetConnection = new NetConnection();
		netConnection.connect(null);

		netStream = new NetStream(netConnection);
		netStream.client = {onMetaData: onMeta};
		netConnection.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);

		netStream.play(vidPath.makePath(video));
	}

	function onMeta(data:Dynamic)
	{
		vid.attachNetStream(netStream);

		vid.width = FlxG.width;
		vid.height = FlxG.height;
	}

	function onNetStatus(event:NetStatusEvent)
	{
		if (event.info.code == 'NetStream.Play.Complete')
			finishVideo();
	}

	public function finishVideo()
	{
		if (looping)
		{
			netStream.play(vidPath.makePath(video));

			return;
		}

		netStream.dispose();
		FlxG.removeChild(vid);
	}
}
