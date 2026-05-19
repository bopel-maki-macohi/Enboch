package enboch.utilShitsie;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.addons.transition.FlxTransitionSprite;
import flixel.addons.transition.TransitionData;
import flixel.addons.ui.FlxUIState;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class EnboState extends FlxUIState
{
	public static var DEFAULT_TRANSITION(get, never):TransitionData;

	static function get_DEFAULT_TRANSITION():TransitionData
	{
		var transGraphic = FlxGraphic.fromClass(cast GraphicTransTileDiamond);
		transGraphic.persist = true;
		transGraphic.destroyOnNoUse = false;

		return new TransitionData(TILES, FlxColor.BLACK, .5, FlxPoint.get(0, -1), {
			asset: transGraphic,
			width: 32,
			height: 32
		},);
	}

	public function addMultiple(basics:Array<FlxBasic>)
	{
		for (basic in basics)
			if (basic != null)
				add(basic);
	}

	override function create()
	{
		super.create();

		ScreenshotPlugin.preScreenshot.add(preScreenshot);
		ScreenshotPlugin.postScreenshot.add(postScreenshot);
	}

	override function destroy()
	{
		ScreenshotPlugin.preScreenshot.remove(preScreenshot);
		ScreenshotPlugin.postScreenshot.remove(postScreenshot);

		super.destroy();
	}

	function preScreenshot() {}

	function postScreenshot() {}
}
