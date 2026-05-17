package macroShit;

class GitShit
{
	public static macro function getGitBranch():haxe.macro.Expr.ExprOf<String>
	{
		#if !display
		var process = new sys.io.Process('git rev-parse --abbrev-ref HEAD');

		if (process.exitCode() != 0)
		{
			haxe.macro.Context.error('Could not get Git Branch, is this actually a git repo?', haxe.macro.Context.currentPos());

			return macro $v{''};
		}

		var branchName = process.stdout.readLine();
		process.close();
		haxe.macro.Context.info('Git Branch: $branchName', haxe.macro.Context.currentPos());
		#else
		branchName = '';
		#end

		return macro $v{branchName};
	}

	public static macro function getGitCommit():haxe.macro.Expr.ExprOf<String>
	{
		#if !display
		var process = new sys.io.Process('git rev-parse HEAD');

		if (process.exitCode() != 0)
		{
			haxe.macro.Context.error('Could not get Git Commit, is this actually a git repo?', haxe.macro.Context.currentPos());

			return macro $v{''};
		}

		var commitHash = process.stdout.readLine().substr(0, 7);
		process.close();

		haxe.macro.Context.info('Git Commit: $commitHash', haxe.macro.Context.currentPos());
		#else
		var commitHash = '';
		#end

		return macro $v{commitHash};
	}
}
