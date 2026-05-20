package enboch.util.shader;

import flixel.addons.display.FlxRuntimeShader;

/**
 * Base: https://github.com/47rooks/parasol/blob/main/parasol/shaders/ThresholdShader.hx
 */
class ThresholdShader extends FlxRuntimeShader
{
	override public function new(threshold:Float = 1)
	{
		super('threshold.frag'.makePath(shader).readFile());

		this.brightnessThreshold = threshold;
	}

	public var brightnessThreshold(get, set):Float;

	function get_brightnessThreshold():Float
		return getFloat('u_brightnessThreshold');

	function set_brightnessThreshold(brightnessThreshold:Float):Float
	{
		setFloat('u_brightnessThreshold', brightnessThreshold);
		return getFloat('u_brightnessThreshold');
	}
}
