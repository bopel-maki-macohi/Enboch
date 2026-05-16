package utilShitsie.api;

import utilShitsie.trophies.Trophies;
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
		var msg = 'GAMEJOLT API THINGY : $params ($id)';

		// #if sys
		// Sys.println(msg);
		// #else
		trace(msg);
		// #end
	}

	public static function init(?onAuthCallback:Bool->Void)
	{
		API.verbose = #if debug true #else false #end;
		API.init(1070390, privateKey);

		FlxG.stage.application.onExit.add(l -> closeSession());

		if (Paycheck.game.gd_username != null && Paycheck.game.gd_usertoken != null)
			login(Paycheck.game.gd_username, Paycheck.game.gd_usertoken, onAuthCallback);
		else if (username != null && usertoken != null)
			login(username, usertoken, onAuthCallback);
		else
		{
			if (onAuthCallback != null)
				onAuthCallback(false);
		}
	}

	public static function unlockTrophy(ID:Int, ?callbackFucker:Bool->Void)
	{
		if (!authenticated)
			return;

		API.addTrophy(ID, (d:Map<String, String>) ->
		{
			var success:Bool = d.get('success') == 'true';

			callback('Unlocked: $success', 'trophy');

			if (callbackFucker != null)
				callbackFucker(success);

			if (success)
				FlxG.sound.play('gamejolt_medal'.makePath(audio));
		});
	}

	public static function login(username:String, usertoken:String, ?onAuthCallback:Bool->Void)
	{
		API.authUser(username, usertoken, (authed:Bool) ->
		{
			getTrophyData();

			startSession();
			callback(authed, 'logged in');

			if (onAuthCallback != null)
				onAuthCallback(authed);
		});
	}

	public static function getTrophyData()
	{
		API.fetchTrophy(0, function(d)
		{
			trace(d);
		});
	}

	public static function logout(callbackThingy:Void->Void)
	{
		closeSession(() ->
		{
			@:privateAccess {
				API._userName = null;
				API._userToken = null;
			}

			if (callbackThingy != null)
				callbackThingy();
		});
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
		if (API.username.toLowerCase() == 'no user')
			return false;

		if (API.usertoken.toLowerCase() == 'no token')
			return false;

		@:privateAccess
		return API.authenticated;
	}

	public static var username(get, never):String;

	static function get_username():String
	{
		return (!authenticated) ? null : API.username;
	}

	public static var usertoken(get, never):String;

	static function get_usertoken():String
	{
		return (!authenticated) ? null : API.usertoken;
	}
}
