package videoManagers;

#if hxvlc
typedef EnboVideo = DesktopVideo;
#elseif html5
typedef EnboVideo = WebVideo;
#else
class EnboVideo extends flixel.FlxBasic
{
	public var finishCallback(default, set):Null<Void->Void> = null;

	function set_finishCallback(callback:Null<Void->Void>):Null<Void->Void>
	{
		if (callback != null)
			callback();

		return callback;
	}

	override public function new(filePath:String)
	{
		super();
	}
}
#end
