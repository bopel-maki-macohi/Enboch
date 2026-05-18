package ui;

import utilShitsie.video.Video;
#if sys
import sys.thread.Thread;
#end
import flixel.FlxG;
import utilShitsie.EnboState;

using haxe.io.Path;

class VideoCacheState extends EnboState
{
	public static var initalized:Bool = false;

	var totalFiles:Int = 0;
	var cached:Int = 0;

	override function create()
	{
		super.create();

		var toCache:Array<String> = [];

		for (file in ''.makePath(video).withoutExtension().readDirectory())
		{
			if (file.extension() == 'mp4')
			{
				totalFiles++;
				toCache.push(file.withoutDirectory().withoutExtension());
			}
		}

		for (file in toCache)
		{
			#if sys
			Thread.create(() ->
			{
				new Video({
					filePath: file,
					onPlay: onFilePlay,
				});
			});
			#end
		}
	}

	function onFilePlay()
	{
		cached++;

		if (cached >= totalFiles)
			onDone();
	}

	function onDone()
	{
		initalized = true;

		FlxG.switchState(InitState.getInitalState().toNextState());
	}
}
