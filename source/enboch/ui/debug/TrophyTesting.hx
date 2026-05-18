package enboch.ui.debug;

import flixel.util.FlxColor;
import flixel.FlxG;
import enboch.utilShitsie.api.trophies.Trophies;
// import enboch.utilShitsie.api.trophies.TrophyToastHolder;
import enboch.utilShitsie.controls.Controls;
import enboch.utilShitsie.EnboState;

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
