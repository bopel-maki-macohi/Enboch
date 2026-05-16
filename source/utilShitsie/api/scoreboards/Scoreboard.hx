package utilShitsie.api.scoreboards;

class Scoreboard
{
	var allowGuest:Bool = true;
	var guestName:String = 'Guest';

	var tableID:Int;
	var extraData:String;

	public function new(tableID:Int, allowGuest:Bool = true, ?extraData:String)
	{
		this.tableID = tableID;
		this.allowGuest = allowGuest;
		this.extraData = extraData;

		guestName += '_${Date.now().getTime() / 1000}';
	}

	public function addScore(scoreStr:String, score:Float, ?thirdWheel:Dynamic)
	{
		GamejoltAPI.addScore(scoreStr, score, tableID, allowGuest, guestName, extraData, thirdWheel);
	}
}
