package com.framework.ui.sprites.minimap
{
	import flash.geom.Point;

	/**
	 * 小地图上显示的项信息
	 *
	 * @author derek
	 */
	public class MiniMapItem
	{
		/**
		 * 小地图上的位置
		 */
		public var newPoint:Point;
		/**
		 * item的原始位置
		 */
		public var point:Point;
		/**
		 * item的DisplayObject索引.
		 */
		public var doIndex:uint;
		/**
		 * item的id
		 */
		public var id:String;
		/**
		 * 是否在item周围画线
		 */
		public var line:Boolean;
		/**
		 * item周围画线的颜色索引
		 */
		public var lineColorIndex:uint;

		public function MiniMapItem(id:String, point:Point, doIndex:uint = 0, line:Boolean = false, lineColorIndex:uint = 0)
		{
			this.point = point;
			this.doIndex = doIndex;
			this.id = id;
			this.line = line;
			this.lineColorIndex = lineColorIndex;
		}
	}
}
