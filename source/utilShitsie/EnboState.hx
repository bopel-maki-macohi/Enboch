package utilShitsie;

import flixel.FlxBasic;
import flixel.FlxState;

class EnboState extends FlxState
{
	public function addMultiple(basics:Array<FlxBasic>)
	{
		for (basic in basics)
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
