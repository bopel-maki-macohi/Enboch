package utilShitsie.trophies;

import utilShitsie.api.GamejoltAPI;

class Trophy
{
	public var ID(default, null):Int = 0;

	public function new(ID:Int)
	{
		this.ID = ID;
	}

	public function unlock(?callbackFucker:Bool->Void)
	{
		if (Paycheck.game.trophies.contains(this.ID))
			return;

		Paycheck.game.trophies.push(this.ID);
		GamejoltAPI.unlockTrophy(this.ID, callbackFucker);
	}
}
