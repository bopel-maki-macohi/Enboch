package enboch.utilShitsie.api.scoreboards;

class Scoreboard
{
	var allowGuest:Bool = true;
	var guestName:String = 'Guest';

	var tableID:Int;

	public function new(tableID:Int, guestPrefix:String, allowGuest:Bool = true)
	{
		this.tableID = tableID;
		this.allowGuest = allowGuest;

		guestName = '${guestPrefix}_${guestName}_${Date.now().getTime() / 1000}';
	}

	public function addScore(scoreStr:String, score:Float, extraData:Dynamic, ?thirdWheel:Dynamic)
	{
		GamejoltAPI.addScore(scoreStr, score, tableID, allowGuest, guestName, extraData, thirdWheel);
	}
}
