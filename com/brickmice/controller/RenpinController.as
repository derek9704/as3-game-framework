package com.brickmice.controller
{
	import com.brickmice.ControllerManager;
	import com.brickmice.ModelManager;
	import com.brickmice.data.Consts;
	import com.brickmice.data.ResourceLoader;
	import com.brickmice.view.activity.Renpin;
	import com.framework.core.ViewManager;
	import com.framework.ui.sprites.WindowData;

	public class RenpinController
	{
		
		public function showRenpin():void
		{
			if (!ViewManager.hasView(Renpin.NAME))
			{
				ModelManager.activityModel.getRenpinData(function():void
				{
					ResourceLoader.loadRes([Consts.resourceDic["activity"]], function():void{
						var data:WindowData = new WindowData(Renpin);
						ControllerManager.windowController.showWindow(data);
					}); 
				});
			}else{
				(ViewManager.retrieveView(Renpin.NAME) as Renpin).closeWindow();
			}
		}
		
	}
}
