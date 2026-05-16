package utilShitsie;

class DebugString
{
	public static function generateBasedOnData(object:Dynamic, ?unwantedFields:Array<String>)
	{
		if (object == null)
			return '';

		var str:String = '';

		for (i => field in Reflect.fields(object))
		{
			if (unwantedFields?.contains(field))
				continue;

            if (i > 0)
                str += ' ';

			str += '$field=${Reflect.field(object, field)}';
		}

		return str;
	}
}
