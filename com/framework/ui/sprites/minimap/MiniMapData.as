package com.framework.ui.sprites.minimap
{
	import flash.utils.Dictionary;

	/**
	 * 小地图初始化信息
	 * @author derek
	 */
	public class MiniMapData
	{
		/**
		 * 大地图宽度
		 */
		public var width:uint;
		/**
		 * 大地图高度
		 */
		public var height:uint;
		/**
		 * 小地图上所有显示项列表
		 */
		public var items:Dictionary;
		/**
		 * 小地图框框颜色
		 */
		public var rangeColor:int;
		/**
		 * 当移动小地图时候的回调函数
		 */
		public var onMove:Function;

		/**
		 * 构造函数
		 *
		 * @param width 场景宽度
		 * @param height 场景高度
		 * @param items 所有点列表.内容为 MiniMapItem
		 * @param rangeColor 小地图边框颜色
		 * @param onMove 当小地图的容器框移动的时候.会调用该回调方法.onMove的格式应该为 onMove(point:Point):void;
		 */
		public function MiniMapData(width:uint, height:uint, items:Dictionary, rangeColor:int, onMove:Function)
		{
			this.width = width;
			this.height = height;
			this.items = items;
			this.rangeColor = rangeColor;
			this.onMove = onMove;
		}
	}
}
