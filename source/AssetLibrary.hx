import flixel.util.typeLimit.OneOfTwo;

class AssetLibrary
{
	public static var folder:String = 'content';

	public static var pathTypes:Map<OneOfTwo<String, AssetLibraryPathType>, Array<String>> = [image => [null, 'png'],];

	public static function addPathType(type:String, folder:String, extension:String)
		pathTypes.set(type, [folder ?? null, extension ?? null]);

	public static function getPath(path:String, ?type:OneOfTwo<String, AssetLibraryPathType>):String
	{
		var typeFolder:String = pathTypes.get(type)[0] ?? '';

		if (typeFolder != '')
			typeFolder += '/';

		var typeExt:String = pathTypes.get(type)[1] ?? '';

		if (typeExt != '')
			typeExt = '.$typeExt';

		return '$folder/$typeFolder$path$typeExt';
	}
}

enum abstract AssetLibraryPathType(String) from String to String
{
	var image = 'image';
}
