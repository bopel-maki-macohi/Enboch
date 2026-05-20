package enboch.util.shader;

import flixel.addons.display.FlxRuntimeShader;

class ScreenGlitchShader extends FlxRuntimeShader
{
	override public function new(threshold:Float)
	{
		super('screenGlitch.frag'.makePath(shader).readFile());

		this.threshold = threshold;
	}

	public var threshold(get, set):Float;

	function get_threshold():Float
		return getFloat('glitchThreshold');

	function set_threshold(threshold:Float):Float
	{
		setFloat('glitchThreshold', threshold);
		return getFloat('glitchThreshold');
	}
}
