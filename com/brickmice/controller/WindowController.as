package com.brickmice.controller
{
	import com.brickmice.Main;
	import com.brickmice.view.component.layer.WindowLayer;
	import com.framework.ui.sprites.WindowData;

	/**
	 * 窗口相关逻辑
	 *
	 * @author derek
	 */
	public class WindowController
	{
		// 显示窗体
		public function showWindow(windowData:WindowData):void
		{
			var windowLayer:WindowLayer = Main.self.windowLayer;
			windowLayer.addWindow(windowData);
			return;
		}
	}
}
