package com.brickmice.data.tcp.events
{
	import flash.events.Event;
	
	public class ChatErrorEvent extends Event
	{
		public static const ERROR:String = "chatError";
		public var errorType:String;
		public var error:String;
		public function ChatErrorEvent(type:String, errorType:String, error:String)
		{
			this.errorType = errorType;
			this.error = error;
			super(type, false, false);
		}
	}
}