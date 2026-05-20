package enboch.util;

#if !macro
import haxe.io.Path;
import lime.utils.Assets;
#end
import flixel.util.typeLimit.OneOfTwo;

using StringTools;

class AssetLibrary
{
	public static var folder:String = 'content';

	public static var pathTypes:Map<OneOfTwo<String, AssetLibraryPathType>, Array<String>> = [
		//
		image => [null, 'png'],
		// web doesnt work here for some reason?
		audio => ['audio', #if web 'mp3' #else 'ogg' #end],
		video => ['video', 'mp4'],
		model => ['models', 'obj'],
		text => [null, 'txt'],
		shader => ['shaders', null],
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

	#if !macro
	public static function pathExists(path:String):Bool
	{
		#if sys
		return FileSystem.exists(path);
		#end

		var limeFuck = Assets.list().filter(p -> return p.startsWith('$path'));
		return limeFuck.length > 0;
	}

	public static function readDirectoryRecursive(directory:String):Array<String>
	{
		if (!pathExists(directory))
			return [];

		#if sys
		var f = [];

		for (file in readDirectory(directory))
		{
			if (FileSystem.isDirectory(file))
				for (sf in readDirectoryRecursive(file))
					f.push(sf);
			else
				f.push(file);
		}

		return f;
		#end

		return readDirectory(directory);
	}

	public static function readDirectory(directory:String):Array<String>
	{
		if (!pathExists(directory))
			return [];

		#if sys
		return [
			for (file in FileSystem.readDirectory(Path.removeTrailingSlashes(directory)))
				'${Path.removeTrailingSlashes(directory)}/$file'
		];
		#end

		return Assets.list().filter(p -> return p.startsWith('${Path.removeTrailingSlashes(directory)}/'));
	}

	public static function readFile(file:String):String
	{
		if (!pathExists(file))
			return '';

		#if sys
		return File.getContent(file);
		#end

		return Assets.getText(file);
	}
	#end

	public static function splitTextBy(text:String, splitter:String = '\n'):Array<String>
	{
		return [for (thing in text.split(splitter)) if (thing.trim().length > 0) thing.trim()];
	}
}

enum abstract AssetLibraryPathType(String) from String to String
{
	var image = 'image';
	var audio = 'audio';
	var video = 'video';
	var model = 'model';
	var text = 'text';
	var shader = 'shader';
}
