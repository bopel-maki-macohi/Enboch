package utilShitsie;

import flixel.addons.ui.FlxUIState;
import flixel.FlxBasic;

class EnboState extends FlxUIState
{
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
