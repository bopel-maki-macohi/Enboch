package enboch.ui;

import flixel.text.FlxText;
import enboch.utilShitsie.video.Video;
#if sys
import sys.thread.Thread;
#end
import flixel.FlxG;
import enboch.utilShitsie.EnboState;

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
			var vid = new Video({
				filePath: file,
				onPlay: function()
				{
					onFilePlay(file);
				},
				onPlayError: function(e)
				{
					trace('$file : $e');
					onFilePlay(file);
				},
			});
			// add(vid);

			trace(file);
		}

		add(cachin);
	}

	var cachin:FlxText = new FlxText(0, 0, 0, 'Caching shit', 16);

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		cachin.text = 'Cachin shit\n\n${cached} / ${totalFiles}';
		cachin.screenCenter();
	}

	function onFilePlay(file)
	{
		trace('Cached $file');

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
