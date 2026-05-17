package utilShitsie;

import haxe.io.Path;
import lime.utils.Assets;
import flixel.util.typeLimit.OneOfTwo;

using StringTools;

class AssetLibrary
{
	public static var folder:String = 'content';

	public static var pathTypes:Map<OneOfTwo<String, AssetLibraryPathType>, Array<String>> = [
		//
		image => [null, 'png'],
		// Define.web doesnt work here for some reason?
		audio => ['audio', #if web 'mp3' #else 'ogg' #end],
	];

	public static function addPathType(type:String, folder:String, extension:String)
		pathTypes.set(type, [folder ?? null, extension ?? null]);

	public static function makePath(path:String, ?type:OneOfTwo<String, AssetLibraryPathType>):String
	{
		var typeFolder:String = pathTypes.get(type)[0] ?? '';

		if (typeFolder != '')
			typeFolder += '/';

		var typeExt:String = pathTypes.get(type)[1] ?? '';

		if (typeExt != '')
			typeExt = '.$typeExt';

		return '$folder/$typeFolder$path$typeExt';
	}

	public static function pathExists(path:String):Bool
	{
		#if sys
		return sys.FileSystem.exists(path);
		#end

		var limeFuck = Assets.list().filter(p -> return p.startsWith('$path'));
		return limeFuck.length > 0;
	}

	public static function readDirectory(directory:String):Array<String>
	{
		if (!pathExists(directory))
			return [];

		#if sys
		return [
			for (file in sys.FileSystem.readDirectory(Path.removeTrailingSlashes(directory)))
				'${Path.removeTrailingSlashes(directory)}/$file'
		];
		#end

		return Assets.list().filter(p -> return p.startsWith('${Path.removeTrailingSlashes(directory)}/'));
	}
}

enum abstract AssetLibraryPathType(String) from String to String
{
	var image = 'image';
	var audio = 'audio';
}
