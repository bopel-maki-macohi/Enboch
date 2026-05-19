package enboch.util.video;

import enboch.data.VideoSettings;

class VideoManager
{
	public static function initSettings(settings:VideoSettings)
	{
		settings.actuallyLoad ??= true;
		settings.instaStart ??= true;
		settings.killOnEnd ??= true;
		settings.shouldLoop ??= false;

        settings.web_back ??= false;
	}
}
