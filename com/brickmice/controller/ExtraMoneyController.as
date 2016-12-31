package com.brickmice.controller
{
	import com.brickmice.ControllerManager;
	import com.brickmice.data.Consts;
	import com.brickmice.data.ResourceLoader;
	import com.brickmice.view.component.extramoney.ExtraMoney;
	import com.framework.core.ViewManager;
	import com.framework.ui.sprites.WindowData;

	public class ExtraMoneyController
	{
		
		public function showExtraMoney():void
		{
			if (!ViewManager.hasView(ExtraMoney.NAME))
			{
				var data:WindowData = new WindowData(ExtraMoney);
				ControllerManager.windowController.showWindow(data);
			}else{
				(ViewManager.retrieveView(ExtraMoney.NAME) as ExtraMoney).closeWindow();
			}
		}
		
	}
}
