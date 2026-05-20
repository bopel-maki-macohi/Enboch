package enboch.util.controls;

class Controls
{
	public static var keys:Array<Control> = [];

	public static var accept:Control = new Control('accept', [ENTER]);
	public static var leave:Control = new Control('leave', [ESCAPE, BACKSPACE]);

	public static var screenshot:Control = new Control('screenshot', [F3]);

	public static var ui_left:Control = new Control('ui_left', [A, LEFT]);
	public static var ui_down:Control = new Control('ui_down', [S, DOWN]);
	public static var ui_up:Control = new Control('ui_up', [W, UP]);
	public static var ui_right:Control = new Control('ui_right', [D, RIGHT]);

	public static var reload:Control = new Control('reload', [F5]);
}
