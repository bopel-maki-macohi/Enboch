package;

import macroShit.GitShit;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();

		AssetLibrary.addPathType('robotImage', 'robot', 'png');

		Paycheck.load();

		trace('Git Branch: ${GitShit.getGitBranch()}');
		trace('Git Commit: ${GitShit.getGitCommit()}');

		addChild(new FlxGame(0, 0, PlayState));
	}
}
