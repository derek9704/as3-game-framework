package com.brickmice.data.tcp.events
{
	import flash.events.Event;
	
	public class ReceiveMsgEvent extends Event
	{
		public static const WHISPER_MSG:String	= "whisper";
		public static const WORLD_MSG:String	= "world";
		public static const UNION_MSG:String	= "union";
		public static const GUILD_MSG:String	= "guild";
		public static const SYSTEM_MSG:String	= "system";
		
		public var receiver:String;
		public var sender:String;
		public var msg:String;
		
		public function ReceiveMsgEvent(type:String, sender:String, receiver:String, msg:String)
		{
			this.receiver = receiver;
			this.sender = sender;
			this.msg = msg;
			super(type, false, false);
		}
	}
}