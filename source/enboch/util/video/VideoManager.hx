package enboch.util.video;

import enboch.data.VideoSettings;
import flixel.util.FlxSignal;

typedef VideoSignal = FlxTypedSignal<IVideo<Any>->Void>;
typedef VideoErrorSignal = FlxTypedSignal<IVideo<Any>->String->Void>;

class VideoManager
{
	public static var onVideoPlay:VideoSignal = new VideoSignal();
	public static var onVideoPlayError:VideoErrorSignal = new VideoErrorSignal();

	public static var onVideoStart:FlxSignal = new FlxSignal();

	public static var onVideoPaused:FlxSignal = new FlxSignal();
	public static var onVideoResume:FlxSignal = new FlxSignal();
	public static var onVideoRestart:FlxSignal = new FlxSignal();

	public static var onVideoFinished:FlxSignal = new FlxSignal();
	public static var onVideoLooped:FlxSignal = new FlxSignal();

	public static function initSettings(settings:VideoSettings)
	{
		settings.actuallyLoad ??= true;
		settings.instaStart ??= true;
		settings.killOnEnd ??= true;
		settings.shouldLoop ??= false;
		settings.persist ??= false;

		settings.playbackRate ??= 1.0;
	}
}
