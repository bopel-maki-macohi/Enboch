package utilShitsie.video;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

class DesktopVideo extends FlxTypedSpriteGroup<FlxSprite>
{
	override function set_alpha(Value:Float):Float
	{
		return super.set_alpha(Value);
	}

    public var looping(default, default):Bool;

	public function new(filePath:String)
	{
		super();
	}
}
