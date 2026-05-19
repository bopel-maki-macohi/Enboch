package enboch.util.controls;

import flixel.FlxG;
import flixel.input.keyboard.FlxKey;

class Control
{
	public var id(default, null):String = '';

	public var keys(default, null):Array<FlxKey>;

	public var keyList(get, never):Array<String>;

	function get_keyList():Array<String>
		return [for (key in keys) key.toString().toUpperCase()];

	public function new(id:String, keys:Array<FlxKey>)
	{
		this.id = id;
		this.keys = keys;

		if (!Controls.keys.contains(this))
			Controls.keys.push(this);
	}

	public function loadFromSave():Control
	{
		if (!Paycheck.game.keybinds.exists(this.id) || Paycheck.game.keybinds.get(this.id).length < 1)
		{
			Paycheck.game.keybinds.set(this.id, keyList);
			return this;
		}

		keys = [];

		for (key in Paycheck.game.keybinds.get(this.id))
			if (key != null)
				keys.push(FlxKey.fromString(key));

		trace('Loaded Key Save for ${this.id}');
		return this;
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
