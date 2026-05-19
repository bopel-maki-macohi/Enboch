package enboch.ui;

import enboch.util.EnboState;
import enboch.util.controls.Controls;
import enboch.util.video.Video;
import flixel.FlxG;
import flixel.math.FlxMath;

class TrophiesMenuState extends EnboState
{
	var entries:Array<String> = ['drowned', 'drowned'];

	public static var videos:Array<Video> = null;

	override public function new()
	{
		super();

		if (videos == null)
		{
			videos = [];

			for (i => entry in entries)
			{
				var vid:Video = new Video({
					filePath: 'trophies/$entry',
					killOnEnd: false,
				});
				vid.ID = i;
				vid.alpha = 0;

				videos.push(vid);
			}
		}
	}

	override function create()
	{
		super.create();

		for (video in videos)
			add(video);

		changeSelection(0);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		for (video in videos)
		{
			video.alpha = FlxMath.lerp(video.alpha, (currentSelection == video.ID) ? 1 : 0, 0.1);
			video.screenCenter();
		}

		if (Controls.ui_left.justPressed && canDoShit)
			changeSelection(-1);
		if (Controls.ui_right.justPressed && canDoShit)
			changeSelection(1);
		
		if (Controls.leave.justPressed && canDoShit)
		{
			canDoShit = false;
			FlxG.switchState(() -> new MainMenuState());
		}
	}

	var currentSelection:Int = 0;
	var canDoShit:Bool = true;

	function changeSelection(amount:Int)
	{
		currentSelection += amount;

		if (currentSelection < 0)
			currentSelection = videos.length - 1;
		if (currentSelection > videos.length - 1)
			currentSelection = 0;

		for (video in videos)
		{
			if (currentSelection == video.ID)
				video.restartVideo();
			else
				video.pauseVideo();
		}
	}
}
