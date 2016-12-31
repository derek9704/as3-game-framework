package com.framework.ui.sprites
{
	import com.framework.ui.basic.canvas.CCanvas;
	import com.framework.ui.basic.sprite.CSprite;
	import com.framework.ui.basic.sprite.DragParameters;
	import com.framework.utils.UiUtils;
	import com.framework.utils.greensock.TweenLite;
	import com.framework.utils.greensock.easing.Quart;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * 世界地图的基类
	 *
	 * @author derek
	 */
	public class CMap extends CSprite
	{
		/**
		 * 移动响应函数
		 * 应设置该属性以向MIMIMAP发送消息来移动MINIMAP中的容器框
		 */
		public var onMove:Function;
		/**
		 * 当前是否拖拽中
		 */
		private var _isDrag:Boolean;
		/**
		 * 地图的拖拽参数
		 */
		private var _mapDragParameters:DragParameters;

		/**
		 * 构造函数
		 *
		 * @param name 名字
		 * @param width 宽度
		 * @param height 高度
		 * @param mapBg 背景
		 */
		public function CMap(name:String, width:uint, height:uint, mapBg:DisplayObject = null)
		{
			super(name, width, height, mouseEnabled);

			// 非拖拽状态
			_isDrag = false;

			// 添加到舞台上的响应
			evts.addedToStage(onAddedToStage);

			// 结束拖拽的响应函数
			evts.addEventListener(MouseEvent.MOUSE_UP, onDrop);

			// 未指定则不绘制
			if (mapBg == null)
				return;

			// 背景的画刷
			var canvas:BitmapData = new BitmapData(mapBg.width, mapBg.height, false);
			canvas.draw(mapBg);

			// 背景平铺到整个地图上
			graphics.beginBitmapFill(canvas);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
		}

		public function set dragable(val:Boolean):void
		{
			if (_mapDragParameters == null)
				return;

			_mapDragParameters.draggable = val;
		}

		public function get dragable():Boolean
		{
			if (_mapDragParameters == null)
				return false;

			return _mapDragParameters.draggable;
		}

		/**
		 * 移动屏幕到地图的指定位置.
		 *
		 * @param pos 新位置
		 * @param center 新位置是否是屏幕中心位置.
		 */
		public function moveMap(pos:Point, center:Boolean = false, animation:Boolean = true):void
		{
			if (stage == null)
				return;
			var newPos:Point = new Point(-pos.x, -pos.y);

			// 如果原点是屏幕中间.则修整一下位置为左上角
			if (center)
			{
				newPos.x += stage.stageWidth / 2;
				newPos.y += stage.stageHeight / 2;
			}

			// 进行坐标的调整.防止地图移动超出边界
			if (newPos.x < stage.stageWidth - cWidth)
				newPos.x = stage.stageWidth - cWidth;
			if (newPos.x > 0)
				newPos.x = 0;

			if (newPos.y < stage.stageHeight - cHeight)
				newPos.y = stage.stageHeight - cHeight;

			if (newPos.y > 0)
				newPos.y = 0;

			// 修正pos的值为整数
			newPos.x = int(newPos.x);
			newPos.y = int(newPos.y);

			if (!animation)
			{
				x = newPos.x;
				y = newPos.y;
				return;
			}

			// 中止原缓动
			TweenLite.killTweensOf(this);

			// 缓动移动地图
			TweenLite.to(this, 1, {x:newPos.x, y:newPos.y, ease:Quart.easeOut});
		}

		/**
		 * 添加到舞台的响应函数
		 */
		private function onAddedToStage(event:Event):void
		{
			// 关闭添加到舞台之后的监听
			evts.removeEventListener(onAddedToStage);

			// 设置map是可以拖拽的
			this._mapDragParameters = UiUtils.setupDragable(this, true, false, false, false, 0, _onMove);

			// resize相应
			addStageEvent(Event.RESIZE, onStageResize);

			onStageResize(null);
		}

		/**
		 * 当舞台被改变大小时的回调函数
		 */
		private function onStageResize(event:Event):void
		{
			if (stage == null)
				return;

			var pWidth:int = parent.width;
			var pHeight:int = parent.height;

			var sparent:CCanvas = parent as CCanvas;

			if (sparent != null)
			{
				pWidth = sparent.cWidth;
				pHeight = sparent.cHeight;
			}

			var minX:int = pWidth - cWidth;
			var minY:int = pHeight - cHeight;

			this._mapDragParameters.rect.x = 0;
			this._mapDragParameters.rect.y = 0;
			this._mapDragParameters.rect.width = minX;
			this._mapDragParameters.rect.height = minY;

			x = int(x);
			y = int(y);

			if (x > 0)
				x = 0;

			if (y > 0)
				y = 0;

			if (x < minX)
				x = minX;

			if (y < minY)
				y = minY;

			// 如果好大啊..就不移动了
			// X方向不许拖拽?
			if (cWidth < pWidth)
			{
				x = (pWidth - cWidth) / 2;
				_mapDragParameters.rect.x = x;
				_mapDragParameters.rect.width = 0;
			}

			// y方向不许拖拽?
			if (cHeight < pHeight)
			{
				y = (pHeight - cHeight) / 2;
				_mapDragParameters.rect.y = y;
				_mapDragParameters.rect.height = 0;
			}
		}

		/**
		 * 拖拽中的响应函数
		 */
		private function _onMove(tx:int, ty:int):void
		{
			var point:Point = new Point();
			point.x = -tx;
			point.y = -ty;

			if (onMove != null)
				onMove(point);

			_isDrag = true;
		}

		/**
		 * 停止拖拽的响应函数
		 */
		private function onDrop(event:MouseEvent):void
		{
			_isDrag = false;
		}
	}
}
