package;

import videoManagers.EnboVideo;
import utilShitsie.EnboState;
import flixel.FlxG;
import flixel.text.FlxText;

class DeadState extends EnboState
{
	var videoSpr:EnboVideo;
		var text = new FlxText(0, 0, 0, 'haha u dead lmao', 16);

	override function create()
	{
		super.create();

		add(text);
		text.screenCenter();

		text.alpha = 0;

		videoSpr = new EnboVideo(PlayState.char.getPath(video));
		add(videoSpr);

		videoSpr.finishCallback = onVideoFinished;
	}

	function onVideoFinished()
	{
		remove(videoSpr);
		text.alpha = 1;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justReleased.ENTER)
			FlxG.switchState(() -> new PlayState());
	}
}
