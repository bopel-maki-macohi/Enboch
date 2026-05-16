package shaderHell;

import flixel.system.FlxAssets;

class TestingShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header

        void main() {}
	')
	override public function new()
	{
		super();
	}
}
