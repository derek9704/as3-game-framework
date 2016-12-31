package com.framework.ui.basic.sprite
{

	/**
	 * 可接收拖拽对象的信息
	 * @author derek
	 */
	public class PlaceInfo
	{
		/**
		 * 可以放置物件的对象
		 */
		public var target:CSprite;
		/**
		 * 被拖拽对象是否进入/离开本对象区域
		 *
		 * 格式 hitTest(value:Boolean):void; value =  两个物件是否碰撞(有重叠区域)
		 */
		public var hitTest:Function;
		/**
		 * 当被拖拽对象放置在本对象上触发
		 * 格式 onPlace(data:*):void; data = 被拖拽对象发送过来的数据(预先定义好的)
		 */
		public var onPlace:Function;
		/**
		 * 是否可以放置对象
		 */
		public var enable:Boolean;
		/**
		 * 上次hitTest的状态.
		 */
		public var oldStatus:Boolean;
		/**
		 * 鼠标移动到上面
		 */
		public var mouseOver:Boolean;
		public var dropOn:Boolean = false;
		public var data:*;
		public var onDragOver:Function;

		/**
		 * 构造函数
		 */
		public function PlaceInfo(target:CSprite, hitTest:Function, onPlace:Function)
		{
			this.target = target;
			this.hitTest = hitTest;
			this.onPlace = onPlace;
			enable = true;
			oldStatus = false;
		}
	}
}
