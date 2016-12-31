package com.brickmice.data.tcp.events
{
	import flash.events.*;
	public class NetworkEvent extends Event 
	{
		public static const CONNECTED:String = "connected";
		public static const CONNECTE_FAIL:String = "conn_fail";
		public static const DISCONNECT:String = "disconnect";
		public static const USER:String = "user";
		public static const CHAT:String = "chat";
		
		public var args:Object;
		public function NetworkEvent(Cmd : String, Args: Object)
		{
			super(Cmd);
			args = Args;
		}

	}
}
