package enboch.util.macro;

import haxe.macro.Context;

using StringTools;

class Build
{
	public static macro function getBuildTime()
	{
		var time:String = '';
		var date:Date = Date.now();

		var aP:String = (date.getHours() >= 12) ? 'pm' : 'am';

		time = '${date.getHours() % 12}:${date.getMinutes()}:'
			+ '${date.getSeconds()}'.lpad('0', 2)
			+ ' $aP (${date.getMonth() + 1}/${date.getDate() + 1}/${date.getFullYear()})';
		Context.info('Build Time: ${time}', Context.currentPos());

		return macro $v{time};
	}
}
