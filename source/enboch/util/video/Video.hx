package enboch.util.video;

#if hxvlc
typedef Video = DesktopVideo;
#elseif web
typedef Video = WebVideo;
#else
import enboch.data.VideoSettings;
import flixel.FlxSprite;

class Video extends FlxSprite implements IVideo<FlxSprite>
{
	public var video:FlxSprite;
	public var settings:VideoSettings;

	public function new(a:VideoSettings)
	{
		super();

		trace('NOT HXVLC OR WEB');

		VideoManager.initSettings(a);
		this.settings = a;

		if (a.onPlay != null)
			a.onPlay();

		visible = false;

	}

	public function startVideo() {}

	public function pauseVideo() {}

	public function resumeVideo() {}

	public function restartVideo() {}

	public function finishVideo() {}
}
#end
