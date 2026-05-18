package ui;

import flixel.FlxG;
import utilShitsie.EnboState;

using haxe.io.Path;

class VideoCacheState extends EnboState
{
	public static var initalized:Bool = false;

	override function create()
	{
		super.create();

		for (file in ''.makePath(video).readDirectory())
		{
			if (file.extension() == 'mp4')
			{
				trace(file);
			}
		}
	}

	function onDone()
	{
		initalized = true;

		FlxG.switchState(InitState.getInitalState());
	}
}
