package com.framework.core
{

	/**
	 * @author derek
	 */
	public class Message
	{
		/**
		 * 消息类型
		 */
		public var type:String;
		/**
		 * 消息数据
		 */
		public var data:*;
		/**
		 * 消息的动作类别
		 */
		public var action:String;
		/**
		 * 消息的回调函数
		 */
		public var callback:Function;
		/**
		 * 消息发送者
		 */
		public var sender:*;

		/**
		 * 消息构造函数
		 *
		 * @param type 消息类型
		 * @param data 消息数据
		 * @param action 动作类型
		 * @param callback 回调函数
		 * @param sender 发送消息的对象
		 */
		public function Message(type:String, data:* = null, action:String = null, callback:Function = null, sender:* = null)
		{
			this.type = type;
			this.data = data;
			this.action = action;
			this.callback = callback;
			this.sender = sender;
		}
	}
}
