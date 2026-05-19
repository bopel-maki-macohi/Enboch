package enboch.util.video;

#if hxvlc
typedef Video = DesktopVideo;
#elseif web
typedef Video = WebVideo;
#else
class Video extends flixel.FlxSprite
{
	public var video:flixel.FlxSprite;

	public function new(a:enboch.data.VideoSettings)
	{
		super();

		trace('NOT HXVLC OR WEB');

		if (a.onPlay != null)
			a.onPlay();

		visible = false;
	}
}
#end
