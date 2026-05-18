package utilShitsie.video;

import flixel.FlxSprite;

#if hxCodec
typedef Video = DesktopVideo;
#elseif web
typedef Video = WebVideo;
#else
class Video extends FlxSprite
{
	public function new(a:VideoSettings)
	{
		super();

		if (a.onPlay != null)
			a.onPlay();
	}
}
#end
