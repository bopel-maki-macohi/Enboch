package ui.objects;

import flixel.FlxSprite;

class MainMenuButton extends FlxSprite
{
	public function new(button:String)
	{
		super();

		loadGraphic('ui/mainmenu/$button');
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		screenCenter(X);
	}
}
