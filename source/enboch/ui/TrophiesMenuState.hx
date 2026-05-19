package enboch.ui;

import enboch.util.EnboState;
import enboch.util.controls.Controls;
import enboch.util.video.Video;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.text.FlxText;

class TrophiesMenuState extends EnboState
{
	var entries:Array<String> = 'ui/trophies/_entries'.makePath(text).readFile().splitTextBy();
	var entry_relations:Map<String, Array<String>> = [];

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
					persist: true,
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

		for (entry in entries)
		{
			if (!'ui/trophies/$entry'.makePath(text).pathExists())
				return;

			var file:Array<String> = 'ui/trophies/$entry'.makePath(text).readFile().splitTextBy();

			entry_relations.set(entry, file);
		}

		addMultiple(cast videos);

		trophyTitle = new FlxText(0, 0, 0, '', 32);
		trophyDescription = new FlxText(0, 0, 0, '', 16);

		addMultiple([trophyTitle, trophyDescription]);

		changeSelection(0);
	}

	public var trophyID(get, never):Int;

	function get_trophyID():Int
		return Std.parseInt(entry_relations.get(entries[currentSelection])[0] ?? '0');

	var trophyTitle:FlxText;
	var trophyDescription:FlxText;

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

		trophyTitle.screenCenter();

		trophyDescription.screenCenter();
		trophyDescription.y = FlxG.height - trophyDescription.height;
		trophyTitle.y = trophyDescription.y - trophyTitle.height;
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

		trophyTitle.text = entry_relations.get(entries[currentSelection])[1];
		trophyDescription.text = entry_relations.get(entries[currentSelection])[2];

		for (video in videos)
		{
			if (currentSelection == video.ID)
				video.restartVideo();
			else
				video.pauseVideo();
		}
	}
}
