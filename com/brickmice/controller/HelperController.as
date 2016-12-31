package com.brickmice.controller
{
	import com.brickmice.ControllerManager;
	import com.brickmice.data.Consts;
	import com.brickmice.data.ResourceLoader;
	import com.brickmice.view.helper.Helper;
	import com.framework.core.ViewManager;
	import com.framework.ui.sprites.WindowData;

	public class HelperController
	{
		
		public function showHelper():void
		{
			if (!ViewManager.hasView(Helper.NAME))
			{
				ResourceLoader.loadRes([Consts.resourceDic["helper"]], function():void{
					var data:WindowData = new WindowData(Helper);
					ControllerManager.windowController.showWindow(data);
				}); 
			}else{
				(ViewManager.retrieveView(Helper.NAME) as Helper).closeWindow();
			}
		}
		
	}
}
