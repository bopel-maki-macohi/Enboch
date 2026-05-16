package utilShitsie.api;

import flixel.util.FlxTimer;
import flixel.FlxG;
import macroShit.SecretDataFile;
import flixel.addons.api.FlxGameJolt as API;

class GamejoltAPI
{
	static var privateKey:String = SecretDataFile.build('dev/api/gamejolt-privateKey');

	public static var SESSION_PINGTIME_SECONDS:Int = 30;

	public static function callback(?params:Dynamic, ?id:String)
	{
		trace('GAMEJOLT API THINGY : $params ($id)');
	}

	public static function init()
	{
		API.verbose = #if debug true #else false #end;
		API.init(1070390, privateKey);

		if (Paycheck.game.gd_username != null && Paycheck.game.gd_usertoken != null)
			login(Paycheck.game.gd_username, Paycheck.game.gd_usertoken);
		else if (username != null && usertoken != null)
			login(username, usertoken);

		FlxG.stage.application.onExit.add(l -> closeSession());
	}

	public static function login(username:String, usertoken:String, ?onAuthCallback:Bool->Void)
	{
		API.authUser(username, usertoken, (authed:Bool) ->
		{
			startSession();
			callback(authed, 'logged in');

			if (onAuthCallback != null)
				onAuthCallback(authed);
		});
	}

	public static function logout(callbackThingy:Void->Void)
	{
		closeSession(callbackThingy);

		@:privateAccess
		API._initialized = false;
	}

	public static function startSession()
	{
		API.openSession(() ->
		{
			callback('open', 'session');

			new FlxTimer().start(SESSION_PINGTIME_SECONDS, function(tmr:FlxTimer)
			{
				pingSession();
			}, 0);
		});
	}

	public static function pingSession()
	{
		API.pingSession(true, () -> callback('pinged', 'session'));
	}

	public static function closeSession(?callbackThingy:Void->Void)
	{
		API.closeSession(() ->
		{
			callback('closed', 'session');

			if (callbackThingy != null)
				callbackThingy();
		});
	}

	public static var authenticated(get, never):Bool;

	static function get_authenticated():Bool
	{
		@:privateAccess {
			if (!API._initialized)
				return false;

			return API.authenticated;
		}
	}

	public static var username(get, never):String;

	static function get_username():String
	{
		return (!authenticated || API.usertoken.toLowerCase() == 'no user') ? null : API.username;
	}

	public static var usertoken(get, never):String;

	static function get_usertoken():String
	{
		return (!authenticated || API.usertoken.toLowerCase() == 'no token') ? null : API.usertoken;
	}
}
