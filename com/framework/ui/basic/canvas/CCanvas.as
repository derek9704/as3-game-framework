package com.framework.ui.basic.canvas
{
	import com.framework.utils.FilterUtils;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;

	/**
	 * 提供最基本的容器功能.提供子对象.事件.
	 *
	 * @author derek
	 */
	public class CCanvas extends Sprite
	{
		// 名字
		public var cName:String;
		// 宽度
		private var _cWidth:Number;
		// 高度
		private var _cHeight:Number;
		// 是否可用
		private var _enable:Boolean;
		// 事件
		private var _evts:CCanvasEvents;
		// 禁用控件后的颜色.默认灰色
		private var _disableColor:uint = 0xcccccc;
		private var _bg : CCanvasBackground;
		
		// 子对象列表
		public var children:Vector.<DisplayObjectChild>;


		/**
		 * 构造函数
		 *
		 * @param width 宽度
		 * @param height 高度
		 * @param mouseEnabled 是否响应鼠标
		 */
		public function CCanvas(width:Object = null, height:Object = null, mouseEnabled:Boolean = true)
		{
			// 如果传入了宽度和高度.则使用该参数初始化
			if (width != null)
			{
				_cWidth = Number(width);
			}
			if (height != null)
			{
				_cHeight = Number(height);
			}

			// 设定是否响应鼠标
			this.mouseEnabled = mouseEnabled;

			// 默认使用
			_enable = true;

			// 初始化子对象
			children = new Vector.<DisplayObjectChild>();
		}

		public function addStageEvent(event : String, callback : Function) : void
		{
			var s : Stage = stage;

			// 已经被加入舞台了?
			// 加入事件
			if (s != null)
			{
				s.addEventListener(event, callback);
			}

			// 加入到舞台上的时候..加入这个事件
			evts.addedToStage(function(e : Event) : void
			{
				s = stage;

				// 尝试移除事件
				s.removeEventListener(event, callback);

				// 重新添加
				s.addEventListener(event, callback);
			});

			// 被从舞台上移除的时候..移除这个事件
			evts.removedFromStage(function(e : Event) : void
			{
				if (s != null)
				{
					s.removeEventListener(event, callback);
				}
			});
		}

		/**
		 * 移除自己 包括所有子对象
		 */
		public function removeSelf():void
		{
			//移除所有子对象
			removeAllChildren();
			
			// 移除自己
			if (parent != null)
				parent.removeChild(this);

			// 移除所有事件
			evts.removeAllEventListeners();
		}

		/**
		 * 移除所有子对象
		 */
		public function removeAllChildren():void
		{
			// 遍历删除子对象
			children.forEach(function(item:DisplayObjectChild, index:int, vector:Vector.<DisplayObjectChild>):void
			{
				if (item.object.parent != self)
					return;

				if (item.object as CCanvas != null)
				{
					(item.object as CCanvas).removeSelf();
				}
				else
					item.object.parent.removeChild(item.object);
			});

			// 清空
			children = new Vector.<DisplayObjectChild>();
		}

		/**
		 * 设置是否可用。
		 * @param	enable
		 * @return
		 */
		public function setEnable(enable:Boolean):CCanvas
		{
			_enable = enable;
			return this;
		}

		/**
		 * 添加子对象(水平向居中)
		 *
		 * @param y Y坐标
		 */
		public function addChildH(child:*, y:int = 0, align:uint = lt):CCanvas
		{
			// 获取子对象的宽度
			var tWidth:int = child.hasOwnProperty("cWidth") ? child.cWidth : child.width;
			// 加入对象
			return addChildEx(child, (cWidth - tWidth) / 2, y, align, true, false);
		}

		/**
		 * 添加子对象(垂直向居中)
		 *
		 * @param child 子对象
		 * @param x X坐标
		 */
		public function addChildV(child:*, x:int = 0, align:uint = lt):CCanvas
		{
			// 获取子对象的宽度和高度
			var tHeight:int = child.hasOwnProperty("cHeight") ? child.cHeight : child.height;

			return addChildEx(child, x, (cHeight - tHeight) / 2, align, false, true);
		}

		/**
		 * 加入子对象(居中)
		 *
		 * @param child 子对象.
		 */
		public function addChildCenter(child:*):CCanvas
		{
			// 获取子对象的宽度和高度
			var tWidth:int = child.hasOwnProperty("cWidth") ? child.cWidth : child.width;
			var tHeight:int = child.hasOwnProperty("cHeight") ? child.cHeight : child.height;

			// 获取居中的坐标
			var cx:int = (cWidth - tWidth) / 2;
			var cy:int = (cHeight - tHeight) / 2;

			// 加入子对象
			return addChildEx(child, cx, cy, lt, true, true);
		}

		/**
		 * 使用指定参数添加子对象
		 *
		 * @param child 子对象
		 * @param x x
		 * @param y y
		 * @param xCenter x方向居中
		 * @param yCenter y方向居中
		 * @param align 对齐方式.值为CCanvas.lt等
		 */
		public function addChildEx(child:*, x:Number = 0, y:Number = 0, align:uint = lt, xCenter:Boolean = false, yCenter:Boolean = false):CCanvas
		{
			// 获取子对象的宽度和高度
			var tWidth:int = child.hasOwnProperty("cWidth") ? child.cWidth : child.width;
			var tHeight:int = child.hasOwnProperty("cHeight") ? child.cHeight : child.height;

			// 子对象不为空?
			if (child != null)
			{
				child.x = x;
				child.y = y;

				// 根据对齐方式进行X/Y的赋值
				if ((align & left) != 0)
					child.x = x;

				if ((align & right) != 0)
					child.x = cWidth - tWidth - x;

				if ((align & top) != 0)
					child.y = y;

				if ((align & bottom) != 0)
					child.y = cHeight - tHeight - y;

				// 加入对象
				super.addChild(child);
				children.push(new DisplayObjectChild(child, x, y, xCenter, yCenter, align));
			}

			return this;
		}
		
		/**
		 *
		 * 按照子对象的对齐方式来自动设置子对象的位置
		 */
		public function autoSizeChildren():void
		{
			for each (var child:DisplayObjectChild in children)
			{
				// 获取子对象的宽度和高度
				var tWidth:int = child.object.hasOwnProperty("cWidth") ? child.object.cWidth : child.object.width;
				var tHeight:int = child.object.hasOwnProperty("cHeight") ? child.object.cHeight : child.object.height;
				
				// 根据对齐方式进行X/Y的赋值
				var align:uint = child.align;
				
				// 右对齐则设置x从右向左对齐
				if (align & right)
					child.object.x = cWidth - tWidth - child.xOffset;
				
				// 下对齐则设置y从下向上对齐
				if (align & bottom)
					child.object.y = cHeight - tHeight - child.yOffset;
				
				// 特殊处理一下.x,y的自动居中
				if (child.xCenter)
					child.object.x = (cWidth - tWidth) / 2 + child.xOffset;
				
				if (child.yCenter)
					child.object.y = (cHeight - tHeight) / 2 + child.yOffset;
			}
			;
		}

		/**
		 * 移除一个子对象
		 *
		 * @param child 子对象引用
		 */
		public override function removeChild(child:DisplayObject):DisplayObject
		{
			var result:DisplayObject;

			// 传入的对象不为空
			if (child != null)
			{
				// 是这个类的子对象
				if (child.parent == this)
				{
					// 移除子对象
					result = super.removeChild(child);

					// 获取子对象的位置
					var index:int = children.indexOf(child);

					// 如果子对象在队列中.则移除之
					if (index >= 0)
						children.splice(index, 1);
				}
			}

			return result;
		}

		/**
		 * 对象是否可用
		 */
		public function get enable():Boolean
		{
			return _enable;
		}

		/**
		 * 设置对象是否可用
		 */
		public function set enable(value:Boolean):void
		{
			if (_enable == value)
				return;

			_enable = value;

			// 如果是启用.则清除颜色遮罩
			if (enable)
			{
				FilterUtils.clearColorMask(this);
				return;
			}

			// 设置颜色遮罩
			FilterUtils.setColorMask(this, _disableColor);
		}

		/**
		 * 对象的宽度.应该用此值来取代width.因为width在很多场合不能正确的表述对象的真实宽度
		 */
		public function get cWidth():Number
		{
			return _cWidth;
		}

		/**
		 * 对象的宽度.应该用此值来取代width.因为width在很多场合不能正确的表述对象的真实宽度
		 */
		public function set cWidth(value:Number):void
		{
			_cWidth = value;

			if (bg != null)
				bg.redraw();
		}

		/**
		 * 对象的高度.应该用此值来取代height.因为height在很多场合不能正确的表述对象的真实宽度
		 */
		public function get cHeight():Number
		{
			return _cHeight;
		}

		/**
		 * 对象的高度.应该用此值来取代height.因为height在很多场合不能正确的表述对象的真实宽度
		 */
		public function set cHeight(value:Number):void
		{
			_cHeight = value;

			if (bg != null)
				bg.redraw();
		}

		/**
		 * 事件处理部分的功能.应该用此功能内的函数来代替系统提供的事件处理函数
		 * 因为本功能提供的事件函数受enable等功能的限制.且提供了系统事件处理函数所不提供的功能
		 */
		public function get evts():CCanvasEvents
		{
			if (_evts == null)
			{
				_evts = new CCanvasEvents(this);
			}

			return _evts;
		}

		/**
		 * 自己的引用
		 */
		public function get self():CCanvas
		{
			return this;
		}

		/**
		 * 设置禁用控件后的颜色
		 */
		public function set disableColor(value:uint):void
		{
			_disableColor = value;
		}
		
		/**
		 * 获取背景内容
		 */
		public function get bg() : CCanvasBackground
		{
			if (_bg == null)
				_bg = new CCanvasBackground(this);

			return _bg;
		}
		// 子对象的对齐方式
		/**
		 * 左方
		 */
		public static const left:uint = 1;
		/**
		 * 右方
		 */
		public static const right:uint = 2;
		/**
		 * 顶部
		 */
		public static const top:uint = 4;
		/**
		 * 底部
		 */
		public static const bottom:uint = 8;
		/**
		 * 左上
		 */
		public static const lt:uint = 5;
		/**
		 * 右上
		 */
		public static const rt:uint = 6;
		/**
		 * 左下
		 */
		public static const lb:uint = 9;
		/**
		 * 右下
		 */
		public static const rb:uint = 10;
	}
}
