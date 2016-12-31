package com.framework.ui.basic.sprite
{
	import com.framework.core.Message;
	import com.framework.core.ViewManager;
	import com.framework.ui.basic.canvas.CCanvas;

	import flash.events.Event;

	/**
	 *
	 * 精灵类.各种物件的基类.可以接收发送消息.
	 *
	 * @author derek
	 */
	public class CSprite extends CCanvas
	{
		/**
		 * 构造函数
		 *
		 * @param name 名字
		 * @param w 宽度
		 * @param h 高度
		 * @param mouseenable 响应鼠标
		 */
		public function CSprite(name:String = '', w:Object = null, h:Object = null, mouseenable:Boolean = true)
		{
			super(w, h, mouseenable);
			cName = name;

			if (name != '' && name != null)
				ViewManager.registerView(this);
		}

		/**
		 * 移除自己的消息监听
		 */
		public function removeView():void
		{
			ViewManager.removeView(cName);
		}

		/**
		 * 移除自己
		 */
		public override function removeSelf():void
		{
			ViewManager.removeView(cName);

			super.removeSelf();
		}

		/**
		 * 监听信息
		 */
		public function listenerMessage():Array
		{
			return [];
		}

		/**
		 * 捕获信息
		 */
		public function handleMessage(message:Message):void
		{
		}

		/**
		 * 发送消息
		 *
		 * @param type 消息类型
		 * @param data 消息数据
		 * @param action 消息动作类型
		 * @param callback 回调函数
		 */
		public function sendMessage(type:String, data:* = null, action:String = null, callback:Function = null):void
		{
			ViewManager.sendMessage(type, data, action, callback, this);
		}

		public function get dragInfo():CSpriteDragInfo
		{
			if (_dragInfo == null)
				_dragInfo = new CSpriteDragInfo(this);

			return _dragInfo;
		}

		private var _dragInfo:CSpriteDragInfo;

	}
}
