package shaderHell;

import flixel.system.FlxAssets;

class TestingShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header

        void main()
		{
	        vec2 st = openfl_TextureCoordv.xy;  // Note, already normalized
	
			vec4 color = flixel_texture2D(bitmap, st);	
			gl_FragColor = color;
		}
	')
	override public function new()
	{
		super();
	}
}
