package com.framework.ui.basic.canvas
{

	/**
	 * 事件监听类,用来保存事件相关的内容
	 *
	 * @author derek
	 */
	public class CCanvasEventListener
	{
		/**
		 * 创建一个新的CanvasEventListener类的实例。
		 * @param	type 事件类型
		 * @param	listener 监听器
		 * @param	innerListener 内部监听器
		 */
		public function CCanvasEventListener(type:String, listener:Function, innerListener:Function)
		{
			_type = type;
			_listener = listener;
			_innerListener = innerListener;
		}

		/**
		 * 监听函数
		 */
		public function get listener():Function
		{
			return _listener;
		}

		/**
		 * 事件类型
		 */
		public function get type():String
		{
			return _type;
		}

		/**
		 * 原始监听函数
		 */
		public function get innerListener():Function
		{
			return _innerListener;
		}

		private var _type:String;
		private var _listener:Function;
		private var _innerListener:Function;
	}
}
