package com.brickmice.controller
{
	import com.brickmice.ControllerManager;
	import com.brickmice.ModelManager;
	import com.brickmice.data.Consts;
	import com.brickmice.data.ResourceLoader;
	import com.brickmice.view.discovery.Discovery;
	import com.framework.core.ViewManager;
	import com.framework.ui.sprites.WindowData;

	public class DiscoveryController
	{
		
		public function showDiscovery():void
		{
			if (!ViewManager.hasView(Discovery.NAME))
			{
				ModelManager.discoveryModel.getDiscoveryData(function():void
				{	
					ResourceLoader.loadRes([Consts.resourceDic["discovery"]], function():void{
						var data:WindowData = new WindowData(Discovery);
						ControllerManager.windowController.showWindow(data);
					}); 
				});
			}else{
				(ViewManager.retrieveView(Discovery.NAME) as Discovery).closeWindow();
			}
		}
		
	}
}
