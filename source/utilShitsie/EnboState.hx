package utilShitsie;

import flixel.FlxBasic;
import flixel.FlxState;

class EnboState extends FlxState
{
	public function addMultiple(basics:Array<FlxBasic>)
	{
		for (basic in basics)
			add(basic);
	}
}
