package enboch.game;

import enboch.util.shader.ScreenGlitchShader;
import flixel.FlxSprite;

class SafetyHeart extends FlxSprite
{
	public var glitchShader:ScreenGlitchShader;

	override public function new()
	{
		super(0, 0, 'ui/game/heart'.makePath(image));

		scale.set(6, 6);
        updateHitbox();

		glitchShader = new ScreenGlitchShader(1);
		this.shader = glitchShader;
	}
}
