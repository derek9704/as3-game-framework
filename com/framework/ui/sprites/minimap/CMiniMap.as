package com.framework.ui.sprites.minimap
{
	import com.framework.ui.basic.canvas.CCanvas;
	import com.framework.ui.basic.sprite.CSprite;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	/**
	 * 迷你地图类.实现了:初始化数据;根据类别显示各个点;更新各点内容;拖拽;跳转到指定点等功能.详细说明参见各函数说明
	 * @author derek
	 */
	public class CMiniMap extends CSprite
	{
		private var _doList:Array;
		private var _itemLayer:CCanvas;

		/**
		 *
		 * 构造函数
		 *
		 * @param name minimap名字.标识
		 * @param onMove 当移动小地图的容器框的时候的回调函数
		 * 				 回调函数格式应该如下 function(point:Point):void; point为背景地图在当前容器上的位置(已经设置为 - 的了).
		 * 				 直接使用期给背景地图赋值即可;
		 * @param w 宽度
		 * @param h 高度
		 * @param bgColor 背景颜色 = 0x000000
		 * @param alpha 透明度 = 0.6
		 */
		public function CMiniMap(name:String, w:int, h:int, doList:Array, bgColor:uint = 0x000000, alpha:Number = 0.6)
		{
			super(name, w, h);

			// 初始化变量
			_bgColor = bgColor;
			_alpha = alpha;

			// item层
			_itemLayer = new CCanvas();
			_itemLayer.mouseChildren = false;
			_itemLayer.mouseEnabled = false;

			addChild(_itemLayer);

			// 构造并加入容器框
			_range = new CCanvas();
			// _range.mouseEnabled = false;
			_range.visible = false;
			_range.buttonMode = true;

			addChildEx(_range);

			// 保存do列表
			_doList = doList;

			// 鼠标在MINIMAP上单击触发的函数
			evts.addEventListener(MouseEvent.MOUSE_DOWN, function(event:MouseEvent):void
			{
				// TODO: 此处可能有问题
				// trace(mouseX);
				// trace(mouseY);

				// 设置FLAG
				_mouseDown = true;

				// 移动容器框
				moveRange(mouseX - _rangeWidth / 2, mouseY - _rangeHeight / 2, true);

				// 发送消息移动窗口
				getMapPoint();
			});

			// 鼠标移动
			evts.addEventListener(MouseEvent.MOUSE_MOVE, function(event:MouseEvent):void
			{
				// 未拖拽或未设置onMove回调函数 则返回
				if (!_mouseDown || _onMove == null)
					return;

				var point:Point = globalToLocal(new Point(stage.mouseX, stage.mouseY));

				// 移动容器框
				moveRange(point.x - _rangeWidth / 2, point.y - _rangeHeight / 2, true);

				// 发送消息移动窗口
				getMapPoint();
			});

			// 鼠标在容器框上弹起
			evts.addEventListener(MouseEvent.MOUSE_UP, function(event:MouseEvent):void
			{
				// 设置FLAG
				_mouseDown = false;
			});
		}

		private function getMapPoint():void
		{
			// 获取父容器在地图中的位置
			var x:int = (_range.x) * _info.width / cWidth;
			var y:int = (_range.y) * _info.height / cHeight;

			// 边界检查
			if (x < 0)
				x = 0;

			if (y < 0)
				y = 0;

			if (x > _info.width - _rangeWidth * _info.width / cWidth)
				x = _info.width - _rangeWidth * _info.width / cWidth;

			if (y > _info.height - _rangeHeight * _info.height / cHeight)
				y = _info.height - _rangeHeight * _info.height / cHeight;

			// CALLBACK
			_onMove(new Point(-x, -y));
		}

		/**
		 * 传入地图信息.初始化minimap
		 *
		 * @param info 迷你地图信息
		 */
		public function initInfo(info:MiniMapData):void
		{
			// 保存信息
			_info = info;

			// item列表
			var items:Dictionary = _info.items;

			// 遍历所有的item.转换newpoint
			for each (var item:MiniMapItem in items)
			{
				// minimap上的位置 = 原位置 * 大地图size / 小地图size
				item.newPoint = new Point(item.point.x * cWidth / info.width, item.point.y * cHeight / info.height);
			}

			// 设定CALLBACK
			_onMove = info.onMove;

			// 显示RANGE
			resetRange(cWidth, cHeight);
			_range.visible = true;

			// 绘制MINIMAP
			draw();
		}

		/**
		 *
		 * 修改容器框的大小
		 * 当修改了地图父容器的大小后.需要调用本函数来重置MINIMAP中容器框的大小
		 *
		 * @param width 宽度
		 * @param height 高度
		 */
		public function resetRange(width:uint, height:uint):void
		{
			if (_info == null)
				return;

			// 转换宽高
			_rangeWidth = width * cWidth / _info.width;
			_rangeHeight = height * cHeight / _info.height;

			// 重绘容器框
			_range.graphics.clear();
			_range.graphics.lineStyle(1, _info.rangeColor);
			_range.graphics.beginFill(0x000000, 0);
			_range.graphics.drawRect(0, 0, _rangeWidth, _rangeHeight);
			_range.graphics.endFill();
		}

		/**
		 *
		 * 修改容器框的位置
		 *
		 * @param x X
		 * @param y Y
		 */
		public function moveRange(x:int, y:int, local:Boolean = false):void
		{
			if (_info == null)
				return;

			// 更新坐标
			_range.x = local ? x : (x * cWidth / _info.width);
			_range.y = local ? y : (y * cHeight / _info.height);

			// 修正位置
			if (_range.x < 0)
				_range.x = 0;

			if (_range.y < 0)
				_range.y = 0;

			if (_range.x + _rangeWidth > cWidth)
				_range.x = cWidth - _rangeWidth;

			if (_range.y + _rangeHeight > cHeight)
				_range.y = cHeight - _rangeHeight;
		}

		/**
		 *
		 * 跳转到指定ID的位置
		 *
		 * @param targetId 目标ID
		 */
		public function goto(targetId:String):void
		{
			if (_info == null)
				return;

			// 获取ITEM
			var item:MiniMapItem = _info.items[targetId];

			// ITEM不存在?
			if (item == null)
			{
				// trace('minimap item not found..itemId:' + targetId);
				return;
			}

			// 移动到指定位置
			moveRange(item.newPoint.x - _rangeWidth / 2, item.newPoint.y - _rangeHeight / 2);
		}

		/**
		 *
		 * 修改ITEM的属性
		 *
		 * @param targetId 目标ID
		 * @param newPoint 新的位置 = null
		 * @param colorIndex 新的颜色index = -1 (不改变颜色)
		 * @param changeLine 是否修改边线 = false (不修改)
		 * @param lineColorIndex 线的颜色index = -1 (没有线)
		 *        ps:当changeLine为true的时候.lineColorIndex的值 = -1 则取消边线 ;>=0的值则为设置边线为该index的颜色
		 *           当changeLine为false的时候.lineColorIndex的值被忽略掉.
		 */
		public function changeItem(info:MiniMapChangeItemInfo):void
		{
			if (_info == null)
				return;

			// 获取ITEM
			var item:MiniMapItem = _info.items[info.targetId];

			// ITEM不存在?
			if (item == null)
			{
				trace('minimap item not found..itemId:' + info.targetId);
				return;
			}

			// 重设颜色
			if (info.doIndex != -1)
				item.doIndex = info.doIndex;

			// 修改line(= true 则去判断linecolorindex的值)
			if (info.changeLine)
			{
				item.line = info.lineColorIndex != -1;
				item.lineColorIndex = info.lineColorIndex;
			}

			// 传入了新坐标
			if (info.newPoint != null)
			{
				// 更新坐标
				item.newPoint = new Point(info.newPoint.x * cWidth / _info.width, info.newPoint.y * cHeight / _info.height);
			}

			// 重绘小地图
			draw();
		}

		/**
		 * 绘制MINIMAP
		 */
		private function draw():void
		{
			// 初始化背景
			graphics.clear();
			graphics.beginFill(_bgColor, _alpha);
			graphics.drawRect(0, 0, cWidth, cHeight);
			graphics.endFill();

			// item列表
			var items:Dictionary = _info.items;

			//
			_itemLayer.removeAllChildren();

			// 分类绘制
			var newItems:Array = [];

			// 按照index分类所有点
			for each (var item:MiniMapItem in items)
			{
				if (newItems[item.doIndex] == null)
					newItems[item.doIndex] = [];

				newItems[item.doIndex].push(item);
			}

			// 遍历绘制点
			for each (var arr:Array in newItems)
			{
				if (arr == null)
					continue;

				for each (var newItem:MiniMapItem in arr)
				{
					drawItem(newItem);
				}
			}
		}

		/**
		 *
		 * 绘制ITEM
		 *
		 * @param item ITEM信息
		 */
		private function drawItem(item:MiniMapItem):void
		{
			// 获取ITEM的坐标
			var point:Point = item.newPoint;

			// 绘制点位置
			var mc:Bitmap = new Bitmap(_doList[item.doIndex]);
			_itemLayer.addChildEx(mc, point.x, point.y);

			// 如果设置了边线.则绘制边线
			if (item.line)
			{
				graphics.lineStyle(1, _lineColors[item.lineColorIndex]);
				graphics.drawRect(point.x, point.y, mc.width, mc.height);
			}
		}

		/**
		 * 线的颜色数组.默认为[黄,红,绿,蓝]
		 */
		private var _lineColors:Array = [0xffff00, 0xff0000, 0x00ff00, 0x0000ff];
		/**
		 * 点的颜色数组.默认为[白,深红,蓝,褐,黑,紫,绿]
		 */
		private var _pixelColors:Array = [0xffffff, 0xbf175a, 0x232cd9, 0xc28025, 0x000000, 0x9e4dab, 0x33ba0d];
		/**
		 * 小地图信息
		 */
		private var _info:MiniMapData;
		/**
		 * 背景颜色 默认 黑色
		 */
		private var _bgColor:uint;
		/**
		 * 透明度 默认0.6
		 */
		private var _alpha:Number;
		private var _range:Sprite;
		/**
		 * 容器框宽度
		 */
		private var _rangeWidth:uint;
		/**
		 * 容器框高度
		 */
		private var _rangeHeight:uint;
		/**
		 * 鼠标是否按下
		 */
		private var _mouseDown:Boolean;
		/**
		 * 当容器框移动的时候的CALLBACK
		 */
		private var _onMove:Function;
	}
}
