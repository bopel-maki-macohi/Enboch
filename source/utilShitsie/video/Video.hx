package utilShitsie.video;

import flixel.FlxSprite;

#if hxvlc
typedef Video = DesktopVideo;
#elseif web
typedef Video = WebVideo;
#else
class Video extends FlxSprite
{
	public function new(a:VideoSettings)
	{
		super();

		trace('NOT HXVLC OR WEB');

		if (a.onPlay != null)
			a.onPlay();
	}
}
#end
