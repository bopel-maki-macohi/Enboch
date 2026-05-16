package utilShitsie;

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
}
