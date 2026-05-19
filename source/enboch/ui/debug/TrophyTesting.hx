package enboch.ui.debug;

import enboch.util.EnboState;
import enboch.util.api.trophies.Trophies;
// import enboch.util.api.trophies.TrophyToastHolder;
import enboch.util.controls.Controls;
import flixel.FlxG;
import flixel.util.FlxColor;

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
			Trophies.FULLPAY_DROWNED.unlock();
			// TrophyToastHolder.displayToastFor(Trophies.DROWNED_PLAY.ID);
		}
	}
}
