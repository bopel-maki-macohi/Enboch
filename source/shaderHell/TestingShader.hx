package shaderHell;

import flixel.system.FlxAssets;

class TestingShader extends FlxShader
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
				gl_FragColor = vec4(0.0);
			}
		}
	')
	override public function new()
	{
		super();

		this.u_brightnessThreshold.value = [0.5];
	}
}
