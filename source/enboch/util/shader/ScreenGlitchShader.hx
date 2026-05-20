package enboch.util.shader;

import flixel.FlxG;
import flixel.addons.display.FlxRuntimeShader;

class ScreenGlitchShader extends FlxRuntimeShader
{
	override public function new(threshold:Float)
	{
		super('screenGlitch.frag'.makePath(shader).readFile());

		this.threshold = threshold;
	}

	public function update()
	{
		thresholdOffset = FlxG.random.float(thresholdOffsetMin / 100, thresholdOffsetMax / 100);
	}

	public var threshold(get, set):Float;

	function get_threshold():Float
		return getFloat('glitchThreshold');

	function set_threshold(threshold:Float):Float
	{
		setFloat('glitchThreshold', threshold);
		return getFloat('glitchThreshold');
	}

	public var thresholdOffset(get, set):Float;

	function get_thresholdOffset():Float
		return getFloat('thresholdOffset');

	function set_thresholdOffset(thresholdOffset:Float):Float
	{
		setFloat('thresholdOffset', thresholdOffset);
		return getFloat('thresholdOffset');
	}

	public var thresholdOffsetMin:Float = 0.0;
	public var thresholdOffsetMax:Float = 5.0;
}
