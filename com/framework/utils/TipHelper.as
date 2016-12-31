package com.framework.utils
{
	import com.framework.ui.sprites.CTip;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	/**
	 * TIP助手
	 *
	 * @author derek
	 */
	public class TipHelper
	{
		private static var _tips:Dictionary = new Dictionary();
		private static var _onMouseOver:Function;
		private static var _onMouseOut:Function;

		/**
		 * 鼠标移入的响应事件
		 *
		 * @param callback callback(tip:Ctip):void{};
		 */
		public static function set mouseOver(callback:Function):void
		{
			_onMouseOver = callback;
		}

		/**
		 * 鼠标移出的响应事件
		 *
		 * @param callback callback(tip:Ctip):void{};
		 */
		public static function set mouseOut(callback:Function):void
		{
			_onMouseOut = callback;
		}

		/**
		 * 清除TIP
		 */
		public static function clear(target:DisplayObject):void
		{
			// 如果已经设置过tip.则移除3个事件响应.并且移除tips
			if (_tips[target] != null)
			{
				target.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT));
				target.removeEventListener(MouseEvent.MOUSE_OVER, _tips[target].over);
				target.removeEventListener(MouseEvent.MOUSE_OUT, _tips[target].out);
				target.removeEventListener(Event.REMOVED_FROM_STAGE, _tips[target].out);
			}
		}

		/**
		 * 设置tip.
		 *
		 * @param target 被设置tip的对象
		 * @param tip 显示的tip
		 */
		public static function setTip(target:DisplayObject, tip:CTip):void
		{
			// 如果已经设置过tip.则移除3个事件响应.并且移除tips
			if (_tips[target] != null)
			{
				target.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT));
				target.removeEventListener(MouseEvent.MOUSE_OVER, _tips[target].over);
				target.removeEventListener(MouseEvent.MOUSE_OUT, _tips[target].out);
				target.removeEventListener(Event.REMOVED_FROM_STAGE, _tips[target].out);
			}
			else
			{
				// 初始化对象
				_tips[target] = new Object();
			}

			// 是否显示tip
			var tipShow:Boolean = false;

			// 鼠标移上去的响应函数
			var onMouseOver:Function = function(event:MouseEvent):void
			{
				// 如果已经显示tip了.就直接返回
				if (tipShow)
					return;

				// 设置flag
				tipShow = true;

				_onMouseOver(tip);
			};

			// 鼠标移出的响应函数
			var onMouseOut:Function = function(event:Event):void
			{
				// 如果没有显示.则直接退出
				if (!tipShow)
					return;

				// 设定flag
				tipShow = false;

				// callback
				_onMouseOut(tip);
			};

			// 保存callback
			_tips[target].over = onMouseOver;
			_tips[target].out = onMouseOut;

			// 设定事件
			target.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			target.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			target.addEventListener(Event.REMOVED_FROM_STAGE, onMouseOut);
		}
	}
}
