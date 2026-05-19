package enboch.ui.objects;

import flixel.FlxSprite;

using StringTools;

class MainMenuButton extends FlxSprite
{
	public function new(button:String)
	{
		super();

		loadGraphic('ui/mainmenu/${button.toLowerCase().replace(' ', '-')}'.makePath(image));
		scale.set(.5, .5);
		updateHitbox();
	}
}
