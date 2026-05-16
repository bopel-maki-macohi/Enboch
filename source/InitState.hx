import flixel.FlxG;
import utilShitsie.ScreenshotPlugin;
import flixel.util.typeLimit.NextState.InitialState;
import flixel.FlxGame;

class InitState extends FlxGame
{
	override public function new(startingState:InitialState)
	{
		super(0, 0, startingState);

		FlxG.mouse.visible = false;

        ScreenshotPlugin.init();
	}
}
