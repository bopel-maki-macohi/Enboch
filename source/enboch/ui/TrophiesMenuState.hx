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

			for (i => entry in entries)
			{
				var vid:Video = new Video({
					filePath: 'trophies_$entry',
					killOnEnd: false,
					instaStart: false,
				});
				vid.ID = i;

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

	var currentSelection:Int = 0;

	function changeSelection(amount:Int)
	{
		for (video in videos)
		{
			if (currentSelection == video.ID)
			{
				videos[currentSelection].startVideo();
			}
		}
	}
}
