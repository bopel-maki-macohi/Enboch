package enboch.data;

typedef VideoSettings =
{
	filePath:String,

	?shouldLoop:Bool,
	?actuallyLoad:Bool,
	?killOnEnd:Bool,

	?web_back:Bool,
}
