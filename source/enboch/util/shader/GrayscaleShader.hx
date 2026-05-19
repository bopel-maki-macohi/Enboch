package enboch.util.shader;

import flixel.system.FlxAssets;

class GrayscaleShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header

		uniform float u_brightnessThreshold;

		void main()
		{
			vec2 st = openfl_TextureCoordv.xy;  // Note, already normalized

			vec4 color = flixel_texture2D(bitmap, st);
			if (dot(color.rgb, vec3(0.2126, 0.7152, 0.0722)) > u_brightnessThreshold) {
				gl_FragColor = color;
			} else {
				gl_FragColor = vec4(color.rgb, vec3(0.2126, 0.7152, 0.0722));
			}
		}
	')
	override public function new(threshold:Float = 1)
	{
		super();

		this.brightnessThreshold = threshold;
	}

	public var brightnessThreshold(get, set):Float;

	function get_brightnessThreshold():Float
		return this.u_brightnessThreshold.value[0];

	function set_brightnessThreshold(brightnessThreshold:Float):Float
	{
		this.u_brightnessThreshold.value = [brightnessThreshold];

		return this.u_brightnessThreshold.value[0];
	}
}
