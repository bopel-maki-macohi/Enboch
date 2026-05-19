package enboch.data;

typedef VideoSettings =
{
	filePath:String,

	?shouldLoop:Bool,
	?actuallyLoad:Bool,
	?killOnEnd:Bool,
	?instaStart:Bool,

	?web_back:Bool,
}
