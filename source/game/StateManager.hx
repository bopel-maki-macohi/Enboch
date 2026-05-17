package game;

class StateManager
{
	public static function parseMovementCode(code:String, state:Int, jump:Bool):Int
	{
		switch (code)
		{
			case '400', '300':
				return (!jump) ? 1 : 2;
			case '411':
				return (!jump) ? 2 : 1;
			case '422':
				return 3; // ur dead lmao

			case '311':
				return (!jump) ? 2 : 0; // Be glad you're given a chance

			default:
		}

		return state;
	}

	public static function parseLowerItemUseChance(states:Int, state:Int):Bool
	{
		switch (states)
		{
			case 4:
				return state == 2;
			case 3:
				return state == 1;
		}

		return false;
	}
}
