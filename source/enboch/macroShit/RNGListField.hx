package enboch.macroShit;

import haxe.macro.Expr.Field;
import haxe.macro.Context;

using StringTools;

class RNGListField
{
	public static macro function generateList(names:Array<String>):Array<Field>
	{
		var fields:Array<Field> = Context.getBuildFields();
		var clsName = Context.getLocalClass();

		if (!clsName.toString().endsWith('PlayState'))
			return fields;

		var fieldNames = [for (f in fields) f.name];
		var addedNames:Array<String> = [];

		for (i => name in names)
		{
			if (name.trim().length < 1)
				continue;

			var newFieldName:String = 'rng_$name';

			if (fieldNames.contains(newFieldName))
				continue;

			fields.push({
				name: newFieldName,
				doc: 'RNG List Entry $i',
				access: [APublic],
				kind: FVar(macro :Int, macro $v{0}),
				pos: Context.currentPos(),
				meta: null
			});

			addedNames.push(name);
		}

		fields.push({
			name: 'rngList_length',
			doc: null,
			access: [APublic],
			kind: FVar(macro :Int, macro $v{addedNames.length}),
			pos: Context.currentPos(),
			meta: null
		});

		// Context.info('$addedNames', Context.currentPos());

		return fields;
	}
}
