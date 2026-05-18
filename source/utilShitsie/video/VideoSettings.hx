package utilShitsie.video;

typedef VideoSettings =
{
	filePath:String,

	?shouldLoop:Bool,
	
	?onPlay:Void->Void,

	?web_back:Bool,
}
