package com.brickmice.data.tcp.events
{
	import flash.events.Event;
	
	public class LoginEvent extends Event
	{
		public static const LOGIN_OUT:String = "loginOut";
		public static const LOGIN_IN:String = "loginIn";
		public static const LOGIN_FAIL:String = "loginFail";
		public static const MULTI_LOGIN:String = "multiLogin";
		
		public function LoginEvent(type:String)
		{
			super(type, false, false);
		}
	}
}