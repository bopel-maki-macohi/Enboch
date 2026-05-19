package enboch.ui;

import enboch.util.EnboState;
import enboch.util.video.Video;

class TrophiesMenuState extends EnboState
{
	var entries:Array<String> = ['drowned'];

	public static var videos:Array<Video> = null;

	override public function new()
	{
		super();

		if (videos == null)
		{
			videos = [];

			for (entry in entries)
			{
				videos.push(new Video({
					filePath: 'trophies_$entry',
					killOnEnd: false,
				}));
			}
		}
	}

	override function create()
	{
		super.create();

		add(videos[0]);
	}
}
