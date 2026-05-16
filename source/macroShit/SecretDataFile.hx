package macroShit;

import haxe.io.Path;
import haxe.macro.Context;
import haxe.macro.Expr.ExprOf;

class SecretDataFile
{
	public static macro function build(file:String):ExprOf<String>
	{
		var fileContent:String = '';

		if (Path.extension(file) != 'secret')
			file = file + '.secret';

		#if sys
		if (!sys.FileSystem.exists(file))
		{
			Context.error('Missing Secret Data File Path: $file', Context.currentPos());
			return macro $v{fileContent};
		}

		fileContent = sys.io.File.getContent(file);
		#end

		return macro $v{fileContent};
	}
}
