package com.brickmice.view.component
{
	import com.framework.ui.component.ListPanel;
	

	/**
	 * @author derek
	 */
	public class McList extends ListPanel
	{
		/**
		 * 显示对象PANEL.
		 * 指定显示个数之后.如果设置的数量超出设定个数.
		 * 则会自动产生滚动条
		 * 
		 * @param xCount x方向对象个数
		 * @param yCount y方向对象个数.
		 * @param xSpace x方向对象间隔
		 * @param ySpace y方向对象间隔
		 * @param itemWidth 对象宽度
		 * @param itemHeight 对象高度
		 * @param horizontal 是否为水平方向(当传入items之后.如果传入的数量超出指定数量.则会在指定方向上显示滚动条)
		 * @param bg 背景图片(没有传入的对象是用bg来填充.默认为null)
		 */
		public function McList(xCount : int, yCount : int, xSpace : int, ySpace : int, itemWidth : int, itemHeight : int, horizontal : Boolean, bg : Class = null)
		{
			super('', xCount, yCount, horizontal, xSpace, ySpace, itemWidth, itemHeight, new McScrollBar(yCount * itemHeight), new McHScrollBar(xCount * itemWidth), bg);
		}
	}
}
