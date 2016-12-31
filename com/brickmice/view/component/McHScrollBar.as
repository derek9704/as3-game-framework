package com.brickmice.view.component
{
	import com.framework.ui.component.HScrollBar;
	

	/**
	 * @author derek
	 */
	public class McHScrollBar extends HScrollBar
	{
		/**
		 * 滚动条.
		 * 本控件原则上不应该单独使用.如果需要滚动功能.请使用McPanel.
		 * McPanel为自带滚动条的面板.
		 * 
		 * @param height 滚动条高度
		 */
		public function McHScrollBar(width : int)
		{
			var res : ResHScrollBar = new ResHScrollBar();
			super(width, res._left, res._right, res._bg, res._block, 3, 3);
		}
	}
}
