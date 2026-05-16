package ui.debug;

import utilShitsie.trophies.Trophies;
import utilShitsie.trophies.TrophyToast;
import utilShitsie.controls.Controls;
import utilShitsie.EnboState;

class TrophyTesting extends EnboState
{
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (Controls.accept.justPressed)
		{
			TrophyToast.displayToastFor(Trophies.DROWNED_PLAY.ID);
		}
	}
}
