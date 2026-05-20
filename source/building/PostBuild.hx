package source.building;

import haxe.macro.Context;

using StringTools;

class BuildMacro
{
	public static macro function getBuildDate()
	{
		var date:Date = Date.now();

		Context.info('Build Date: ${date.getTime()}', Context.currentPos());
		return macro $v{date};
	}
}

class PostBuild
{
	public static var buildTime:Date = BuildMacro.getBuildDate();

	static function main()
	{
		var time:String = '';
		var date = buildTime;

		var aP:String = (date.getHours() >= 12) ? 'pm' : 'am';

		time = '${date.getMonth() + 1}/${date.getDate()}/${date.getFullYear()} @'
			+ ' ${date.getHours() % 12}:'
			+ '${date.getMinutes()}'.lpad('0', 2)
			+ ':'
			+ '${date.getSeconds()}'.lpad('0', 2)
			+ ' $aP';
		trace('Build Time: ${time}');
	}
}
