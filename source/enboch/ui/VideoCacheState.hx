package enboch.ui;

import enboch.util.EnboState;
import enboch.util.video.IVideo;
import enboch.util.video.Video;
import enboch.util.video.VideoManager;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxTimer;

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
				trace(file);
			}
		}

		VideoManager.onVideoPlay.add(v -> onFilePlay(v.settings.filePath));
		VideoManager.onVideoPlayError.add((v, e) -> onFilePlayError);

		for (file in toCache)
		{
			var vid:Video = null;
			vid = new Video({
				filePath: file,
			});
			vid.alpha = 1 / totalFiles;
			add(vid);
		}

		cachin.alignment = CENTER;
		add(cachin);
	}

	var cachin:FlxText = new FlxText(0, 0, 0, 'Caching shit', 16);

	var errorsStr:String = 'None';

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		cachin.text = 'Cachin shit\n\n${cached} / ${totalFiles}\n\nErrors:\n${errorsStr}';
		cachin.screenCenter();
	}

	function onFilePlayError(video:IVideo<Any>, error:String)
	{
		trace('Error with video "${video.settings.filePath}" : $error');
		onFilePlay(video.settings.filePath);

		if (errorsStr == 'None') errorsStr = '';

		errorsStr += '- "${video.settings.filePath}" : $error\n';
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

		FlxTimer.wait(1, () ->
		{
			FlxG.switchState(InitState.getInitalState().toNextState());
		});
	}
}
