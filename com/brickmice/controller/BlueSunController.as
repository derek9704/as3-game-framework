package com.brickmice.controller
{
	import com.brickmice.ControllerManager;
	import com.brickmice.ModelManager;
	import com.brickmice.data.Consts;
	import com.brickmice.data.ResourceLoader;
	import com.brickmice.view.bluesun.BlueSun;
	import com.brickmice.view.gift.Gift;
	import com.framework.core.ViewManager;
	import com.framework.ui.sprites.WindowData;
	
	public class BlueSunController
	{
		public function showBlueSun(type:String = "flag"):void
		{
			if (!ViewManager.hasView(BlueSun.NAME))
			{
				ResourceLoader.loadRes([Consts.resourceDic["shop"]], function():void{
					var data:WindowData = new WindowData(BlueSun, {"type" : type});
					ControllerManager.windowController.showWindow(data);
				}); 
			}else{
				(ViewManager.retrieveView(BlueSun.NAME) as BlueSun).setData();
			}
		}
		
		public function showGift():void
		{
			if (!ViewManager.hasView(Gift.NAME))
			{
				ModelManager.activityModel.getDailyGiftData(function():void
				{
					ResourceLoader.loadRes([Consts.resourceDic["shop"]], function():void{
						var data:WindowData = new WindowData(Gift);
						ControllerManager.windowController.showWindow(data);
					}); 
				}); 
			}else{
				(ViewManager.retrieveView(Gift.NAME) as Gift).closeWindow();
			}
		}
	}
}
