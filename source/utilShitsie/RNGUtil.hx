package utilShitsie;

import flixel.FlxG;

class RNGUtil
{
	public static function generateRNGList(numbers:Int, minNum:Int = 0, maxNum:Int = 10):Array<Int>
	{
		if (numbers < 1)
			return [];

		var rngList:Array<Int> = [];

		while (rngList.length < numbers)
			rngList.push(FlxG.random.int(minNum, maxNum));

        return rngList;
	}
}
