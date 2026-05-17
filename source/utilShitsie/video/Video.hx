package utilShitsie.video;

import flixel.FlxSprite;

#if hxvlc
typedef Video = DesktopVideo;
#elseif web
typedef Video = WebVideo;
#else
class Video extends FlxSprite
{
	public var looping:Bool = false;

	public function new(a)
	{
		super();
	}
}
#end
