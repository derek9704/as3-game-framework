package com.brickmice.view.component
{
	import com.framework.ui.component.ScrollPanel;
	

	/**
	 * @author derek
	 */
	public class McPanel extends ScrollPanel
	{
		/**
		 * 带滚动条的panel
		 * 
		 * @param name 名字
		 * @param width 宽度
		 * @param height 高度
		 */
		public function McPanel(name : String, width : int, height : int, whellAbel : Boolean = true, slimBar:Boolean = false)
		{
			super(name, width, height, new McScrollBar(height, slimBar), new McHScrollBar(width), 50, whellAbel);
		}
	}
}
