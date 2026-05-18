package enboch.ui.debug;

import enboch.utilShitsie.EnboState;
import enboch.utilShitsie.api.trophies.Trophies;
// import enboch.utilShitsie.api.trophies.TrophyToastHolder;
import enboch.utilShitsie.controls.Controls;
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
