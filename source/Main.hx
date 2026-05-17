package;

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

		trace('Git Branch: $gitBranch');
		trace('Git Commit: $gitCommit');

		addChild(new InitState());
	}
}
