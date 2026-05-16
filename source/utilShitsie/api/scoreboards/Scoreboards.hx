package utilShitsie.api.scoreboards;

import utilShitsie.api.scoreboards.Scoreboard;

class Scoreboards
{
	public static var WAIT_TIME_DROWNED:Scoreboard = new Scoreboard(1083904, 'WT_Drowned');

	public static function WAIT_TIME(char:String)
	{
		switch (char.toLowerCase())
		{
			case 'drowned':
				return WAIT_TIME_DROWNED;
		}

		return null;
	}
}
