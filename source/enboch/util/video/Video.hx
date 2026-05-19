package enboch.util.video;

#if hxvlc
typedef Video = DesktopVideo;
#elseif web
typedef Video = WebVideo;
#else
class Video extends flixel.FlxSprite
{
	public var settings:enboch.data.VideoSettings;

	public var video:flixel.FlxSprite;

	public function new(a:enboch.data.VideoSettings)
	{
		super();

		trace('NOT HXVLC OR WEB');

		VideoManager.initSettings(a);
		settings = a;

		if (a.onPlay != null)
			a.onPlay();

		visible = false;

	}

	public function startVideo() {}

	public function finishVideo() {}
}
#end
