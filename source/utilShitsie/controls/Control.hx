package utilShitsie.controls;

import flixel.FlxG;
import flixel.input.keyboard.FlxKey;

class Control
{
	public var keys:Array<FlxKey>;

	public function new(keys:Array<FlxKey>)
	{
		this.keys = keys;
	}

	public var pressed(get, never):Bool;

	function get_pressed():Bool
		return FlxG.keys.anyPressed(keys);

	public var justPressed(get, never):Bool;

	function get_justPressed():Bool
		return FlxG.keys.anyJustPressed(keys);

	public var justReleased(get, never):Bool;

	function get_justReleased():Bool
		return FlxG.keys.anyJustReleased(keys);
}
