package;

import flixel.util.typeLimit.NextState.InitialState;
import macroShit.GitShit;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public static var gitBranch:String = GitShit.getGitBranch();
	public static var gitCommit:String = GitShit.getGitCommit();

	public function new()
	{
		super();

		Paycheck.load();

		trace('Git Branch: $gitBranch');
		trace('Git Commit: $gitCommit');

		addChild(new FlxGame(0, 0, getInitalState()));
	}

	function getInitalState():InitialState
	{
		#if DIE
		return DeadState;
		#end

		return PlayState;
	}
}
