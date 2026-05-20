package enboch.game;

import enboch.util.shader.ScreenGlitchShader;
import flixel.FlxSprite;

class SafetyHeart extends FlxSprite
{
	public var percent(default, set):Float;

	function set_percent(percent:Float):Float
	{
		if (percent > 0.6)
			loadGraphic('ui/game/heart'.makePath(image));
		else if (percent > 0.25)
			loadGraphic('ui/game/heart-half'.makePath(image));
		else
			loadGraphic('ui/game/heart-empty'.makePath(image));

		scale.y = scale.x = 8;
		updateHitbox();

		return percent;
	}

	override public function new()
	{
		super(0, 0);

		percent = 1;
	}
}
