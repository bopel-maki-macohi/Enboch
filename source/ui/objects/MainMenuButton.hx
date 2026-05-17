package ui.objects;

import flixel.FlxSprite;

using StringTools;

class MainMenuButton extends FlxSprite
{
	public function new(button:String)
	{
		super();

		loadGraphic('ui/mainmenu/${button.toLowerCase().replace(' ', '-')}'.makePath(image));
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		screenCenter(X);
	}
}
