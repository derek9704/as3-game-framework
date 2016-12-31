package com.framework.core.interfaces
{

	/**
	 * 消息类.
	 * @author derek
	 */
	public interface IMessage
	{
		function sendMessage(type:String, data:* = null, action:String = null, callback:Function = null, sender:* = null):void;
	}
}
