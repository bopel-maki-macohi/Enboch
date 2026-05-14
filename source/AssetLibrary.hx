class AssetLibrary
{
	public var folder:String = 'content';

	public function new(folder:String = 'content')
	{
		this.folder = folder;
	}

	public function getPath(path:String, ?append:String):String
		return '$folder/$path';

	public function getImagePath(path:String):String
		return getPath(path, '.png');
}
