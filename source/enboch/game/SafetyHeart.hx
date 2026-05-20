package enboch.game;

import enboch.util.shader.ScreenGlitchShader;
import flixel.FlxSprite;

class SafetyHeart extends FlxSprite
{
	public var percent(default, set):Float;

	function set_percent(percent:Float):Float
	{
		if (percent > SAFETY_HEART_FULL_THRESHOLD)
			loadGraphic('ui/game/heart'.makePath(image));
		else if (percent > SAFETY_HEART_HALF_THRESHOLD)
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
