package game;

class StateManager
{
	public static function parseMovementCode(code:String, state:Int, jump:Bool):Int
	{
		trace('$code-$jump');

		switch (code)
		{
			case '600', '500', '400', '300': return (!jump) ? 1 : 2;

			case '311': return (!jump) ? 2 : 0; // Be glad you're given a chance

			case '511', '411': return (!jump) ? 2 : 1;
			case '611': return (!jump) ? 3 : 1;

			case '522': return (!jump) ? 3 : 2;
			case '622': return (!jump) ? 3 : 4;

			case '633': return (!jump) ? 4 : 2;

			// ur dead lmao
			case '422': return 3;
			case '533': return 4;
			case '644': return 5;

			default:
		}

		return state;
	}

	public static function parseLowerItemUseChance(states:Int, state:Int):Bool
	{
		switch (states)
		{
			case 6: return state == 4;
			case 5: return state == 3;
			case 4: return state == 2;
			case 3: return state == 1;
		}

		return false;
	}
}
