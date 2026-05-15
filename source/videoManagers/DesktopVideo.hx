import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

class DesktopVideo extends FlxTypedSpriteGroup<FlxSprite>
{
	public var finishCallback:Null<Void->Void> = null;
    
	override public function new(videoPath:String)
	{
		super();
	}

	public function pauseVideo() {}

	public function resumeVideo() {}

	public function restartVideo() {}

	public function finishVideo() {}

	public function onVideoReady() {}

    public function onVolumeChanged() {}
}
