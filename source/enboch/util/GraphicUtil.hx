package enboch.util;

import flixel.graphics.FlxGraphic;

class GraphicUtil
{
	public static function destroyGraphics(graphicsList:Array<FlxGraphic>)
	{
		for (graphic in graphicsList)
		{
			graphic?.destroy();
			graphicsList.remove(graphic);
		}
	}

	public static function persistGraphics(graphicsList:Array<FlxGraphic>)
	{
		for (graphic in graphicsList)
			if (graphic != null)
				graphic.persist = true;
	}
}
