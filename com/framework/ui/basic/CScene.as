package com.framework.ui.basic
{
	import com.framework.ui.basic.canvas.CCanvas;
	import com.framework.ui.basic.layer.CLayer;
	import com.framework.utils.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;

	/**
	 *  主场景类.CScene下可以加入若干CLayer来实现场景的功能.
	 *  实现了.设置背景.自动调整大小等功能.
	 *          1.普通背景:设置普通的DO为背景.
	 * 	        2.拖拽背景:比CScene大很多的背景.可以在CScene中进行拖拽.如(世界地图).
	 *
	 * @author derek
	 */
	public class CScene extends CCanvas
	{
		private var _bg:*;

		/**
		 *
		 * 构造函数
		 *
		 * @param w 宽度
		 * @param h 高度
		 * @param autoSize 随着窗口缩放大小
		 */
		public function CScene(name:String, w:Object = null, h:Object = null, autoSize:Boolean = true)
		{
			super(w, h);
			// 自动缩放
			if (autoSize)
				evts.addedToStage(onAddedToStage);
			cName = name;
		}

		public function get content():*
		{
			return _bg;
		}

		/**
		 * 设置背景.可以传入DisplayObject
		 * @param bg 背景DisplayObject.
		 */
		public function setContent(bg:*):void
		{
			// 移除原始场景
			if (_bg as CCanvas != null)
				(_bg as CCanvas).removeSelf();
			else
				removeChild(_bg);

			// 替换新的背景
			_bg = bg;
			// 加入到最底层.这里使用addChild是不让_bg加入CCanvas的子对象列表中.
			addChildAt(_bg, 0);
		}

		public override function removeSelf():void
		{
			if (content as CCanvas != null)
				(content as CCanvas).removeSelf();
			else
				content.parent.removeChild(content);

			super.removeSelf();
		}

		/**
		 *
		 * 重新设置场景的大小
		 *
		 */
		public function resize():void
		{
			// 场景为空则退出
			if (stage == null)
				return;

			// 重设宽高为舞台大小
			cWidth = stage.stageWidth;
			cHeight = stage.stageHeight;

			// 获取子对象数量
			var count:int = numChildren;
			// 遍历子对象
			for (var i:int = 0; i < count; i++)
			{
				// 是CLayer的子对象
				var clayer:CLayer = getChildAt(i) as CLayer;

				// 不是CLayer则跳过
				if (clayer == null)
					continue;

				// 对层的子对象进行重设位置
				clayer.resize();
			}
		}

		/**
		 *
		 * 加入舞台后的响应
		 *
		 */
		private function onAddedToStage(event:Event):void
		{
			// 移除舞台事件响应
			evts.removeEventListener(onAddedToStage);

			// 重设子对象
			resize();

			// 加入resize事件响应
			addStageEvent(Event.RESIZE, function(event : Event) : void
			{
				if (stage == null || !visible || parent == null)
					return;
				resize();

				if (onResize != null)
					onResize();
			});
		}
		/**
		 * 被改变大小后的回调函数
		 */
		public var onResize : Function;
	}
}
