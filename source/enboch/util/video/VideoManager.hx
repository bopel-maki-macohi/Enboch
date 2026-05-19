package enboch.util.video;

import enboch.data.VideoSettings;
import flixel.util.FlxSignal;

class VideoManager
{
	public static var onVideoStart:FlxSignal = new FlxSignal();

	public static var onVideoPaused:FlxSignal = new FlxSignal();
	public static var onVideoResume:FlxSignal = new FlxSignal();
	public static var onVideoRestart:FlxSignal = new FlxSignal();
	
	public static var onVideoFinished:FlxSignal = new FlxSignal();
	public static var onVideoLooped:FlxSignal = new FlxSignal();
}
