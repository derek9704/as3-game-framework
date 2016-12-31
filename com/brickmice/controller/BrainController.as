package com.brickmice.controller
{
	import com.brickmice.ControllerManager;
	import com.brickmice.ModelManager;
	import com.brickmice.data.Consts;
	import com.brickmice.data.ResourceLoader;
	import com.brickmice.view.brain.Brain;
	import com.framework.core.ViewManager;
	import com.framework.ui.sprites.WindowData;
	
	public class BrainController
	{
		public function showBrain():void
		{
			ModelManager.brainModel.getBrainData(function():void
			{	
				if (!ViewManager.hasView(Brain.NAME))
				{
					ResourceLoader.loadRes([Consts.resourceDic["brain"]], function():void{
						var data:WindowData = new WindowData(Brain);
						ControllerManager.windowController.showWindow(data);
					}); 
				}else{
					(ViewManager.retrieveView(Brain.NAME) as Brain).setData();
				}
			});
		}
	}
}
