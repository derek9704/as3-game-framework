package com.framework.ui.sprites.minimap
{
	import flash.geom.Point;

	/**
	 * 修改minimap上某个点的信息的结构
	 *
	 * @author derek
	 */
	public class MiniMapChangeItemInfo
	{
		/**
		 * 目标itemId
		 */
		public var targetId:String;
		/**
		 * 新的位置
		 */
		public var newPoint:Point;
		/**
		 * 新do的index
		 */
		public var doIndex:int;
		/**
		 * 是否修改描边边线
		 */
		public var changeLine:Boolean;
		/**
		 * 边线的新颜色
		 */
		public var lineColorIndex:int;

		/**
		 * 构造函数
		 *
		 * @param targetId 目标id
		 * @param newPoint 新的坐标
		 * @param doIndex do的新INDEX
		 * @param changeLine 是否修改边线
		 * @param lineColorIndex 边线的颜色
		 */
		public function MiniMapChangeItemInfo(targetId:String, newPoint:Point = null, doIndex:int = -1, changeLine:Boolean = false, lineColorIndex:int = -1)
		{
			this.targetId = targetId;
			this.newPoint = newPoint;
			this.doIndex = doIndex;
			this.changeLine = changeLine;
			this.lineColorIndex = lineColorIndex;
		}
	}
}
