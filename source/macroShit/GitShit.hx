package macroShit;

import sys.io.Process;

class GitShit
{
	public static macro function getGitBranch():haxe.macro.Expr.ExprOf<String>
	{
		var process = new Process('git rev-parse --abbrev-ref HEAD');

        if (process.exitCode() != 0)
        {
            haxe.macro.Context.error('Could not get Git Branch, is this actually a git repo?', haxe.macro.Context.currentPos());

            return macro $v{''};
        }

        var branchName = process.stdout.readLine();
        process.close();

        return macro $v{branchName};
	}
    
	public static macro function getGitCommit():haxe.macro.Expr.ExprOf<String>
	{
		var process = new Process('git rev-parse HEAD');

        if (process.exitCode() != 0)
        {
            haxe.macro.Context.error('Could not get Git Commit, is this actually a git repo?', haxe.macro.Context.currentPos());

            return macro $v{''};
        }

        var commitHash = process.stdout.readLine().substr(0, 7);
        process.close();

        return macro $v{commitHash};
	}
}
