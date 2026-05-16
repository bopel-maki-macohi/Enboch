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
		GamejoltAPI.unlockTrophy(this.ID, callbackFucker);
	}
}
