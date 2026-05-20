package enboch.util.shader;

import flixel.addons.display.FlxRuntimeShader;

/**
 * Base: https://github.com/47rooks/parasol/blob/main/parasol/shaders/GrayscaleShader.hx
 * 
 * Tried it on my own and failed :(
 */
class GrayscaleShader extends FlxRuntimeShader
{
	override public function new()
	{
		super('grayscale.frag'.makePath(shader).readFile());
	}
}
