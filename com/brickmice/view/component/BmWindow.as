package com.brickmice.view.component
{
	import com.framework.ui.sprites.CWindow;
	import com.brickmice.view.component.BmButton;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * @author derek
	 */
	public class BmWindow extends CWindow
	{

		/**
		 * 窗体基类
		 * 
		 * @param name 窗体名字
		 */
		public function BmWindow(name : String, mc:MovieClip)
		{
			// 构造窗体
			super(name, mc.width, mc.height, null, null, 0, 0);
			addChildEx(mc);
			
			if(mc.hasOwnProperty("_closeBtn")){
				new BmButton(mc._closeBtn, function(event : MouseEvent) : void
				{
					closeWindow();
				});
			}
		}
	}
}
