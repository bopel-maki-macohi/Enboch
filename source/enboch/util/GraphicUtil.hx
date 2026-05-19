package enboch.util;

import flixel.graphics.FlxGraphic;

class GraphicUtil
{
	public static function persistGraphics(graphicsList:Array<FlxGraphic>)
	{
		for (graphic in graphicsList)
			if (graphic != null)
				graphic.persist = true;
	}
}
