package com.brickmice.controller
{
	import com.brickmice.ControllerManager;
	import com.brickmice.data.Consts;
	import com.brickmice.data.ResourceLoader;
	import com.brickmice.view.vip.Vip;
	import com.framework.core.ViewManager;
	import com.framework.ui.sprites.WindowData;

	public class VipController
	{
		
		public function showVip():void
		{
			if (!ViewManager.hasView(Vip.NAME))
			{
				ResourceLoader.loadRes([Consts.resourceDic["vip"]], function():void{
					var data:WindowData = new WindowData(Vip);
					ControllerManager.windowController.showWindow(data);
				}); 
			}else{
				(ViewManager.retrieveView(Vip.NAME) as Vip).closeWindow();
			}
		}
		
	}
}
