import enboch.util.macro.Build;
import enboch.util.macro.GitShit;
import lime.app.Application;
import openfl.display.Sprite;

class Main extends Sprite
{
	public static var gitBranch:String = GitShit.getGitBranch();
	public static var gitCommit:String = GitShit.getGitCommit();

	public static var buildTime:String = Build.getBuildTime();

	public function new()
	{
		super();

		Paycheck.load();

		trace('Git Branch: $gitBranch');
		trace('Git Commit: $gitCommit');
		trace('Build Time: $buildTime');

		if (debug || indev)
			Application.current.window.title += ' ($buildTime)';

		addChild(new InitState());
	}
}
