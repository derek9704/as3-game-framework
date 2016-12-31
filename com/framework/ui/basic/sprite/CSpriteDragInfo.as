package com.framework.ui.basic.sprite
{
	import com.framework.utils.UiUtils;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	/**
	 * 拖拽信息
	 *
	 * @author derek
	 */
	public class CSpriteDragInfo
	{
		private var _copy:Boolean;
		private var _dragArea:Rectangle;
		private var _placeInfo:PlaceInfo;
		private var _dragParams:DragParameters;
		private static var _placeTargets:Dictionary = new Dictionary();
		private var _target:CSprite;

		/**
		 * 构造函数
		 *
		 * @param target 使用本拖拽参数的目标
		 */
		public function CSpriteDragInfo(target:CSprite)
		{
			_target = target;
		}

		/**
		 * 是否允许放置(如果没有设置过 放置信息.则本参数无效)
		 *
		 * @param value 是否允许放置
		 */
		public function set place(value:Boolean):void
		{
			if (_placeInfo == null)
				return;

			_placeInfo.enable = value;
		}

		private function initDragInfo(dragArea:Rectangle):void
		{
			_target.evts.addedToStage(function(event:Event):void
			{
				_target.evts.removeEventListener(arguments.callee);
				_dragParams = UiUtils.setupDragable(_target, false, false, false, false, 0, null, null, false, false, dragArea);
			});
		}

		/**
		 * 是否允许拖拽(如果没有设置过.拖拽信息.则启用简单拖拽模式.即可以在父窗口中.拖来拖去)
		 *
		 * @param value 是否允许拖拽
		 */
		public function set drag(value:Boolean):void
		{
			// 如果没有拖拽信息.
			if (_dragParams == null)
			{
				// 设置可以拖拽?
				if (value)
					initDragInfo(dragArea);

				return;
			}

			_dragParams.draggable = value;
		}

		public function moveBack():void
		{
			// copy模式.移除镜像即可
			if (_copy)
			{
				_dragParams.target.parent.removeChild(_dragParams.target);
				return;
			}

			if (_dragParams.parent == null)
				return;

			// 还原信息
			_dragParams.parent.addChildAt(_target, _dragParams.index);
			_target.x = _dragParams.x;
			_target.y = _dragParams.y;
			_target.parent.setChildIndex(_target, _dragParams.index);
		}

		/**
		 * 懒惰模式设置拖拽信息
		 *
		 * @param dragId 拖拽id.如果某个对象的placeId与他相同.则那个对象会响应本对象的拖拽
		 * @param data 拖拽完成后.会把这个值作为回调函数的参数传递给.相应对象
		 * @param global 是否为全局拖拽.
		 * @param copy 是否复制模式
		 * @param onDragHit 当本对象拖拽中与其他对象发生了碰撞.会回调本函数
		 * @param onDragOver 当拖拽完成后.会回调本函数.函数声明:onDragOver(place:Boolean):void; place为是否放置成功.
		 */
		public function setDrag(dragId:int, data:*, global:Boolean, copy:Boolean, onDragHit:Function, onDragOver:Function):void
		{
			// 是否为copy模式
			_copy = copy;

			// 当被加入舞台的时候.再进行拖拽的设定
			_target.evts.addedToStage(function(event:Event):void
			{
				_target.evts.removeEventListener(arguments.callee);

				_dragParams = UiUtils.setupDragable(_target, false, false, false, false, 0, function(tx:int, ty:int):void
				{
					// 可以放置的所有对象
					var items:Vector.<PlaceInfo> = _placeTargets[dragId];

					// 没有对象直接返回
					if (items == null)
						return;

					// 对象长度
					var len:int = items.length;

					// 遍历所有对象
					for (var i:int = 0; i < len; i++)
					{
						var itemPlaceInfo:PlaceInfo = items[i];

						// 对象不接收拖拽.则跳过
						if (!itemPlaceInfo.enable)
							continue;

						// 目标对象和自己进行碰撞检测
						var flag:Boolean = _dragParams.target.hitTestObject(itemPlaceInfo.target);

						// 如果当前碰撞检测返回和上次检测的值不同
						// 并且回调函数不为空
						if (flag != itemPlaceInfo.oldStatus && itemPlaceInfo.hitTest != null)
						{
							// 更新状态
							itemPlaceInfo.oldStatus = flag;
							// 回调函数
							itemPlaceInfo.hitTest(flag);
						}

						// 回掉拖拽
						if (flag && onDragHit != null)
							onDragHit();
					}
				}, function():void
				{
					// 拖拽对象列表
					var items:Vector.<PlaceInfo> = _placeTargets[dragId];

					// 列表是空.则直接返回
					if (items == null)
					{
						// 移回自己
						moveBack();

						// 回调函数
						if (onDragOver != null)
							onDragOver(false, _dragParams.target);

						return;
					}

					// 可接受拖拽的对象列表
					var len:int = items.length;

					// 遍历所有接受拖拽的对象
					for (var i:int = 0; i < len; i++)
					{
						// 拖拽信息
						var itemPlaceInfo:PlaceInfo = items[i];

						// 如果目标不可用 or 鼠标没有移动上(不可见状态).则直接返回
						if (!itemPlaceInfo.enable)
							continue;

						// 碰撞检测
						if (_dragParams.target.hitTestObject(itemPlaceInfo.target))
						{
							// target
							var target:CSprite = items[i].target;

							// 进行鼠标指针是否在item上面的判断

							// 绝对位置
							// var gPoint:Point = items[i].target.localToGlobal(new Point(items[i].target.x,items[i].target.y));
							// 最大位置
							// var gSize:Point = new Point( gPoint.x + items[i].target.cWidth,gPoint.y + items[i].target.cHeight);

							var mX:int = target.mouseX;
							var mY:int = target.mouseY;

							// 不再范围内..下一个判断
							if (!(mX > 0 && mX < target.cWidth && mY > 0 && mY < target.cWidth))
							{
								continue;
							}

							// 向对象发送拖拽数据
							items[i].dropOn = true;
							items[i].data = data;
							items[i].onDragOver = function():void
							{
								if (onDragOver != null)
									onDragOver(true, _dragParams.target);
							};

							// 移回对象
							moveBack();

							return;
						}
					}

					// 没有碰撞到任何对象.回调之
					if (onDragOver != null)
						onDragOver(false, _dragParams.target);

					// 移回对象
					moveBack();
				}, global, copy);

				_dragParams.dragId = dragId;
			});
		}

		/**
		 * 设置本对象是响应拖拽的(即可以放置物件到本对象上)
		 *
		 * @param placeId 放置ID.如果某个被拖拽的对象的dragId与它相同.则会回调onPlace函数
		 * @param hitTest 当自己感兴趣的对象拖拽到本对象身上时.会回调本函数
		 * @param onPlace 当相同dragId的对象拖拽到本对象上时.会回调本函数.函数声明 onPlace(data:*):void; data为拖拽对象发送来的数据.
		 */
		public function setPlace(placeId:int, hitTest:Function, onPlace:Function):void
		{
			_placeInfo = new PlaceInfo(_target, hitTest, onPlace);

			var items:Vector.<PlaceInfo> = _placeTargets[placeId];

			if (items == null)
			{
				items = new Vector.<PlaceInfo>();
				_placeTargets[placeId] = items;
			}

			if (items.indexOf(_placeInfo) >= 0)
				return;

			items.push(_placeInfo);

			var l:Function = function(event:MouseEvent):void
			{
				if (_placeInfo.dropOn)
				{
					_placeInfo.dropOn = false;

					_placeInfo.onDragOver();
					_placeInfo.onPlace(_placeInfo.data);
				}
			};

			// 对象的mouseover/out事件响应
			_target.addEventListener(MouseEvent.ROLL_OVER, l);

			// 对象从舞台被删除的时候...从放置队列中删除自己
			_target.addEventListener(Event.REMOVED_FROM_STAGE, function(event:Event):void
			{
				var items:Vector.<PlaceInfo> = _placeTargets[placeId];

				items.splice(items.indexOf(_placeInfo), 1);

				// 移除事件
				_target.removeEventListener(MouseEvent.ROLL_OVER, l);
			});
		}

		/**
		 * 获取拖拽区域
		 */
		public function get dragArea():Rectangle
		{
			return _dragArea;
		}

		/**
		 * 设置拖拽区域
		 */
		public function set dragArea(dragArea:Rectangle):void
		{
			_dragArea = dragArea;
		}
	}
}
