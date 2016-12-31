package com.framework.ui.basic.layer
{
	import com.framework.ui.basic.CScene;
	import com.framework.ui.basic.canvas.CCanvas;
	import com.framework.ui.basic.canvas.DisplayObjectChild;
	import com.framework.utils.greensock.TweenLite;

	/**
	 * 层
	 * 适用场合为加入到SCene中作为一个透明层的存在(如WindowLayer,TipLayer,UiLayer).里面可以加入若干CSprite.
	 * 自动缩放大小.对子对象进行动画的显示.
	 * 
	 * @author derek
	 */
	public class CLayer extends CCanvas
	{
		/**
		 * 当层改变大小的回调函数
		 */
		public var onResize : Function;
		/**
		 * 默认缩放模式 
		 */
		public var scaleMode:String = normal;		
		/**
		 * 最大高度 
		 */
		private var _maxHeight:int;
		
		/**
		 * 不缩放
		 */
		public static const none:String = 'none';
		/**
		 * 水平缩放
		 */
		public static const horizontal:String = 'horizontal';
		/**
		 * 垂直缩放
		 */
		public static const vertical:String = 'vertical';
		/**
		 * 普通状态(水平.垂直都缩放)
		 */
		public static const normal:String = 'normal';

		/**
		 * 构造函数
		 *
		 * @param width 层宽度
		 * @param height 层高度
		 * @param animation 是否播放动画
		 */
		public function CLayer(width : Object = null, height : Object = null, animation : Boolean = false, maxHeight : int = 0)
		{
			super(width, height, false);

			// 初始化数据
			_maxHeight = maxHeight;
			_delay = false;
			_animationCount = 0;
			_animation = animation;
		}

		/**
		 * 重设窗口大小
		 */
		public function resize():void
		{
			// 未加入舞台,没有父窗口,不允许自动缩放.则退出
			if (stage == null || parent == null)
				return;

			// 获取父窗口
			var scene:CScene = parent as CScene;

			// 父窗口不是场景则退出
			if (scene == null)
				return;

			// 如果当前正在播放动画.则延迟resize
			if (_animationCount > 0)
			{
				_delay = true;

				return;
			}

			// 窗口宽高比
			var rate:Number = cHeight / cWidth;

			// 根据缩放模式来进行相应的缩放
			switch (scaleMode)
			{
				case normal:
					cWidth = scene.cWidth;
					cHeight = scene.cHeight;
					break;
				case horizontal:
					cWidth = scene.cWidth;
					cHeight = rate * cWidth;
					break;
				case vertical:
					cHeight = scene.cHeight;
					cWidth = cHeight / rate;
			}

			//最大高度
			if(_maxHeight != 0 && cHeight > _maxHeight) {
				this.y = (cHeight - _maxHeight) / 2;
				cHeight = _maxHeight;
			}
			//如果被设置了..修改大小的回调函数.则执行之
			if(onResize != null)
				onResize();
			// 调整所有子对象位置
			autoSizeChildren();
		}

		/**
		 * 
		 * 动画效果显示各子对象
		 */
		public function animation() : void
		{
			// 未开启动画则退出
			if (!_animation)
				return;

			// 当前还有动画在播放?则不许进行动画
			if (_animationCount != 0)
				return;

			// 动画计数设置为0
			_animationCount = 0;

			// 动画起始坐标
			var fromX : uint;
			var fromY : uint;

			// 遍历所有子元素
			children.forEach(function(item : DisplayObjectChild, index : int, vector : Vector.<DisplayObjectChild>) : void
			{
				// 动画计数++
				_animationCount++;

				// OBJ的宽高
				var cWidth : int = item.object.hasOwnProperty("CWidth") ? item.object.CWidth : item.object.width;
				var cHeight : int = item.object.hasOwnProperty("CHeight") ? item.object.CHeight : item.object.height;

				// 根据对齐方式进行动画
				switch(item.align)
				{
					case CCanvas.lt:
						fromX = item.object.x - cWidth;
						fromY = item.object.y - cHeight;
						break;
					case CCanvas.left:
						fromX = item.object.x - cWidth;
						fromY = item.object.y;
						break;
					case CCanvas.top:
						fromX = item.object.x;
						fromY = item.object.y - cHeight;
						break;
					case CCanvas.right:
						fromX = item.object.x + cWidth;
						fromY = item.object.y;
						break;
					case CCanvas.rt:
						fromX = item.object.x + cWidth;
						fromY = item.object.y - cHeight;
						break;
					case CCanvas.lb:
						fromX = item.object.x - cWidth;
						fromY = item.object.y + cHeight;
						break;
					case CCanvas.rb:
						fromX = item.object.x + cWidth;
						fromY = item.object.y + cHeight;
						break;
					case CCanvas.bottom:
						fromX = item.object.x;
						fromY = item.object.y + cHeight;
						break;
				}

				// 缓动
				TweenLite.from(item.object, 1, {x:fromX, y:fromY, alpha:0.5, onComplete:function() : void
				{
					// 完成了则--
					_animationCount--;

					// 如果最后一个动画元素了.并且应该进行RESIZE
					if (_delay && _animationCount == 0)
					{
						_delay = false;
						resize();
					}
				}});
			});
		}

		// 动画计数
		private var _animationCount : uint;
		// 是否延迟RESIZE
		private var _delay : Boolean;
		// 是否开启动画
		private var _animation : Boolean;
	}
}
