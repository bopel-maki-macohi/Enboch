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

	public var looping(default, set):Bool = false;

	function set_looping(l:Bool):Bool
	{
		#if (js && html5)
		@:privateAccess {
			if (netStream?.__video != null)
				netStream.__video.loop = l;
		}
		#end

		return l;
	}

	public var alpha(get, set):Float;

	function get_alpha():Float
	{
		return vid.alpha;
	}

	function set_alpha(alpha:Float):Float
	{
		return vid.alpha = alpha;
	}

	public var vidPath:String = '';

	public function new(vidPath:String, ?back:Bool = false)
	{
		super();

		this.vidPath = vidPath;

		vid = new Video();
		vid.x = vid.y = 0;
		if (back)
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
			return;

		netStream.dispose();
		FlxG.stage.removeChild(vid);
	}
}
