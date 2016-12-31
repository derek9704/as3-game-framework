package com.framework.core
{
	import com.framework.ui.basic.sprite.CSprite;

	import flash.utils.Dictionary;

	/**
	 * @author derek
	 */
	public class ViewManager
	{
		// 已经注册的view实例的集合 - 按照名字分类
		private static var _viewMap:Dictionary = new Dictionary();
		// 已经注册的view实例的集合 - 按照监听的消息不同而分类
		private static var _viewMessages:Dictionary = new Dictionary();

		/**
		 * 注册view
		 *
		 * @param view view实例
		 */
		public static function registerView(view:CSprite):void
		{
			// 未指定名字则返回
			if (view.cName == null || view.cName == '')
			{
				return;
			}

			// 如果已经存在了.则直接移除掉view
			if (_viewMap[view.cName] != null)
			{
				removeView(view.cName);
			}

			// 添加实例
			_viewMap[view.cName] = view;

			// 注册消息
			registerViewMessage(view);
		}

		/**
		 * 获取view实例
		 *
		 * @param viewName view名字
		 * @return view实例
		 */
		public static function retrieveView(viewName:String):CSprite
		{
			var view:CSprite = _viewMap[viewName];
			if (view == null)
				return null;

			// 如果已经没有父对象并且不再舞台上.则应该回收掉
			if (view.parent == null || view.stage == null)
			{
				removeView(viewName);

				return null;
			}

			return view;
		}

		/**
		 * 删除view
		 *
		 * @param viewName view名字
		 * @return view实例
		 */
		public static function removeView(viewName:String):CSprite
		{
			if (viewName == null || viewName == '')
				return null;

			if (_viewMap[viewName] == null)
				return null;

			var result:CSprite = _viewMap[viewName];
			removeViewMessage(result);

			delete _viewMap[viewName];

			return result;
		}

		/**
		 * 是否有view实例
		 * @param viewName view名字
		 * @return true or false
		 */
		public static function hasView(viewName:String):Boolean
		{
			var instance:CSprite = _viewMap[viewName];

			// 该CSprite为空 || 已经被移除 || 不在舞台上
			if (instance == null)
				return false;

			// 如果已经没有父对象并且不再舞台上.则应该回收掉
			if (instance.parent == null || instance.stage == null)
			{
				removeView(instance.cName);

				return false;
			}

			return true;
		}

		private static function addMessage(message:String, obj:CSprite):void
		{
			if (_viewMessages[message] == null)
			{
				_viewMessages[message] = new Array();
			}
			_viewMessages[message].push(obj);
		}

		private static function registerViewMessage(view:CSprite):void
		{
			var messageTypes:Array = view.listenerMessage();

			for each (var mType:String in messageTypes)
			{
				addMessage(mType, view);
			}
		}

		private static function removeViewMessage(view:CSprite):void
		{
			// 遍历消息队列
			for (var key:String in _viewMessages)
			{
				var views:Array = _viewMessages[key];

				// 遍历消息响应队列
				for (var i:int = 0; i < views.length; i++)
				{
					// 找到了要删除的内容.删除之
					if (views[i] == view)
					{
						views.splice(i, 1);
						break;
					}
				}

				// 该消息已经没有实例在监听则删除掉
				if (views.length == 0)
				{
					delete _viewMessages[key];
				}
			}
		}

		/**
		 *
		 * 发送消息
		 *
		 * @param message 消息体
		 */
		public static function sendMessage(type:String, data:* = null, action:String = null, callback:Function = null, sender:* = null):void
		{
			var message:Message = new Message(type, data, action, callback, sender);

			// 如果消息是未注册的消息.则返回
			if (_viewMessages[message.type] == null)
				return;

			// 遍历所有监听该消息的CSprite
			for each (var instance:CSprite in _viewMessages[message.type])
			{
				// 该CSprite为空 || 已经被移除 || 不在舞台上
				if (instance == null)
					continue;

				// 如果已经没有父对象并且不再舞台上.则应该回收掉
				if (instance.parent == null || instance.stage == null)
				{
					removeView(instance.cName);
					continue;
				}

				// 发送消息体给该	实例
				instance.handleMessage(message);
			}
		}
	}
}
