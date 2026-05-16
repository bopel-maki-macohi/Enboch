package ui.debug;

import flixel.util.FlxColor;
import flixel.FlxG;
import utilShitsie.trophies.Trophies;
// import utilShitsie.trophies.TrophyToastHolder;
import utilShitsie.controls.Controls;
import utilShitsie.EnboState;

class TrophyTesting extends EnboState
{
	override function create()
	{
		super.create();

		FlxG.camera.bgColor = FlxColor.WHITE;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (Controls.accept.justPressed)
		{
			Trophies.DROWNED_PLAY.unlock();
			// TrophyToastHolder.displayToastFor(Trophies.DROWNED_PLAY.ID);
		}
	}
}
