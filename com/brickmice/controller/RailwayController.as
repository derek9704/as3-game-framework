package com.brickmice.controller
{
	import com.brickmice.ControllerManager;
	import com.brickmice.ModelManager;
	import com.brickmice.data.Consts;
	import com.brickmice.data.ResourceLoader;
	import com.brickmice.view.railway.Railway;
	import com.framework.core.ViewManager;
	import com.framework.ui.sprites.WindowData;
	
	public class RailwayController
	{
		public function showRailway(type:String = "train"):void
		{
			ModelManager.railwayModel.getRailwayTraffic(function():void
			{	
				if (!ViewManager.hasView(Railway.NAME))
				{
					ResourceLoader.loadRes([Consts.resourceDic["railway"]], function():void{
						var data:WindowData = new WindowData(Railway, {"type" : type});
						ControllerManager.windowController.showWindow(data);
					}); 
				}else{
					(ViewManager.retrieveView(Railway.NAME) as Railway).setData(type);
				}
			});
		}
	}
}
