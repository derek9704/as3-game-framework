package com.framework.ui.basic.canvas
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;

	/**
	 * 事件处理类
	 *
	 * 提供简便的接口来使用常用事件
	 * 记录已经绑定的事件的相关信息.以在需要的时候移除他们
	 *
	 * @author derek
	 */
	public class CCanvasEvents extends Object
	{
		private var _target:CCanvas;
		// 目标
		private var _listeners:Vector.<CCanvasEventListener>;
		// 所有事件监听器.
		private static const ALL_TYPES:String = "*";

		/**
		 * 创建新的CCanvasEvents类的实例。
		 * @param	target 目标层
		 */
		public function CCanvasEvents(target:CCanvas)
		{
			_target = target;
			_listeners = new Vector.<CCanvasEventListener>();
		}

		/**
		 * 添加事件监听器。
		 * @param	type 事件类型。
		 * @param	listener 监听器，function(e : Event)
		 * @return  target 目标CCanvas
		 */
		public function addEventListener(type:String, listener:Function):CCanvas
		{
			var l:Function = function(e:Event):void
			{
				var flag:Boolean = true;
				flag = !(e is MouseEvent || e is KeyboardEvent);
				// 如果目标Canvas被禁用，则不响应鼠标或者键盘事件
				if (_target.enable || flag)
					listener(e);
			};

			_listeners.push(new CCanvasEventListener(type, l, listener));

			_target.addEventListener(type, l);

			return _target;
		}

		/**
		 * 监听添加到舞台事件。
		 * @param	onAddedToStage 回调函数function(e : Event)
		 * @return  target 目标CCanvas
		 */
		public function addedToStage(onAddedToStage:Function):CCanvas
		{
			return addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		/**
		 * 监听从舞台移除事件。
		 * @param	onRemovedFromStage 回调函数function(e : Event)
		 * @return  target 目标CCanvas
		 */
		public function removedFromStage(onRemovedFromStage:Function):CCanvas
		{
			return addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}

		/**
		 * 监听进入帧事件。
		 * @param	onEnterFrame 回调函数function(e : Event)
		 * @return  target 目标CCanvas
		 */
		public function enterFrame(onEnterFrame:Function):CCanvas
		{
			return addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		/**
		 * 监听单击事件。
		 * @param	onClick 回调函数function(e : MouseEvent)
		 * @return  target 目标CCanvas
		 */
		public function addClick(onClick:Function):CCanvas
		{
			_target.buttonMode = true;
			_target.useHandCursor = true;
			return addEventListener(MouseEvent.CLICK, onClick);
		}

		/**
		 * 监听鼠标移入事件。
		 * @param	onMouseOver 回调函数function(e : MouseEvent)
		 * @return  target 目标CCanvas
		 */
		public function mouseOver(onMouseOver:Function):CCanvas
		{
			return addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		}

		/**
		 * 监听鼠标移出事件。
		 * @param	onMouseOut 回调函数function(e : MouseEvent)
		 * @return  target 目标CCanvas
		 */
		public function mouseOut(onMouseOut:Function):CCanvas
		{
			return addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}

		/**
		 * 监听鼠标移动事件。
		 * @param	onMouseMove 回调函数function(e : MouseEvent)
		 * @return  target 目标CCanvas
		 */
		public function mouseMove(onMouseMove:Function):CCanvas
		{
			return addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}

		/**
		 * 移除一个事件监听器。
		 * @param	listener 事件监听器的引用。
		 * @return target 目标CCanvas
		 */
		public function removeEventListener(listener:Function):CCanvas
		{
			var offset:int = -1;

			for (var i:int = 0; i < _listeners.length; i++)
			{
				if (_listeners[i].innerListener == listener)
				{
					offset = i;
					break;
				}
			}

			if (i != -1)
			{
				_target.removeEventListener(_listeners[offset].type, _listeners[offset].listener);
				_listeners.splice(offset, 1);
			}

			return _target;
		}

		/**
		 * 移除事件监听器，
		 * @param	type 事件类型字符串。"*"代表移除全部事件。
		 * @return  target 目标CCanvas
		 */
		public function removeEventListeners(type:String):CCanvas
		{
			var listenersToRemove:Vector.<CCanvasEventListener> = new Vector.<CCanvasEventListener>();

			_listeners.forEach(function(item:CCanvasEventListener, index:int, vector:Vector.<CCanvasEventListener>):void
			{
				if (type == CCanvasEvents.ALL_TYPES || type == item.type)
					listenersToRemove.push(item);
			});

			listenersToRemove.forEach(function(item:CCanvasEventListener, index:int, vector:Vector.<CCanvasEventListener>):void
			{
				_target.removeEventListener(item.type, item.listener);
				_listeners.splice(_listeners.indexOf(item), 1);
			});

			return _target;
		}

		/**
		 * 移除所有事件监听器。
		 * @return target 目标CCanvas
		 */
		public function removeAllEventListeners():CCanvas
		{
			return removeEventListeners(ALL_TYPES);
		}
	}
}
