package macroShit;

import haxe.macro.Context;
import haxe.macro.Expr.Field;

using StringTools;

class DefineFucker
{
	public static macro function make():Array<Field>
	{
		var fields = Context.getBuildFields();

		var defFields:Map<String, String> = [];

		var defines:Array<String> = [];

		#if sys
		defines = [
			for (s in sys.io.File.getContent('dev/macroShit/defines.txt').split('\n')) if (s.trim().length > 0) s.trim()
		];
		#end

		for (define in defines)
		{
			if (!wantedDefine(define))
				continue;

			for (field in fields)
				if (field.name == define)
					continue;

			defFields.set(define, Context.definedValue(define));
		}

		for (define => value in defFields)
		{
			fields.push({
				name: define,
				kind: FVar(macro :String, macro $v{value}),
				access: [APublic, AStatic, AFinal],
				pos: Context.currentPos(),
			});

			trace('$define=$value');
		}

		return fields;
	}

	public static function wantedDefine(define:String):Bool
	{
		var containsz:Array<String> = ['.', '-',];
		var startsWith:Array<String> = [
			'FLX_',
			'ANDROID_',
			'JAVA_',
			'lime_',
			'openfl_',
			'haxe',
			'hxcpp',
			'display',
			'utf',
		];
		var isit:Array<String> = [
			'true',
			'static',
			'no_compilation',
			'dce',
			'native',
			'source_header',
			'tools',

			// use an #if
			'sys',
			'windows',
			'desktop',
			'cpp',
		];

		for (thing in isit)
			if (define == thing)
				return false;

		for (thing in containsz)
			if (define.contains(thing))
				return false;

		for (thing in startsWith)
			if (define.startsWith(thing))
				return false;

		if (define.trim().length < 1)
			return false;

		return true;
	}
}
