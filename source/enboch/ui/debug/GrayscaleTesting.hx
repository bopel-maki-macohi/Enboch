package enboch.ui.debug;

import enboch.util.EnboState;
import enboch.util.shader.GrayscaleShader;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;

class GrayscaleTesting extends EnboState
{
	var sprite:FlxSprite = new FlxSprite(0, 0, 'characters/drowned/char-phase0'.makePath(image));

	var shader:GrayscaleShader = new GrayscaleShader(0);

	override function create()
	{
		super.create();

		sprite.screenCenter();
		add(sprite);
		sprite.shader = shader;

		FlxTween.tween(shader, {brightnessThreshold: 1}, 1, {type: PINGPONG});
	}
}
