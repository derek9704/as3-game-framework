package com.framework.utils
{
	import com.framework.ui.basic.canvas.CCanvas;
	import com.framework.ui.basic.sprite.DragParameters;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * UI助手
	 */
	public class UiUtils
	{
		/**
		 * 设置按钮的状态
		 */
		public static function setButtonEnable(mc:MovieClip, enable:Boolean, mask:Boolean = true):void
		{
			mc.enable = enable;
			
			FilterUtils.clearColorMask(mc);
			
			if (!enable)
			{
				if (mask)
					FilterUtils.setColorMask(mc, 0xcccccc);
				
				mc.gotoAndStop(1);
			}
		}

		/**
		 * 设置对象为可拖拽的
		 *
		 * @param obj 对象
		 * @param range 父对象内部进行拖拽(此参数只有在toStage = false才有效)
		 * @param xNoMove X不可拖动
		 * @param yNoMove Y不可拖动
		 * @param toTop 是否被设为顶级子对象(此参数只有在toStage = false才有效)
		 * @param borderWidth 边框宽度(此参数只有在range = true时才有效)
		 * @param onMove 当移动对象的回调函数
		 * @param onDragOver 拖拽结束的回调函数
		 * @param toStage 被拖拽的对象可以被拖拽到任意位置
		 * @param copy 复制模式(这个模式下.拖拽对象会自动生成一个副本来进行拖拽.此参数只有在toStage = true时才有效)
		 * @param dragArea 拖拽区域(obj上的可以拖拽的区域).默认为=null,即整个对象上都可以拖拽.
		 * @param onDragStart 开始拖拽的回调函数
		 * @param mapMode 是否地图模式
		 */
		public static function setupDragable(obj:*, range:Boolean = true, xNoMove:Boolean = false, yNoMove:Boolean = false, toTop:Boolean = false, borderWidth:int = 0, onMove:Function = null, onDragOver:Function = null, toStage:Boolean = false, copy:Boolean = false, dragArea:Rectangle = null, onDragStart:Function = null, mapMode:Boolean = false):DragParameters
		{
			// 当前是否拖拽
			var draging:Boolean = false;

			// 对象原始位置
			var oldX:int;
			var oldY:int;

			// 是否开始拖拽
			var startDrag:Boolean = false;

			// 需要保存的拖拽参数

			var dp:DragParameters = new DragParameters(onMove, onDragOver, onDragStart);

			// 自己的宽高
			var oWidth:int = obj.hasOwnProperty('cWidth') ? obj.cWidth : obj.width;
			var oHeight:int = obj.hasOwnProperty('cHeight') ? obj.cHeight : obj.height;

			// 父对象的宽高
			var pWidth:int = obj.parent.hasOwnProperty('cWidth') ? (obj.parent as CCanvas).cWidth : obj.parent.width;
			var pHeight:int = obj.parent.hasOwnProperty('cHeight') ? (obj.parent as CCanvas).cHeight : obj.parent.height;

			// 父对象内拖拽?
			if (range && !toStage)
			{
				if (mapMode)
				{
					// 比父对象小?
					if (oWidth < pWidth)
						xNoMove = true;

					if (oHeight < pHeight)
						yNoMove = true;
				}

				// 计算出拖拽的范围
				var xMin:int = 0;
				var xMax:int = pWidth - oWidth;
				var yMin:int = 0;
				var yMax:int = pHeight - oHeight;

				// X方向不许拖拽?
				if (xNoMove)
				{
					xMin = obj.x;
					xMax = 0;
				}

				// y方向不许拖拽?
				if (yNoMove)
				{
					yMin = obj.y;
					yMax = 0;
				}

				// 拖拽范围进行保存
				dp.rect = new Rectangle(xMin, yMin, xMax, yMax);
			}

			// 如果被设置为..全局拖拽.则要保存各种信息
			if (toStage)
			{
				dp.parent = obj.parent;
				dp.x = obj.x;
				dp.y = obj.y;
				dp.index = obj.parent.getChildIndex(obj);
			}

			var target:* = obj;

			// 如果设置为.COPY模式.则创建一个被拖拽的影像
			if (copy && toStage)
			{
				var bmpData:BitmapData = new BitmapData(oWidth, oHeight, true, 0x000000);
				bmpData.draw(obj);
				target = new Sprite();
				target.addChild(new Bitmap(bmpData));
				target.x = obj.x;
				target.y = obj.y;
			}
			// 记录target

			dp.target = target;

			var onMouseDown:Function = function(e:MouseEvent):void
			{
				e.stopImmediatePropagation();
				e.stopPropagation();

				// 不允许拖拽则退出
				if (!dp.draggable)
				{
					startDrag = draging = false;
					target.stopDrag();
					return;
				}

				// 不可用则退出
				if (obj.hasOwnProperty('enable') && !obj.enable)
					return;

				// 拖拽中.返回
				if (draging)
					return;
				// 拖拽区域的判断
				if (dragArea != null)
				{
					if ((obj.mouseX < dragArea.x) || (obj.mouseX > dragArea.width) || (obj.mouseY < dragArea.y) || (obj.mouseY > dragArea.height))
						return;
				}

				draging = true;

				// 当按下鼠标.准备拖拽的时候.才会注册到STAGE两个事件
				obj.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);

				obj.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			};

			// 鼠标松开的回调函数
			var onMouseUp:Function = function(e:MouseEvent):void
			{
				// 拖拽中放开了鼠标?

				if (draging && startDrag && dp.onOver != null)
					dp.onOver();
				// 设置FLAG为FALSE
				startDrag = draging = false;

				// 停止拖拽
				target.stopDrag();

				if (obj != null && obj.stage != null)
				{
					obj.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
					obj.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				}
			};

			// 鼠标移动的回调函数
			var onMouseMove:Function = function(event:MouseEvent):void
			{
				// 不允许拖拽则退出
				if (!dp.draggable)
				{
					startDrag = draging = false;
					target.stopDrag();
					obj.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
					obj.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
					return;
				}

				if (!draging)
					return;

				// 如果还没开始拖拽
				if (!startDrag)
				{
					startDrag = true;

					// 开始拖拽的回调函数
					if (dp.onStart != null)
						dp.onStart();

					if (toStage)
					{
						target.x = event.stageX - obj.mouseX;
						target.y = event.stageY - obj.mouseY;
						(obj.stage as Stage).addChild(target);
					}

					// 如果是地图模式.判断是否是..比父对象小.如果小就不可拖拽
					target.startDrag(false, dp.rect);

					// toTop 和toStage不可以联合使用
					if (toTop && !toStage)
						target.parent.setChildIndex(target, target.parent.numChildren - 1);
				}

				// 有移动的回调函数
				if (onMove != null)
					onMove(target.x, target.y);

				oldX = target.x;
				oldY = target.y;
			};

			obj.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);

			// 释放
			var cleanHandler:Function = function(event:Event):void
			{
				obj.removeEventListener(Event.REMOVED_FROM_STAGE, cleanHandler);
				obj.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			}
			obj.addEventListener(Event.REMOVED_FROM_STAGE, cleanHandler);

			return dp;
		}
	}
}
