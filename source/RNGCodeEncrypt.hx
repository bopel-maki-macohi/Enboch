class RNGCodeEncrypt
{
	static var numberEncoding:Map<Int, String> = [
		0 => 'z', // Zero
		1 => 'o', // One
		2 => 't', // Two
		3 => 'h', // tHree
		4 => 'f', // Four
		5 => 'i', // fIve
		6 => 's', // Six
		7 => 'v', // seVen
		8 => 'e', // Eight
		9 => 'n', // Nine
		10 => 't', // Ten
	];

	public static function encrypt(rngList:Array<Int>)
	{
		var rngString:Array<String> = [];

		for (rng in rngList)
			rngString.push(numberEncoding.get(rng) ?? '_');

		return rngString;
	}

	public static function logEncryptedRNG(rngList:Array<Int>)
	{
		trace(encrypt(rngList).join(''));
	}
}
