package com.brickmice.view.component
{
	import com.framework.ui.component.VerticalScrollBar;
	
	import flash.display.MovieClip;
	
	/**
	 * @author derek
	 */
	public class McScrollBar extends VerticalScrollBar
	{
		/**
		 * 滚动条.
		 * 本控件原则上不应该单独使用.如果需要滚动功能.请使用McPanel.
		 * McPanel为自带滚动条的面板.
		 * 
		 * @param height 滚动条高度
		 */
		public function McScrollBar(height : int, slim:Boolean = false)
		{
			var res : ResScrollBar = new ResScrollBar();
			var blockMc:MovieClip = slim ? res._block2 : res._block;
			super(height, res._up, res._down, res._bg, blockMc);
		}
	}
}
