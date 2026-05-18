package enboch.game;

import enboch.utilShitsie.GraphicUtil;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.util.FlxSignal;

enum GamePhaseSpriteType
{
	char;
	item;
}

class GamePhaseSprite extends FlxSprite
{
	public static var CHAR_ASSET_LIST:Map<String, Array<FlxGraphic>> = [];
	public static var ITEM_ASSET_LIST:Map<String, Array<FlxGraphic>> = [];

	public static function loadCharacterAssets(character:String, phases:Int = 4)
	{
		if (!CHAR_ASSET_LIST.exists(character))
		{
			CHAR_ASSET_LIST.set(character, [
				for (i in 0...phases)
					FlxG.bitmap.add('characters/$character/char-phase$i'.makePath(image))
			]);
			GraphicUtil.persistGraphics(CHAR_ASSET_LIST.get(character));
		}

		if (!ITEM_ASSET_LIST.exists(character))
		{
			ITEM_ASSET_LIST.set(character, [
				for (i in 0...phases)
					FlxG.bitmap.add('characters/$character/item-phase$i'.makePath(image))
			]);
			GraphicUtil.persistGraphics(ITEM_ASSET_LIST.get(character));
		}
	}

	var character:String;
	var type:GamePhaseSpriteType;

	public var state(default, set):Int = -1;

	function set_state(s:Int):Int
	{
		if (s < 0 || this.state == s)
			return this.state;

		switch (type)
		{
			case char: if (CHAR_ASSET_LIST.exists(character) && CHAR_ASSET_LIST.get(character)[s] != null)
					loadGraphic(CHAR_ASSET_LIST.get(character)[s]);
			case item: if (ITEM_ASSET_LIST.exists(character) && ITEM_ASSET_LIST.get(character)[s] != null)
					loadGraphic(ITEM_ASSET_LIST.get(character)[s]);
		}

		this.state = s;

		onStateChange.dispatch();
		return s;
	}

	public var onStateChange:FlxSignal = new FlxSignal();

	override public function new(character:String, type:GamePhaseSpriteType)
	{
		super();

		this.character = character;
		this.type = type;

		this.state = 0;
	}
}
