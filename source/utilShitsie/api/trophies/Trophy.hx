package utilShitsie.api.trophies;

class Trophy
{
	public var ID(default, null):Int = 0;

	public function new(ID:Int)
	{
		this.ID = ID;
	}

	public function unlock(?callbackFucker:Bool->Void)
	{
		if (Paycheck.game.trophies.contains(ID))
			return;

		Paycheck.game.trophies.push(ID);
		GamejoltAPI.unlockTrophy(ID, callbackFucker);
	}
}
